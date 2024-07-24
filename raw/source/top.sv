module top (
    input   logic           clkin100,   // 100MHz oscillator
    input   logic           resetn,     // red reset button
    //
    output  logic [3:0]     led,
    output  logic [3:0]     led_b,
    input   logic [3:0]     btn,
    input   logic [3:0]     sw,
    //
    input   logic           eth_mii_tx_clk,
    output  logic [3:0]     eth_mii_txd,    
    output  logic           eth_mii_tx_en,  
        
    input   logic           eth_mii_rx_clk,              
    input   logic [3:0]     eth_mii_rxd,     
    input   logic           eth_mii_rx_dv,           
    input   logic           eth_mii_rx_er,
                        
    output  logic           eth_mii_rst_n,
    //output  logic           eth_mdc,                     
    //inout   logic           eth_mdio,
    output  logic           eth_refclk      
);

    assign led_b = sw;

    logic clk, clk125, clk25, locked;
    clk_wiz clk_wiz_inst (.clkin100(clkin100), .resetn(resetn), .locked(locked), .clkout100(clk), .clkout125(clk125), .clkout25(clk25));
    assign eth_refclk = clk25;
    
    
    logic [27 : 0] rx_statistics_vector;
    logic rx_statistics_valid;

    logic glbl_rstn;

    logic rx_axi_rstn;
    logic rx_mac_aclk;
    logic rx_reset;
    logic rx_enable;

    logic tx_axi_rstn;
    logic tx_mac_aclk;
    logic tx_reset;
    logic tx_enable;
                                           
    logic [7 : 0]   rx_axis_mac_tdata;
    logic           rx_axis_mac_tvalid;
    logic           rx_axis_mac_tlast;
    logic           rx_axis_mac_tuser;
                                           
    logic [7 : 0]   tx_axis_mac_tdata;
    logic           tx_axis_mac_tvalid;
    logic           tx_axis_mac_tlast;
    logic [0 : 0]   tx_axis_mac_tuser;
    logic           tx_axis_mac_tready;
                                           
    logic [7 : 0] tx_ifg_delay;
    logic [31 : 0] tx_statistics_vector;
    logic tx_statistics_valid;
                                           
    logic pause_req;
    logic [15 : 0] pause_val;
    logic speedis100;
    logic speedis10100;
    logic mii_tx_clk;
    logic [3 : 0] mii_txd;
    logic mii_tx_en;
    logic mii_tx_er;
    logic [3 : 0] mii_rxd;
    logic mii_rx_dv;
    logic mii_rx_er;
    logic mii_rx_clk;
                                           
    assign glbl_rstn   = locked; 
    assign rx_axi_rstn = locked; 
    assign tx_axi_rstn = locked; 
    assign eth_mii_rst_n = locked;
    
    // *************************************************************
    eth_mac_mii # (
        .TARGET             ("XILINX"), // target ("SIM", "GENERIC", "XILINX", "ALTERA")
        .CLOCK_INPUT_STYLE  ("BUFR"),   // Clock input style ("BUFG", "BUFR", "BUFIO", "BUFIO2")
        .ENABLE_PADDING     (1),
        .MIN_FRAME_LENGTH   (64)
    ) eth_mac_mii_inst (
        .rst            (~glbl_rstn),
        
        .tx_clk         (tx_mac_aclk),
        .tx_rst         (tx_reset),
        .tx_axis_tdata  (tx_axis_mac_tdata),
        .tx_axis_tvalid (tx_axis_mac_tvalid),
        .tx_axis_tready (tx_axis_mac_tready),
        .tx_axis_tlast  (tx_axis_mac_tlast),
        .tx_axis_tuser  (tx_axis_mac_tuser),
        
        .rx_clk         (rx_mac_aclk),
        .rx_rst         (rx_reset),
        .rx_axis_tdata  (rx_axis_mac_tdata),
        .rx_axis_tvalid (rx_axis_mac_tvalid),
        .rx_axis_tlast  (rx_axis_mac_tlast),
        .rx_axis_tuser  (rx_axis_mac_tuser),
        
        .mii_rx_clk     (eth_mii_rx_clk),
        .mii_rxd        (eth_mii_rxd),
        .mii_rx_dv      (eth_mii_rx_dv),
        .mii_rx_er      (eth_mii_rx_er),
        .mii_tx_clk     (eth_mii_tx_clk),
        .mii_txd        (eth_mii_txd),
        .mii_tx_en      (eth_mii_tx_en),
        .mii_tx_er      (),
        
        .tx_start_packet(),
        .tx_error_underflow(),
        .rx_start_packet(),
        .rx_error_bad_frame(),
        .rx_error_bad_fcs(),
        
        .ifg_delay      (12)
    );


    // *************************************************************
