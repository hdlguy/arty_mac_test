//  a module to just keep the udp tx fifo full of frames for testing.
module udp_frame_gen (
    input   logic       clk,
    input   logic       enable,
    output  logic       m_tvalid,
    input   logic       m_tready, 
    output  logic[7:0]  m_tdata,
    output  logic       m_tlast, 
    output  logic       m_tuser
);

    localparam int Nudp = 32;

    logic enable_q=0; always_ff @(posedge clk) enable_q <= enable;

    logic[9:0] count=0;
    always_ff @(posedge clk) begin
        if ((m_tready) && (m_tvalid)) begin
            count <= count + 1;
        end
    end
    
    assign m_tdata = count;
    assign m_tlast = (count == Nudp-1) ? 1 : 0;
    assign m_tvalid = (count < Nudp) ? enable_q : 0;
    assign m_tuser = 0;

endmodule


