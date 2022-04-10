//
module arp_tx #(
    parameter logic[47:0]   local_mac = 48'h00_0a_35_01_02_03,
    parameter logic[31:0]   local_ip  = 32'h10_00_00_80
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
    input   logic           udp_tuser
);

    // assign values to the 42 byte arp frame.
    logic[0:41][7:0] tx_bytes;
    assign tx_bytes[ 0: 5] = remote_mac;
    assign tx_bytes[ 6:11] = local_mac;
    assign tx_bytes[12:13] = 16'h0806;
    assign tx_bytes[14:15] = 16'h0001;
    assign tx_bytes[16:17] = 16'h0800;
    assign tx_bytes[   18] = 8'h06;
    assign tx_bytes[   19] = 8'h04;
    assign tx_bytes[20:21] = 16'h0002;
    assign tx_bytes[22:27] = local_mac;
    assign tx_bytes[28:31] = local_ip;
    assign tx_bytes[32:37] = remote_mac;
    assign tx_bytes[38:41] = remote_ip;        
    
    logic[7:0] byte_count=0;    

    assign tx_fifo_tdata = tx_bytes[byte_count];

    logic byte_count_rst, arp_complete=0, set_arp_complete, new_arp=0;
    logic[3:0] state=0, next_state;
    always_comb begin

        // defaults
        next_state = state;
        tx_fifo_tvalid = 0;
        tx_fifo_tlast = 0;
        tx_fifo_tuser = 0;
        byte_count_rst = 0;
        set_arp_complete = 0;
        
        case (state)

            0: begin
                next_state = 1;
                byte_count_rst = 1;
            end

            1: begin
                if (new_arp) begin
                    next_state = 2;
                end else begin
                    if (udp_tvalid) begin
                        next_state = 4;
                    end
                end
                byte_count_rst = 1;
            end

            // begin arp stuff
            2: begin
                if (byte_count == 41) begin
                    next_state = 3;
                    tx_fifo_tlast = 1;
                end
                tx_fifo_tvalid = 1;
            end
            
            3: begin
                next_state = 0;
                set_arp_complete = 1;
            end

            // begin udp stuff
            4: begin
                next_state = 0;
            end
            
            default: begin
                next_state = 0;
            end

        endcase
    end

    always_ff @(posedge clk) state <= next_state;
        

    always_ff @(posedge clk) begin
        if (byte_count_rst) begin
            byte_count <= 0;
        end else begin
            if ((tx_fifo_tvalid) && (tx_fifo_tready)) begin
                byte_count <= byte_count + 1;
            end
        end
    end
    
    
    always_ff @(posedge clk) begin
        if (set_arp_complete) arp_complete <= 1;
        if (arp_dv_in) begin
            new_arp <= 1;
        end else begin
            if (set_arp_complete) new_arp <= 0;
        end
    end

    assign udp_tready = arp_complete;


endmodule