/*
*/
    
    // **********************************************************************
    

    
    // generate tx frames
    logic tx_fifo_tvalid, tx_fifo_tlast, tx_fifo_tuser, tx_fifo_tready, tx_fifo_full, tx_fifo_empty;
    logic [7:0] tx_fifo_tdata;
    frame_gen frame_gen_inst (.clk(clk), .enable(sw[0]), .m_axis_tdata(tx_fifo_tdata), .m_axis_tvalid(tx_fifo_tvalid), .m_axis_tlast(tx_fifo_tlast), .m_axis_tuser(tx_fifo_tuser), .m_axis_tready(tx_fifo_tready));

    // tx fifo
    mac_fifo tx_mac_fifo(
        .wr_clk(clk),         .full(tx_fifo_full),   .wr_en(tx_fifo_tvalid),     .din ({tx_fifo_tlast, tx_fifo_tuser, tx_fifo_tdata}), 
        .rd_clk(tx_mac_aclk), .empty(tx_fifo_empty), .rd_en(tx_axis_mac_tready), .dout({tx_axis_mac_tlast, tx_axis_mac_tuser, tx_axis_mac_tdata})
    );
    assign tx_fifo_tready     = ~tx_fifo_full;
    assign tx_axis_mac_tvalid = ~tx_fifo_empty;
    
    
    //rx fifo 
    logic[7:0] rx_fifo_tdata;
    logic rx_fifo_empty, rx_fifo_tlast, rx_fifo_tuser, rx_fifo_tready, rx_fifo_tvalid;
    mac_fifo rx_mac_fifo(
        .wr_clk(rx_mac_aclk), .full(),               .wr_en(rx_axis_mac_tvalid), .din ({rx_axis_mac_tlast, rx_axis_mac_tuser, rx_axis_mac_tdata}), 
        .rd_clk(clk),         .empty(rx_fifo_empty), .rd_en(rx_fifo_tready),     .dout({rx_fifo_tlast, rx_fifo_tuser, rx_fifo_tdata})
    );
    assign rx_fifo_tvalid = ~rx_fifo_empty;  

    // receive mac frames and write the values the control registers.
    localparam int Nreg = 32;
    logic reg_dv;
    logic [Nreg-1:0][31:0] slv_reg, slv_read, slv_wr_pulse;
    frame_rx #(.Nregs(Nreg)) frame_rx_inst (
        .clk(clk),
        .rx_fifo_tvalid (rx_fifo_tvalid),
        .rx_fifo_tready (rx_fifo_tready),
        .rx_fifo_tdata  (rx_fifo_tdata),
        .rx_fifo_tlast  (rx_fifo_tlast),
        .rx_fifo_tuser  (rx_fifo_tuser),
        .dv_out         (reg_dv),
        .wr_val         (slv_reg)
    );

    assign led = slv_reg[2][3:0];

    
    eth_ila eth_ila_inst (
        .clk(clk), 
        .probe0({   tx_fifo_tready, tx_fifo_tvalid, tx_fifo_tlast, tx_fifo_tuser, tx_fifo_tdata, 
                    rx_fifo_tready, rx_fifo_tvalid, rx_fifo_tlast, rx_fifo_tuser, rx_fifo_tdata})
    ); // 24

endmodule


/*

*/
