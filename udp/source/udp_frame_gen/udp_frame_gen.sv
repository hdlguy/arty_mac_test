
module udp_frame_gen (
    //
    input  logic            clk,
    input  logic            enable,
    // fifo interface
    output logic [7 : 0]    m_tdata,
    output logic            m_tvalid,
    output logic            m_tlast,
    output logic            m_tuser,
    input  logic            m_tready
);

    localparam int Lframe = 1000;
    localparam int Lgap   = 100;

    logic enable_q=0;
    always_ff @(posedge clk) enable_q <= enable;

    logic [15:0] count=0, pcount=0;
    logic inc_count, rst_count, inc_pcount;

    logic[3:0] state=0, next_state;
    always_comb begin

        next_state = state;
        m_tvalid = 0;
        rst_count = 0;
        inc_count = 0;
        inc_pcount = 0;

        case (state)

            0: begin
                next_state = 1;
                rst_count = 1;
                inc_pcount = 1;
            end

            1: begin
                if (enable_q) begin
                    next_state = 2;
                end
            end

            2: begin
                if (m_tready) begin
                    if (count == Lframe-1) begin
                        next_state = 3;
                    end
                    inc_count = 1;
                end
                m_tvalid = 1;
            end

            3: begin
                next_state = 4;
                rst_count = 1;
            end

            4: begin
                if (count == Lgap-1) begin
                    next_state = 5;
                end
                inc_count = 1;
            end

            5: begin
                next_state = 0;
            end

        endcase
        
    end

    always_ff @(posedge clk) state <= next_state;


    always_ff @(posedge clk) begin
        if (rst_count) begin
            count <= 0;
        end else begin
            if (inc_count) begin
                count <= count + 1;
            end
        end
        if (inc_pcount) pcount <= pcount + 1;
    end


    assign m_tdata = count[7:0] + pcount[7:0];
    assign m_tuser = 0;

    always_comb begin
        if ((count == Lframe-1) && (m_tvalid)) m_tlast = 1; else m_tlast = 0;  // assert tlast on last byte.
    end
        
endmodule

