module top (
    input   logic           clkin100,   // 100MHz oscillator
    input   logic           resetn,     // red reset button
    //
    output  logic [3:0]     led,
    output  logic [3:0]     led_b,
    input   logic [3:0]     btn,
    input   logic [3:0]     sw,
    //
    input   logic           uart_0_rxd,
    output  logic           uart_0_txd,
    //
    output  logic [3:0]     eth_mii_txd,    
    output  logic           eth_mii_tx_en,          
    input   logic [3:0]     eth_mii_rxd,     
    input   logic           eth_mii_rx_dv,           
    input   logic           eth_mii_rx_er,           
    input   logic           eth_mii_rx_clk,                   
    output  logic           eth_mdc,                     
    inout   logic           eth_mdio,
    output  logic           eth_refclk      
);

    
    logic [31:0]    M00_AXI_araddr;
    logic [2:0]     M00_AXI_arprot;
    logic [0:0]     M00_AXI_arready;
    logic [0:0]     M00_AXI_arvalid;
    logic [31:0]    M00_AXI_awaddr;
    logic [2:0]     M00_AXI_awprot;
    logic [0:0]     M00_AXI_awready;
    logic [0:0]     M00_AXI_awvalid;
    logic [0:0]     M00_AXI_bready;
    logic [1:0]     M00_AXI_bresp;
    logic [0:0]     M00_AXI_bvalid;
    logic [31:0]    M00_AXI_rdata;
    logic [0:0]     M00_AXI_rready;
    logic [1:0]     M00_AXI_rresp;
    logic [0:0]     M00_AXI_rvalid;
    logic [31:0]    M00_AXI_wdata;
    logic [0:0]     M00_AXI_wready;
    logic [3:0]     M00_AXI_wstrb;
    logic [0:0]     M00_AXI_wvalid;
    logic axi_aresetn;
    logic axi_aclk;
    
    
    logic [7:0]m_axis_rx_tdata;
    logic m_axis_rx_tlast;
    logic m_axis_rx_tuser;
    logic m_axis_rx_tvalid;
    logic rx_mac_aclk;
    logic [15:0]s_axis_pause_tdata;
    logic s_axis_pause_tvalid;
    logic [7:0]s_axis_tx_tdata;
    logic s_axis_tx_tlast;
    logic s_axis_tx_tready;
    logic [0:0]s_axis_tx_tuser;
    logic s_axis_tx_tvalid;
    logic sys_clock;
    logic tx_mac_aclk;

    localparam int Nreg = 16;
    localparam int Nreg_addr = $clog2(Nreg) + 2;

    logic [Nreg-1:0][31:0] slv_reg, slv_read, slv_wr_pulse;


    assign slv_read[0] = 32'h07010100;
    assign slv_read[1] = 32'hdeadbeef;

    assign slv_read[Nreg-1:0] = slv_reg[Nreg-1:0];

	axi_regfile_v1_0_S00_AXI #	(
		.C_S_AXI_DATA_WIDTH(32),
		.C_S_AXI_ADDR_WIDTH(Nreg_addr)
	) axi_regfile_inst (
        // register interface
        .slv_read      (slv_read), 
        .slv_reg       (slv_reg),  
        .slv_wr_pulse  (slv_wr_pulse),
        // axi interface
		.S_AXI_ACLK    (axi_aclk),
		.S_AXI_ARESETN (axi_aresetn),
        //
		.S_AXI_ARADDR  (M00_AXI_araddr ),
		.S_AXI_ARPROT  (M00_AXI_arprot ),
		.S_AXI_ARREADY (M00_AXI_arready),
		.S_AXI_ARVALID (M00_AXI_arvalid),
		.S_AXI_AWADDR  (M00_AXI_awaddr ),
		.S_AXI_AWPROT  (M00_AXI_awprot ),
		.S_AXI_AWREADY (M00_AXI_awready),
		.S_AXI_AWVALID (M00_AXI_awvalid),
		.S_AXI_BREADY  (M00_AXI_bready ),
		.S_AXI_BRESP   (M00_AXI_bresp  ),
		.S_AXI_BVALID  (M00_AXI_bvalid ),
		.S_AXI_RDATA   (M00_AXI_rdata  ),
		.S_AXI_RREADY  (M00_AXI_rready ),
		.S_AXI_RRESP   (M00_AXI_rresp  ),
		.S_AXI_RVALID  (M00_AXI_rvalid ),
		.S_AXI_WDATA   (M00_AXI_wdata  ),
		.S_AXI_WREADY  (M00_AXI_wready ),
		.S_AXI_WSTRB   (M00_AXI_wstrb  ),
		.S_AXI_WVALID  (M00_AXI_wvalid )
	);

    logic clk;
    assign clk = axi_aclk;

    system system_i (        
        .sys_clock(clkin100),        
        .reset(resetn),
        
        .UART_0_rxd(uart_0_rxd),
        .UART_0_txd(uart_0_txd),
        
        .M00_AXI_araddr     (M00_AXI_araddr),
        .M00_AXI_arprot     (M00_AXI_arprot),
        .M00_AXI_arready    (M00_AXI_arready),
        .M00_AXI_arvalid    (M00_AXI_arvalid),
        .M00_AXI_awaddr     (M00_AXI_awaddr),
        .M00_AXI_awprot     (M00_AXI_awprot),
        .M00_AXI_awready    (M00_AXI_awready),
        .M00_AXI_awvalid    (M00_AXI_awvalid),
        .M00_AXI_bready     (M00_AXI_bready),
        .M00_AXI_bresp      (M00_AXI_bresp),
        .M00_AXI_bvalid     (M00_AXI_bvalid),
        .M00_AXI_rdata      (M00_AXI_rdata),
        .M00_AXI_rready     (M00_AXI_rready),
        .M00_AXI_rresp      (M00_AXI_rresp),
        .M00_AXI_rvalid     (M00_AXI_rvalid),
        .M00_AXI_wdata      (M00_AXI_wdata),
        .M00_AXI_wready     (M00_AXI_wready),
        .M00_AXI_wstrb      (M00_AXI_wstrb),
        .M00_AXI_wvalid     (M00_AXI_wvalid),
        .axi_aclk           (axi_aclk),
        .axi_aresetn        (axi_aresetn),
        
        .enet_refclk            (eth_refclk),
        .eth_mdio_mdc_mdc       (eth_mdc),
        .eth_mdio_mdc_mdio_i    (eth_mdio_i),
        .eth_mdio_mdc_mdio_o    (eth_mdio_o),
        .eth_mdio_mdc_mdio_t    (eth_mdio_t),
        .eth_mii_rx_clk         (eth_mii_rx_clk),
        .eth_mii_rx_dv          (eth_mii_rx_dv),
        .eth_mii_rx_er          (eth_mii_rx_er),
        .eth_mii_rxd            (eth_mii_rxd),
        .eth_mii_tx_clk         (eth_mii_tx_clk),
        .eth_mii_tx_en          (eth_mii_tx_en),
        .eth_mii_txd            (eth_mii_txd),

        .rx_mac_aclk        (rx_mac_aclk),        
        .m_axis_rx_tdata    (m_axis_rx_tdata),
        .m_axis_rx_tlast    (m_axis_rx_tlast),
        .m_axis_rx_tuser    (m_axis_rx_tuser),
        .m_axis_rx_tvalid   (m_axis_rx_tvalid),
        
        .s_axis_pause_tdata (s_axis_pause_tdata),
        .s_axis_pause_tvalid(s_axis_pause_tvalid),
        
        .tx_mac_aclk        (tx_mac_aclk),
        .s_axis_tx_tdata    (s_axis_tx_tdata),
        .s_axis_tx_tlast    (s_axis_tx_tlast),
        .s_axis_tx_tready   (s_axis_tx_tready),
        .s_axis_tx_tuser    (s_axis_tx_tuser),
        .s_axis_tx_tvalid   (s_axis_tx_tvalid)
    );

    IOBUF eth_mdio_mdc_mdio_iobuf (.I(eth_mdio_o), .IO(eth_mdio), .O(eth_mdio_i), .T(eth_mdio_t));    
    
    assign s_axis_pause_tdata = 0;
    assign s_axis_pause_tvalid = 0;
    

endmodule

