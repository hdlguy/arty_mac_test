// frame_rx.sv - receives raw ethernet frames from the rx mac fifo
// and writes the values to an array of 32 bit registers.
// The raw frames begin with 14 bytes of header that can be discarded.
// Then there is a two bytes of sync === 0xF3, 0xFA.
// Then there is a four byte header === TBD.
// Then a variable number of bytes to be written to the register file as follows:
// wr_val[0][ 7: 0] <= byte[0]
// wr_val[0][15: 8] <= byte[1]
// wr_val[0][23:16] <= byte[2]
// wr_val[0][31:24] <= byte[3]
// wr_val[1][ 7: 0] <= byte[4]
// wr_val[1][15:08] <= byte[5]
// ...
// The length of the frame determines the number of register bytes written. 
// rx_tlast signals the last byte to be written.
module udp_frame_rx #(
    parameter int Nregs = 16
)(
    input   logic                   clk,
    // axi-stream interface from rx fifo.
    input   logic                   rx_tvalid,
    output  logic                   rx_tready, 
    input   logic[7:0]              rx_tdata,
    input   logic                   rx_tlast, 
    input   logic                   rx_tuser, 
    // register interface
    output  logic                   dv_out = 0,
    output  logic[Nregs-1:0][31:0]  wr_val // register file
);
    
    logic[Nregs*4-1:0][7:0] wr_byte = 0; // register file in byte array format.

    assign rx_tready = 1; // always ready to receive a byte, no backpressure.
    
    logic dv_in, dv_in_q=0;
    assign dv_in = (rx_tvalid & rx_tready);
    
    logic [$clog2(Nregs*4):0] byte_addr;
    
    logic tlast_q=1, pre_dv_out=0;
    logic[7:0] tdata_q;
    logic[15:0] byte_count=0;
    always_ff @(posedge clk) begin
    
        dv_in_q <= dv_in;
        
        if (dv_in) begin
        
            tlast_q <= rx_tlast;
            tdata_q <= rx_tdata;
                    
            if (tlast_q) begin
                byte_count <= 0; 
            end else begin
                byte_count <= byte_count + 1;
            end
            
        end
        
        if ((dv_in_q) && (byte_addr<Nregs*4)) begin            
            wr_byte[byte_addr] <= tdata_q;
            if (tlast_q) pre_dv_out <= 1; else pre_dv_out <= 0;
        end else begin
            pre_dv_out <= 0;
        end

        if (pre_dv_out) begin
            wr_val <= wr_byte;
            dv_out <= 1;
        end else begin
            dv_out <= 0;
        end
        
    end
    
    assign byte_addr = byte_count;

endmodule

/*
*/
