//
module top(
    input   logic   clkin100,
    input   logic   resetn,
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
    logic [7:0]     M_AXIS_S2MM_STS_tdata;
    logic [0:0]     M_AXIS_S2MM_STS_tkeep;
    logic           M_AXIS_S2MM_STS_tlast;
    logic           M_AXIS_S2MM_STS_tready;
    logic           M_AXIS_S2MM_STS_tvalid;    
    //
    logic           clk100, clk;
    logic           locked;
    logic           init_calib_complete, mmcm_locked, ui_clk_sync_rst, init_calib_complete_q=0, mmcm_locked_q=0;
    
    clk_wiz clk_wiz_inst (.clkout100(clk100), .clkout200(), .clkin100(clkin100), .locked(locked));
    
    assign clk = clk100;
    
    logic reset=1;
    always_ff @(posedge clk) reset <= ~resetn;
          
    system system_i (
        .S_AXIS_S2MM_CMD_tdata  (S_AXIS_S2MM_CMD_tdata),
        .S_AXIS_S2MM_CMD_tready (S_AXIS_S2MM_CMD_tready),
        .S_AXIS_S2MM_CMD_tvalid (S_AXIS_S2MM_CMD_tvalid),
        
        .S_AXIS_S2MM_tdata      (S_AXIS_S2MM_tdata),
        .S_AXIS_S2MM_tkeep      (S_AXIS_S2MM_tkeep),
        .S_AXIS_S2MM_tlast      (S_AXIS_S2MM_tlast),
        .S_AXIS_S2MM_tready     (S_AXIS_S2MM_tready),
        .S_AXIS_S2MM_tvalid     (S_AXIS_S2MM_tvalid),
        
        .M_AXIS_S2MM_STS_tdata  (M_AXIS_S2MM_STS_tdata),
        .M_AXIS_S2MM_STS_tkeep  (M_AXIS_S2MM_STS_tkeep),
        .M_AXIS_S2MM_STS_tlast  (M_AXIS_S2MM_STS_tlast),
        .M_AXIS_S2MM_STS_tready (M_AXIS_S2MM_STS_tready),
        .M_AXIS_S2MM_STS_tvalid (M_AXIS_S2MM_STS_tvalid),
        //
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
        //
        .resetn                 (resetn), // active low
        .aclk                   (clk),
        //
        .init_calib_complete    (init_calib_complete),
        .mmcm_locked            (mmcm_locked),
        .ui_clk_sync_rst        (ui_clk_sync_rst)
    );        
    
    assign M_AXIS_S2MM_STS_tready = 1;

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

    
    // generate command, wait for mig to calibrate
    assign S_AXIS_S2MM_CMD_tdata = 72'h0a_8000_0000_0080_1000;
    always_ff @(posedge clk) begin
        init_calib_complete_q <= init_calib_complete;
        mmcm_locked_q <= mmcm_locked;
        if ((~init_calib_complete_q) || (~mmcm_locked_q)) begin
            S_AXIS_S2MM_CMD_tvalid <= 0;
        end else begin
            S_AXIS_S2MM_CMD_tvalid <= 1;
        end
    end
    
    data_ila data_ila_inst(
        .clk(clk), 
        .probe0({
            reset, S_AXIS_S2MM_CMD_tvalid, S_AXIS_S2MM_CMD_tready, 
            S_AXIS_S2MM_tlast, S_AXIS_S2MM_tready,S_AXIS_S2MM_tvalid,
            M_AXIS_S2MM_STS_tkeep, M_AXIS_S2MM_STS_tlast, M_AXIS_S2MM_STS_tread, M_AXIS_S2MM_STS_tvalid,
            init_calib_complete_q, mmcm_locked_q, ui_clk_sync_rst            
         }), // 13
        .probe1({S_AXIS_S2MM_tdata, M_AXIS_S2MM_STS_tdata}) // 72
    );
                       
endmodule


/*
    logic [7:0]     M_AXIS_S2MM_STS_tdata;
    logic [0:0]     M_AXIS_S2MM_STS_tkeep;
    logic           M_AXIS_S2MM_STS_tlast;
    logic           M_AXIS_S2MM_STS_tready;
    logic           M_AXIS_S2MM_STS_tvalid;    
*/
