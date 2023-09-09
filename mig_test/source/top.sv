//
module top(
    input   logic   clkin100,
    //
    output logic  [13:0]  ddr3_sdram_addr,
    output logic  [2:0]   ddr3_sdram_ba,
    output logic          ddr3_sdram_cas_n,
    output logic  [0:0]   ddr3_sdram_ck_n,
    output logic  [0:0]   ddr3_sdram_ck_p,
    output logic  [0:0]   ddr3_sdram_cke,
    output logic  [0:0]   ddr3_sdram_cs_n,
    output logic  [1:0]   ddr3_sdram_dm,
    inout  logic  [15:0]  ddr3_sdram_dq,
    inout  logic  [1:0]   ddr3_sdram_dqs_n,
    inout  logic  [1:0]   ddr3_sdram_dqs_p,
    output logic  [0:0]   ddr3_sdram_odt,
    output logic          ddr3_sdram_ras_n,
    output logic          ddr3_sdram_reset_n,
    output logic          ddr3_sdram_we_n
);
    
    logic [71:0]    S_AXIS_S2MM_CMD_tdata;
    logic           S_AXIS_S2MM_CMD_tready;
    logic           S_AXIS_S2MM_CMD_tvalid;
    //
    logic [63:0]    S_AXIS_S2MM_tdata;
    logic [7:0]     S_AXIS_S2MM_tkeep;
    logic           S_AXIS_S2MM_tlast;
    logic           S_AXIS_S2MM_tready;
    logic           S_AXIS_S2MM_tvalid;
    //
    logic           reset, resetn;
    logic           clk100, clk;
    logic           locked;
    
    clk_wiz clk_wiz_inst (.clkout100(clk100), .clkout200(), .clkin100(clkin100), .locked(locked));
    
    assign resetn = locked;
    assign reset  = ~locked;
    assign clk = clk100;
          
    system system_i (
        .S_AXIS_S2MM_CMD_tdata  (S_AXIS_S2MM_CMD_tdata),
        .S_AXIS_S2MM_CMD_tready (S_AXIS_S2MM_CMD_tready),
        .S_AXIS_S2MM_CMD_tvalid (S_AXIS_S2MM_CMD_tvalid),
        
        .S_AXIS_S2MM_tdata      (S_AXIS_S2MM_tdata),
        .S_AXIS_S2MM_tkeep      (S_AXIS_S2MM_tkeep),
        .S_AXIS_S2MM_tlast      (S_AXIS_S2MM_tlast),
        .S_AXIS_S2MM_tready     (S_AXIS_S2MM_tready),
        .S_AXIS_S2MM_tvalid     (S_AXIS_S2MM_tvalid),
        
        .ddr3_sdram_addr        (ddr3_sdram_addr),
        .ddr3_sdram_ba          (ddr3_sdram_ba),
        .ddr3_sdram_cas_n       (ddr3_sdram_cas_n),
        .ddr3_sdram_ck_n        (ddr3_sdram_ck_n),
        .ddr3_sdram_ck_p        (ddr3_sdram_ck_p),
        .ddr3_sdram_cke         (ddr3_sdram_cke),
        .ddr3_sdram_cs_n        (ddr3_sdram_cs_n),
        .ddr3_sdram_dm          (ddr3_sdram_dm),
        .ddr3_sdram_dq          (ddr3_sdram_dq),
        .ddr3_sdram_dqs_n       (ddr3_sdram_dqs_n),
        .ddr3_sdram_dqs_p       (ddr3_sdram_dqs_p),
        .ddr3_sdram_odt         (ddr3_sdram_odt),
        .ddr3_sdram_ras_n       (ddr3_sdram_ras_n),
        .ddr3_sdram_reset_n     (ddr3_sdram_reset_n),
        .ddr3_sdram_we_n        (ddr3_sdram_we_n),
        
        .resetn                 (resetn), // active low
        .aclk                   (clk)
    );        

    // generate data
    logic [7:0][7:0] gen_data = {8'h07, 8'h06, 8'h05, 8'h04, 8'h03, 8'h02, 8'h01, 8'h00};
    assign S_AXIS_S2MM_tvalid = 1;
    assign S_AXIS_S2MM_tkeep = 8'hff;
    logic[3:0] gen_count = -1;
    always_ff @(posedge clk) begin
        if ((S_AXIS_S2MM_tvalid) && (S_AXIS_S2MM_tready)) begin
            for (int i=0; i<8; i++) begin
                gen_data[i] <= gen_data[i] + 8;
            end
            gen_count <= gen_count - 1;
            if (0==gen_count) begin
                S_AXIS_S2MM_tlast <= 1'b1;
            end else begin
                S_AXIS_S2MM_tlast <= 1'b0;
            end
        end
    end
    assign S_AXIS_S2MM_tdata = gen_data;

    
    // generate command
    assign S_AXIS_S2MM_CMD_tdata = 72'h0a_0000_0000_0080_0100;
    always_ff @(posedge clk) begin
        if (reset) begin
            S_AXIS_S2MM_CMD_tvalid <= 1;
        end else begin
            if (S_AXIS_S2MM_CMD_tready) S_AXIS_S2MM_CMD_tvalid <= 0;
        end
    end
    
    data_ila data_ila_inst(.clk(clk), 
        .probe0({S_AXIS_S2MM_CMD_tvalid, S_AXIS_S2MM_CMD_tready, S_AXIS_S2MM_tlast, S_AXIS_S2MM_tready,S_AXIS_S2MM_tvalid}), // 5
        .probe1({S_AXIS_S2MM_tdata}) // 64
    );
            
            
endmodule
