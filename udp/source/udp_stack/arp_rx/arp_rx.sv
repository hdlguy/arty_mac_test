// arp_rx.sv - receives raw ethernet frames from the rx mac fifo.
// If the frame is an arp request, fields are extracted for the arp reply.
module arp_rx #(
    parameter logic[47:0] local_mac     = 48'h00_0a_35_01_02_03,
    parameter logic[31:0] local_ip      = 32'h10_00_00_80,          // 16.0.0.128
    parameter logic[15:0] local_port    = 16'h04d2                  // 1234
) (
    input   logic                   clk,
    // axi-stream interface from rx fifo.
    input   logic                   rx_fifo_tvalid,
    output  logic                   rx_fifo_tready, 
    input   logic[7:0]              rx_fifo_tdata,
    input   logic                   rx_fifo_tlast, 
    input   logic                   rx_fifo_tuser, 
    // Arp output
    output  logic                   dv_out = 0,
    output  logic[47:0]             remote_mac,
    output  logic[31:0]             remote_ip,
    // UDP message output
    output  logic                   udp_tvalid,
    output  logic[7:0]              udp_tdata,
    output  logic                   udp_tlast, 
    output  logic                   udp_tuser   // not used
);

    localparam int Narp = 42;  // the number of bytes in an Arp packet.

    logic[Narp-1:0][7:0] wr_byte = 0; // byte array.

    // rename some bytes to ethernet fields.
    logic[47:0] dest_mac;
    assign dest_mac = {wr_byte[0], wr_byte[1], wr_byte[2], wr_byte[3], wr_byte[4], wr_byte[5]};
    logic[47:0] src_mac;
    assign src_mac =  {wr_byte[6], wr_byte[7], wr_byte[8], wr_byte[9], wr_byte[10], wr_byte[11]};
    logic[15:0] frame_type;
    assign frame_type = {wr_byte[12], wr_byte[13]};

    // rename some of the bytes to arp fields.
    logic[15:0] op_int;
    assign op_int = {wr_byte[20], wr_byte[21]};
    logic[47:0] remote_mac_int;
    assign remote_mac_int = {wr_byte[22], wr_byte[23], wr_byte[24], wr_byte[25], wr_byte[26], wr_byte[27]};
    logic[31:0] remote_ip_int;
    assign remote_ip_int = {wr_byte[28], wr_byte[29], wr_byte[30], wr_byte[31]};
    logic[31:0] target_ip_int;
    assign target_ip_int = {wr_byte[38], wr_byte[39], wr_byte[40], wr_byte[41]};

    // rename some of the bytes to IP fields
    logic[7:0] protocol;
    assign protocol = wr_byte[23];
    logic[31:0] dest_ip;
    assign dest_ip = {wr_byte[30], wr_byte[31], wr_byte[32], wr_byte[33]};
    
    // rename some of the bytes to UDP fields
    logic[15:0] dest_port;
    assign dest_port = {wr_byte[36], wr_byte[37]};
    logic[15:0] udp_length;
    assign udp_length = {wr_byte[38], wr_byte[39]};

    assign rx_fifo_tready = 1; // always ready to receive a byte, no backpressure.
    
    logic dv_in, dv_in_q=0;
    assign dv_in = (rx_fifo_tvalid & rx_fifo_tready);
    
    logic tlast_q = 1, pre_dv_out = 0;
    logic[ 7:0] tdata_q;
    logic[15:0] byte_count;
    logic udp_mess_active=0;
    always_ff @(posedge clk) begin
    
        dv_in_q <= dv_in;
        
        if (dv_in) begin
            tlast_q <= rx_fifo_tlast;
            tdata_q <= rx_fifo_tdata;
                    
            if (tlast_q) begin
                byte_count <= 0; 
            end else begin
                byte_count <= byte_count + 1;
            end
        end
        
        if (dv_in_q) begin            
            wr_byte[byte_count] <= tdata_q;
            if (tlast_q) pre_dv_out <= 1; else pre_dv_out <= 0;
        end else begin
            pre_dv_out <= 0;
        end

        if ((pre_dv_out) && (frame_type==16'h0806) && (op_int==16'h0001) && (target_ip_int==local_ip)) begin  // if an arp frame
            remote_mac <= remote_mac_int;
            remote_ip  <= remote_ip_int;
            dv_out <= 1;
        end else begin
            dv_out <= 0;
        end

        if ((byte_count==41) && (dest_mac==local_mac) && (protocol==17) && (dest_ip==local_ip) && (dest_port==local_port)) udp_mess_active <= 1; // start of udp message
        if (byte_count==(udp_length+42-8-1)) udp_mess_active <= 0;  // end of udp message
        
    end
    
    assign udp_tdata = tdata_q;
    //assign udp_tlast = (byte_count==(udp_length+42-8-1)) ? 1'b1 : 1'b0;
    assign udp_tlast = (byte_count==(udp_length+42-8-1));
    assign udp_tuser = 0;
    assign udp_tvalid = dv_in_q & udp_mess_active;
    
endmodule

/*
*/
