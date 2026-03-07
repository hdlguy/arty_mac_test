`timescale 1ns / 1ps


module frame_gen_tb ();

    logic            enable;
    logic [7 : 0]    m_axis_tdata;
    logic            m_axis_tvalid;
    logic            m_axis_tlast;
    logic            m_axis_tuser;
    logic            m_axis_tready;

    logic  clk = 0; localparam  clk_period = 10; always #( clk_period/2)  clk =  ~clk;

    frame_gen uut (.*);

    initial begin
        enable = 0;
        #(clk_period*100);
        enable = 1;
    end
    
    initial begin
    
        m_axis_tready = 0;
        #(clk_period*20);
        
        forever begin
            m_axis_tready = ~m_axis_tready;
            #(clk_period*1);
        end
        
    end

endmodule


/*
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
*/
