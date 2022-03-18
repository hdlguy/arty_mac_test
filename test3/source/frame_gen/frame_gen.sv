
module frame_gen (
    input  logic            clk,            // 100MHz system clock.
    input  logic            enable,
    //
    input  logic            aclk,    // 25MHz tx clock from Phy
    output logic [7 : 0]    tdata,
    output logic            tvalid,
    output logic            tlast,
    output logic            tuser,
    input  logic            tready
);

    localparam int Nframe = 1024;

    logic [0:5][7:0] d_address = {8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}; // the broadcast address.
    logic [0:5][7:0] s_address = {8'h00, 8'h0a, 8'h35, 8'h00, 8'h01, 8'h02}; 
    
    logic [0:3][7:0] header1 = {8'hde, 8'had, 8'hbe, 8'hef}; 
    logic [15:0] len = Nframe - 14; 

    logic fifo_full, fifo_empty;
    logic [8:0] fifo_din, fifo_dout;
    logic enable_q;
    always_ff @(posedge clk) enable_q <= enable;
    frame_gen_fifo frame_gen_fifo_inst (.wr_clk(clk), .full(fifo_full), .wr_en(enable_q), .din(fifo_din), .rd_clk(aclk), .empty(fifo_empty), .rd_en(tready), .dout(fifo_dout));
    assign tvalid = ~fifo_empty;
    assign tlast = fifo_dout[8];
    assign tdata = fifo_dout[7:0];
    assign tuser = 0;
    
    logic [15:0] count = 0;
    always_ff @(posedge clk) begin
        if (0 == fifo_full) begin
            if (Nframe-1 == count) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

    always_comb begin
/*
        if  (count < 4) begin
            fifo_din[7:0] = header1[count];
        end else begin
            fifo_din[7:0] = count[7:0];
        end
*/
        if  (count < 6) begin
            fifo_din[7:0] = d_address[count];
        end else if ((count > 5) && (count < 12)) begin
            fifo_din[7:0] = s_address[count-6];
        end else if (count == 12)  begin
            fifo_din[7:0] = len[15:8];
        end else if (count == 13)  begin
            fifo_din[7:0] = len[7:0];
        end else begin
            fifo_din[7:0] = count[7:0];
        end

        if (count == Nframe-1) fifo_din[8] = 1; else fifo_din[8] = 0; // put the tlast into the fifo.
    end
        
endmodule

