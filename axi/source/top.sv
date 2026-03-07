//
module top(
    input   logic       clkin100,
    input   logic       resetn,
    output  logic[7:0]  led
);

    logic [11:0]    bram_addr;
    logic           bram_clk;
    logic [31:0]    bram_din;
    logic [31:0]    bram_dout;
    logic           bram_en;
    logic           bram_rst;
    logic[3:0]      bram_we;
    
    logic [31:0]    s_axi4_araddr;
    logic [1:0]     s_axi4_arburst;
    logic [3:0]     s_axi4_arcache;
    logic [0:0]     s_axi4_arid;
    logic [7:0]     s_axi4_arlen;
    logic           s_axi4_arlock;
    logic [2:0]     s_axi4_arprot;
    logic           s_axi4_arready;
    logic [2:0]     s_axi4_arsize;
    logic           s_axi4_arvalid;
    logic [31:0]    s_axi4_awaddr;
    logic [1:0]     s_axi4_awburst;
    logic [3:0]     s_axi4_awcache;
    logic [0:0]     s_axi4_awid;
    logic [7:0]     s_axi4_awlen;
    logic           s_axi4_awlock;
    logic [2:0]     s_axi4_awprot;
    logic           s_axi4_awready;
    logic [2:0]     s_axi4_awsize;
    logic           s_axi4_awvalid;
    logic [0:0]     s_axi4_bid;
    logic           s_axi4_bready;
    logic [1:0]     s_axi4_bresp;
    logic           s_axi4_bvalid;
    logic [31:0]    s_axi4_rdata;
    logic [0:0]     s_axi4_rid;
    logic           s_axi4_rlast;
    logic           s_axi4_rready;
    logic [1:0]     s_axi4_rresp;
    logic           s_axi4_rvalid;
    logic [31:0]    s_axi4_wdata;
    logic           s_axi4_wlast;
    logic           s_axi4_wready;
    logic [3:0]     s_axi4_wstrb;
    logic           s_axi4_wvalid;
    logic[3:0]      s_axi4_arqos, s_axi4_awqos;
    
    logic init, axi_aclk, axi_aresetn;

    // axi4 master
    axi4_master axi_master_inst (
    	.m00_axi_init_axi_txn   (init),
		.m00_axi_txn_done       (),
		.m00_axi_error          (),
        //
		.m00_axi_aclk           (axi_aclk),
		.m00_axi_aresetn        (axi_aresetn),
        //
        .m00_axi_awid           (s_axi4_awid),
        .m00_axi_awaddr         (s_axi4_awaddr),
        .m00_axi_awlen          (s_axi4_awlen),
        .m00_axi_awsize         (s_axi4_awsize),
        .m00_axi_awburst        (s_axi4_awburst),
		.m00_axi_awlock         (s_axi4_awlock),
        .m00_axi_awcache        (s_axi4_awcache),
        .m00_axi_awprot         (s_axi4_awprot),
        .m00_axi_awqos          (),
        .m00_axi_awuser         (),
		.m00_axi_awvalid        (s_axi4_awvalid),
		.m00_axi_awready        (s_axi4_awready),
        .m00_axi_wdata          (s_axi4_wdata),
        .m00_axi_wstrb          (s_axi4_wstrb),
		.m00_axi_wlast          (s_axi4_wlast),
        .m00_axi_wuser          (s_axi4_wuser),
		.m00_axi_wvalid         (s_axi4_wvalid),
		.m00_axi_wready         (s_axi4_wready),
        .m00_axi_bid            (s_axi4_bid),
        .m00_axi_bresp          (s_axi4_bresp),
        .m00_axi_buser          (0),
		.m00_axi_bvalid         (s_axi4_bvalid),
		.m00_axi_bready         (s_axi4_bready),
        .m00_axi_arid           (s_axi4_arid),
        .m00_axi_araddr         (s_axi4_araddr),
        .m00_axi_arlen          (s_axi4_arlen),
        .m00_axi_arsize         (s_axi4_arsize),
        .m00_axi_arburst        (s_axi4_arburst),
		.m00_axi_arlock         (s_axi4_arlock),
        .m00_axi_arcache        (s_axi4_arcache),
        .m00_axi_arprot         (s_axi4_arprot),
        .m00_axi_arqos          (),
        .m00_axi_aruser         (),
		.m00_axi_arvalid        (s_axi4_arvalid),
		.m00_axi_arready        (s_axi4_arready),
        .m00_axi_rid            (s_axi4_rid),
        .m00_axi_rdata          (s_axi4_rdata),
        .m00_axi_rresp          (s_axi4_rresp),
		.m00_axi_rlast          (s_axi4_rlast),
        .m00_axi_ruser          (0),
		.m00_axi_rvalid         (s_axi4_rvalid),
		.m00_axi_rready         (s_axi4_rready)
    );    
    
  
    system system_i(
        .clk_in         (clkin100),
        .resetn         (resetn),
        .axi_aclk       (axi_aclk),
        .axi_aresetn    (axi_aresetn),
        //
        .s_axi4_araddr  (s_axi4_araddr),
        .s_axi4_arburst (s_axi4_arburst),
        .s_axi4_arcache (s_axi4_arcache),
        .s_axi4_arid    (s_axi4_arid),
        .s_axi4_arlen   (s_axi4_arlen),
        .s_axi4_arlock  (s_axi4_arlock),
        .s_axi4_arprot  (s_axi4_arprot),
        .s_axi4_arready (s_axi4_arready),
        .s_axi4_arsize  (s_axi4_arsize),
        .s_axi4_arvalid (s_axi4_arvalid),
        .s_axi4_awaddr  (s_axi4_awaddr),
        .s_axi4_awburst (s_axi4_awburst),
        .s_axi4_awcache (s_axi4_awcache),
        .s_axi4_awid    (s_axi4_awid),
        .s_axi4_awlen   (s_axi4_awlen),
        .s_axi4_awlock  (s_axi4_awlock),
        .s_axi4_awprot  (s_axi4_awprot),
        .s_axi4_awready (s_axi4_awready),
        .s_axi4_awsize  (s_axi4_awsize),
        .s_axi4_awvalid (s_axi4_awvalid),
        .s_axi4_bid     (s_axi4_bid),
        .s_axi4_bready  (s_axi4_bready),
        .s_axi4_bresp   (s_axi4_bresp),
        .s_axi4_bvalid  (s_axi4_bvalid),
        .s_axi4_rdata   (s_axi4_rdata),
        .s_axi4_rid     (s_axi4_rid),
        .s_axi4_rlast   (s_axi4_rlast),
        .s_axi4_rready  (s_axi4_rready),
        .s_axi4_rresp   (s_axi4_rresp),
        .s_axi4_rvalid  (s_axi4_rvalid),
        .s_axi4_wdata   (s_axi4_wdata),
        .s_axi4_wlast   (s_axi4_wlast),
        .s_axi4_wready  (s_axi4_wready),
        .s_axi4_wstrb   (s_axi4_wstrb),
        .s_axi4_wvalid  (s_axi4_wvalid),        
        //
        .bram_addr      (bram_addr),
        .bram_clk       (bram_clk),
        .bram_din       (bram_din),
        .bram_dout      (bram_dout),
        .bram_en        (bram_en),
        .bram_rst       (bram_rst),
        .bram_we        (bram_we)        
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

/*

	module axi4_master #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M00_AXI
		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_M00_AXI_BURST_LEN	= 16,
		parameter integer C_M00_AXI_ID_WIDTH	= 1,
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M00_AXI_DATA_WIDTH	= 32,
		parameter integer C_M00_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_BUSER_WIDTH	= 0
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface M00_AXI
		input wire  m00_axi_init_axi_txn,
		output wire  m00_axi_txn_done,
		output wire  m00_axi_error,
		input wire  m00_axi_aclk,
		input wire  m00_axi_aresetn,
		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
		output wire [7 : 0] m00_axi_awlen,
		output wire [2 : 0] m00_axi_awsize,
		output wire [1 : 0] m00_axi_awburst,
		output wire  m00_axi_awlock,
		output wire [3 : 0] m00_axi_awcache,
		output wire [2 : 0] m00_axi_awprot,
		output wire [3 : 0] m00_axi_awqos,
		output wire [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser,
		output wire  m00_axi_awvalid,
		input wire  m00_axi_awready,
		output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
		output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
		output wire  m00_axi_wlast,
		output wire [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser,
		output wire  m00_axi_wvalid,
		input wire  m00_axi_wready,
		input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid,
		input wire [1 : 0] m00_axi_bresp,
		input wire [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser,
		input wire  m00_axi_bvalid,
		output wire  m00_axi_bready,
		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
		output wire [7 : 0] m00_axi_arlen,
		output wire [2 : 0] m00_axi_arsize,
		output wire [1 : 0] m00_axi_arburst,
		output wire  m00_axi_arlock,
		output wire [3 : 0] m00_axi_arcache,
		output wire [2 : 0] m00_axi_arprot,
		output wire [3 : 0] m00_axi_arqos,
		output wire [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser,
		output wire  m00_axi_arvalid,
		input wire  m00_axi_arready,
		input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid,
		input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
		input wire [1 : 0] m00_axi_rresp,
		input wire  m00_axi_rlast,
		input wire [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser,
		input wire  m00_axi_rvalid,
		output wire  m00_axi_rready
	);
*/

