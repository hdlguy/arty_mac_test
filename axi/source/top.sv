
module top(
    input   logic       clkin100,
    input   logic       resetn,
    output  logic[7:0]  led
);

    logic [11:0]bram_addr;
    logic bram_clk;
    logic [31:0]bram_din;
    logic [31:0]bram_dout;
    logic bram_en;
    logic bram_rst;
    logic[3:0] bram_we;
    
  
    logic init, axi_aclk, axi_aresetn;
    system system_i(
        .clk_in     (clkin100),
        .init       (init),
        .resetn     (resetn),
        .axi_aclk   (axi_aclk),
        .axi_aresetn(axi_aresetn),
        //
        .bram_addr  (bram_addr),
        .bram_clk   (bram_clk),
        .bram_din   (bram_din),
        .bram_dout  (bram_dout),
        .bram_en    (bram_en),
        .bram_rst   (bram_rst),
        .bram_we    (bram_we)        
    );
    
    test_bram bram_inst (
        .clka   (bram_clk),  
        .ena    (bram_en),    
        .wea    (bram_we),    
        .addra  (bram_addr[11:2]),
        .dina   (bram_din),  
        .douta  (bram_dout) 
    );    
    
       
    logic[27:0] led_count=-1;
    always_ff @(posedge axi_aclk) begin
        led_count <= led_count - 1;
        led <= led_count[27 -: 8];
        init <= (led_count == 0);
    end
    
    ila_top ila_inst (.clk(bram_clk), .probe0({bram_addr, bram_din, bram_dout, bram_en, bram_rst, bram_we})); // 82
    
        
endmodule
