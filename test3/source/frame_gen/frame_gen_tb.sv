`timescale 1ns / 1ps


module frame_gen_tb ();

    logic            reset;
    logic [7 : 0]    tdata;
    logic            tvalid;
    logic            tlast;
    logic            tuser;
    logic            tready;

    logic  clk = 0; localparam  clk_period = 10; always #( clk_period/2)  clk =  ~clk;
    logic aclk = 0; localparam aclk_period = 26; always #(aclk_period/2) aclk = ~aclk;

    frame_gen uut (.*);

    initial begin

        reset = 1;
        #(clk_period*10);

        reset = 0;
        #(clk_period*10);
        
    end
    
    initial begin
    
        tready = 0;
        #(aclk_period*20);
        
        forever begin
            tready = ~tready;
            #(aclk_period*1);
        end
        
    end

endmodule


/*
module frame_gen (
    input  logic            clk,            // 100MHz system clock.
    input  logic            reset,
    //
    input  logic            aclk,    // 25MHz tx clock from Phy
    output logic [7 : 0]    tdata,
    output logic            tvalid,
    output logic            tlast,
    output logic            tuser,
    output logic            tready
);
*/
