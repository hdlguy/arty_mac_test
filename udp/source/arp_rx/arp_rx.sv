// arp_rx.sv - receives raw ethernet frames from the rx mac fifo.
// If the frame is an arp request, fields are extracted for the arp reply.
module arp_rx #(
    parameter logic[31:0] local_ip  = 32'h10_00_00_80           // 16.0.0.128
) (
    input   logic                   clk,
    // axi-stream interface from rx fifo.
    input   logic                   rx_fifo_tvalid,
    output  logic                   rx_fifo_tready, 
    input   logic[7:0]              rx_fifo_tdata,
    input   logic                   rx_fifo_tlast, 
    input   logic                   rx_fifo_tuser, 
    // 
    output  logic                   dv_out = 0,
    output  logic[47:0]             remote_mac,
    output  logic[31:0]             remote_ip
);

    localparam int Narp = 42;  // the number of bytes in an Arp packet.

    logic[Narp-1:0][7:0] wr_byte = 0; // byte array.

    // rename some of the bytes to arp fields.
    logic[47:0] remote_mac_int;
    assign remote_mac_int = {wr_byte[22], wr_byte[23], wr_byte[24], wr_byte[25], wr_byte[26], wr_byte[27]};
    logic[31:0] remote_ip_int;
    assign remote_ip_int = {wr_byte[28], wr_byte[29], wr_byte[30], wr_byte[31]};
    logic[15:0] frame_type_int;
    assign frame_type_int = {wr_byte[12], wr_byte[13]};
    logic[15:0] op_int;
    assign op_int = {wr_byte[20], wr_byte[21]};
    logic[31:0] target_ip_int;
    assign target_ip_int = {wr_byte[38], wr_byte[39], wr_byte[40], wr_byte[41]};
    

    assign rx_fifo_tready = 1; // always ready to receive a byte, no backpressure.
    
    logic dv_in, dv_in_q=0;
    assign dv_in = (rx_fifo_tvalid & rx_fifo_tready);
    
    logic tlast_q = 1, pre_dv_out = 0;
    logic[ 7:0] tdata_q;
    logic[15:0] byte_count;
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

        if ((pre_dv_out) && (frame_type_int==16'h0806) && (op_int==16'h0001) && (target_ip_int==local_ip)) begin  // if an arp frame
            remote_mac <= remote_mac_int;
            remote_ip  <= remote_ip_int;
            dv_out <= 1;
        end else begin
            dv_out <= 0;
        end
        
    end
    
endmodule

/*
*/
