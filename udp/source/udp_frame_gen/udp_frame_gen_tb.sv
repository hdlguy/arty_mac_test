`timescale 1ns / 1ps

module udp_frame_gen_tb ();

    logic            enable;
    logic [7 : 0]    m_tdata;
    logic            m_tvalid;
    logic            m_tlast;
    logic            m_tuser;
    logic            m_tready=0;

    logic  clk = 0; localparam  clk_period = 10; always #( clk_period/2)  clk =  ~clk;

    udp_frame_gen uut (.*);

    initial begin
        enable = 0;
        #(clk_period*100);
        enable = 1;
    end
    
    always_ff @(posedge clk) m_tready <= ~m_tready;

endmodule


/*
*/
