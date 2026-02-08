
module frame_gen (
    //
    input  logic            clk,
    input  logic            enable,
    // fifo interface
    output logic [7 : 0]    m_axis_tdata,
    output logic            m_axis_tvalid,
    output logic            m_axis_tlast,
    output logic            m_axis_tuser,
    input  logic            m_axis_tready
);

    localparam int Nframe = 8000;

    logic [0:5][7:0] d_address = {8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}; // the broadcast address.
    logic [0:5][7:0] s_address = {8'h00, 8'h0a, 8'h35, 8'h00, 8'h01, 8'h02}; 

    logic [15:0] len = Nframe - 14; 

    assign m_axis_tvalid = enable;

    logic [15:0] count = 0;
    always_ff @(posedge clk) begin
        if (enable) begin
            if (m_axis_tready) begin
                if (Nframe-1 == count) begin
                    count <= 0;
                end else begin
                    count <= count + 1;
                end
            end
        end else begin
            count <= 0;
        end
    end

    always_comb begin

        if  (count < 6) begin
            m_axis_tdata = d_address[count];
        end else if ((count > 5) && (count < 12)) begin
            m_axis_tdata = s_address[count-6];
        end else if (count == 12)  begin
            m_axis_tdata = len[15:8];
        end else if (count == 13)  begin
            m_axis_tdata = len[7:0];
        end else begin
            m_axis_tdata = count[7:0];
        end

        if (count == Nframe-1) m_axis_tlast = 1; else m_axis_tlast = 0;  // assert tlast on last byte.
    end
        
endmodule

