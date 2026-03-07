//  This module waits for arp requests and sends arp replies in response.
//  It also accepts udp payloads, prepends the correct header bytes and sends udp frames.
//
module arp_tx #(
    parameter logic[47:0]   local_mac   = 48'h00_0a_35_01_02_03,
    parameter logic[31:0]   local_ip    = 32'h10_00_00_80,
    parameter logic[15:0]   local_port  = 16'h04d2, // 1234;
    parameter logic[15:0]   remote_port = 16'h04d2  // 1234;
) (
    input   logic           clk,
    // axi-stream interface to tx fifo.
    output  logic           tx_fifo_tvalid,
    input   logic           tx_fifo_tready, 
    output  logic[7:0]      tx_fifo_tdata,
    output  logic           tx_fifo_tlast, 
    output  logic           tx_fifo_tuser, 
    // Arp parameters
    input   logic           arp_dv_in, // indicates when to send an ARP reply frame.
    input   logic[47:0]     remote_mac,
    input   logic[31:0]     remote_ip,
    // UDP message input
    input   logic           udp_tvalid,
    output  logic           udp_tready,
    input   logic[7:0]      udp_tdata,
    input   logic           udp_tlast, 
    input   logic           udp_tuser,
    // length of UDP message
    input   logic           length_tvalid,
    output  logic           length_tready,
    input   logic[15:0]     length_tdata
);

    
    logic[47:0]     remote_mac_q;
    logic[31:0]     remote_ip_q;

    // assign values to the 42 byte arp frame.
    logic[0:41][7:0] arp_bytes;
    assign arp_bytes[ 0: 5] = remote_mac_q;
    assign arp_bytes[ 6:11] = local_mac;
    assign arp_bytes[12:13] = 16'h0806;
    assign arp_bytes[14:15] = 16'h0001;
    assign arp_bytes[16:17] = 16'h0800;
    assign arp_bytes[   18] = 8'h06;
    assign arp_bytes[   19] = 8'h04;
    assign arp_bytes[20:21] = 16'h0002;
    assign arp_bytes[22:27] = local_mac;
    assign arp_bytes[28:31] = local_ip;
    assign arp_bytes[32:37] = remote_mac_q;
    assign arp_bytes[38:41] = remote_ip_q;        
 
    // some temporary assignments
    logic[15:0] udp_len=0;
    logic[0:1][7:0] total_tx_length;
    assign total_tx_length = 20 + 8 + 1 + udp_len;
    logic[0:1][7:0] ip_id = 16'habcd;  // this gets incremented after each tx packet.
    logic[0:1][7:0] header_checksum;
    //logic[0:1][7:0] remote_port = local_port;
    logic[0:1][7:0] udp_header_length = 8 + 1 + udp_len;

    // assign values to the 42 bytes (eth+ip+udp=14+20+8) of header.   
    // eth 14 bytes
    logic[0:41][7:0] header_bytes;
    assign header_bytes[ 0: 5] = remote_mac_q;
    assign header_bytes[ 6:11] = local_mac;
    assign header_bytes[12:13] = 16'h0800;
    // ip 20 bytes
    assign header_bytes[14:15] = 16'h4500;
    assign header_bytes[16:17] = total_tx_length;
    assign header_bytes[18:19] = ip_id;
    assign header_bytes[20:21] = 16'h4000;
    assign header_bytes[22:23] = 16'h4011;
    assign header_bytes[24:25] = header_checksum;
    assign header_bytes[26:29] = local_ip;
    assign header_bytes[30:33] = remote_ip_q;
    // udp 8 bytes     
    assign header_bytes[34:35] = local_port;        
    assign header_bytes[36:37] = remote_port;        
    assign header_bytes[38:39] = udp_header_length;        
    assign header_bytes[40:41] = 16'h0000;        // ignore udp checksum.

 
    // state machine   
    logic[7:0] byte_count=0;    
    logic byte_count_rst, arp_complete=0, set_arp_complete, arp_pending=0, arp_active, inc_ip_id;
    logic payload_active, header_tvalid, header_active;
    logic arp_tvalid, arp_tuser;
    logic[3:0] state=0, next_state;
    always_comb begin

        // defaults
        next_state = state;
        arp_tvalid = 0;
        byte_count_rst = 0;
        arp_active = 0;
        set_arp_complete = 0;
        payload_active = 0;
        header_tvalid = 0;
        header_active = 0;
        length_tready = 0;
        inc_ip_id = 0;
        
        case (state)

            0: begin
                next_state = 1;
                byte_count_rst = 1;
                inc_ip_id = 1;
            end

            1: begin
                if (arp_pending) begin  // arp requests are rare but arp replies get priority.
                    next_state = 2;
                end else begin
                    if ((length_tvalid) && (arp_complete)) begin   // don't send udp frames until an arp cycle completes.
                        next_state = 4;
                    end
                end
                byte_count_rst = 1;
            end

            // begin arp stuff
            2: begin
                if ((byte_count == 41) && (tx_fifo_tready)) begin
                    next_state = 3;
                end
                arp_tvalid = 1;
                arp_active = 1;
            end
            
            3: begin
                next_state = 0;
                set_arp_complete = 1;
                arp_active = 1;
            end

            // begin udp stuff
            4: begin
                next_state = 5;
                byte_count_rst = 1;
                length_tready = 1;
            end
            
            // first send the headers for udp
            5: begin
                if ((byte_count == 41) && (tx_fifo_tready)) begin
                    next_state = 6;
                end
                header_tvalid = 1;
                header_active = 1;
            end            

            // now send the udp data payload
            6: begin
                if ((udp_tvalid) && (udp_tready) && (udp_tlast)) begin
                    next_state = 0;
                end
                payload_active = 1;
            end            
                        
            default: begin
                next_state = 0;
            end

        endcase
    end

    always_ff @(posedge clk) state <= next_state;
        

    // count bytes of the transmitted packet.
    always_ff @(posedge clk) begin
        if (byte_count_rst) begin
            byte_count <= 0;
        end else begin
            if ((tx_fifo_tvalid) && (tx_fifo_tready)) begin
                byte_count <= byte_count + 1;
            end
        end
    end
    
    
    // latch arp complete and arp pending signals.
    always_ff @(posedge clk) begin
        if (set_arp_complete) arp_complete <= 1;
        if (arp_dv_in) begin
            arp_pending <= 1;
            remote_mac_q <= remote_mac;
            remote_ip_q  <= remote_ip;
        end else begin
            if (set_arp_complete) arp_pending <= 0;
        end
    end


    // mux between arp and udp
    assign arp_tuser = 0;
    assign arp_tlast = (byte_count==41) ? 1 : 0;
    always_comb begin  
        if (arp_active) begin
            udp_tready = 0;
            tx_fifo_tvalid = arp_tvalid;
            tx_fifo_tdata  = arp_bytes[byte_count];
            tx_fifo_tlast  = arp_tlast;
            tx_fifo_tuser  = arp_tuser;  
        end else begin
            if (header_active) begin
                udp_tready = 0; 
                tx_fifo_tvalid = header_tvalid;
                tx_fifo_tdata  = header_bytes[byte_count];
                tx_fifo_tlast  = 0;
                tx_fifo_tuser  = 0;            
            end else begin
                if (payload_active) begin
                    udp_tready = tx_fifo_tready; 
                    tx_fifo_tvalid = udp_tvalid;
                    tx_fifo_tdata  = udp_tdata;
                    tx_fifo_tlast  = udp_tlast;
                    tx_fifo_tuser  = udp_tuser;
                end else begin
                    udp_tready = 0; 
                    tx_fifo_tvalid = 0;
                    tx_fifo_tdata  = 0;
                    tx_fifo_tlast  = 0;
                    tx_fifo_tuser  = 0;         
                end
            end
        end              
    end             
    
    always_ff @(posedge clk) if ((length_tready) && (length_tvalid)) udp_len <= length_tdata;   // latch the length of the udp payload.
    
    always_ff @(posedge clk) if (inc_ip_id) ip_id <= ip_id + 1;

    // checksum calculation uses tricky, one's complement addition followed by taking the one's complement.
    logic[19:0] cs1;
    logic[16:0] cs2;
    logic[15:0] cs3;
    always_ff @(posedge clk) begin
        cs1 <=  header_bytes[14:15]+header_bytes[16:17]+header_bytes[18:19]+header_bytes[20:21]+header_bytes[22:23]+header_bytes[26:27]+header_bytes[28:29]+header_bytes[30:31]+header_bytes[32:33];
        cs2 <= cs1[15:0] + cs1[19:16];
    end
    assign cs3 = cs2[15:0] + cs2[16];
    assign header_checksum = ~cs3;

endmodule


