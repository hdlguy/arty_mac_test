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
/*
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
*/

    // *************************************************************

    logic [79:0] rx_configuration_vector;
    assign rx_configuration_vector[79:32] = { 8'h00, 8'h0a, 8'h35, 8'h00, 8'h01, 8'h02 }; // Receiver Pause Frame Source Address[47:0]
    assign rx_configuration_vector[31:16] = 1600; // Receiver Max Frame Size[15:0].
    assign rx_configuration_vector[15] = 0; // Reserved
    assign rx_configuration_vector[14] = 0; // Receiver Max Frame Enable
    assign rx_configuration_vector[13:12] = 2'b01; // Receiver Speed Configuration
    assign rx_configuration_vector[11] = 0; // Promiscuous Mode
    assign rx_configuration_vector[10] = 0; // Reserved
    assign rx_configuration_vector[9] = 0; // Receiver Control Frame Length Check Disable
    assign rx_configuration_vector[8] = 0; // Receiver Length/Type Error Check Disable
    assign rx_configuration_vector[7] = 0; // Reserved
    assign rx_configuration_vector[6] = 0; // Receiver Half-Duplex
    assign rx_configuration_vector[5] = 0; // Receiver Flow Control Enable
    assign rx_configuration_vector[4] = 0; // Receiver Jumbo Frame Enable
    assign rx_configuration_vector[3] = 0; // Receiver In-Band FCS Enable
    assign rx_configuration_vector[2] = 0; // Receiver VLAN Enable
    assign rx_configuration_vector[1] = 1; // Receiver Enable
    assign rx_configuration_vector[0] = 0; // Receiver Reset

    logic [79:0] tx_configuration_vector;
    assign tx_configuration_vector[79:32] = { 8'h00, 8'h0a, 8'h35, 8'h00, 8'h01, 8'h02 }; // Transmitter Pause Frame Source Address[47:0]
    assign tx_configuration_vector[31:16] = 4500; // Transmitter Max Frame Size[15:0].
    assign tx_configuration_vector[15] = 0; // Reserved
    assign tx_configuration_vector[14] = 0; // Transmitter Max Frame Enable
    assign tx_configuration_vector[13:12] = 2'b01; // Transmitter Speed Configuration
    assign tx_configuration_vector[11: 9] = 3'b000; // Reserved
    assign tx_configuration_vector[8] = 0; // Transmitter Interframe Gap Adjust Enable.
    assign tx_configuration_vector[7] = 0; // Reserved
    assign tx_configuration_vector[6] = 0; // Transmitter Half-Duplex
    assign tx_configuration_vector[5] = 0; // Transmitter Flow Control Enable
    assign tx_configuration_vector[4] = 1; // Transmitter Jumbo Frame Enable
    assign tx_configuration_vector[3] = 0; // Transmitter In-Band FCS Enable
    assign tx_configuration_vector[2] = 0; // Transmitter VLAN Enable
    assign tx_configuration_vector[1] = 1; // Transmitter Enable
    assign tx_configuration_vector[0] = 0; // Transmitter Reset

    assign tx_ifg_delay = 0;
    assign pause_req = 0;
    assign pause_val = 0;

    temac_core temac_core_inst (
        .glbl_rstn(glbl_rstn),                              // input logic glbl_rstn
        .rx_axi_rstn(rx_axi_rstn),                          // input logic rx_axi_rstn
        .tx_axi_rstn(tx_axi_rstn),                          // input logic tx_axi_rstn

        .rx_statistics_vector(rx_statistics_vector),        // output logic [27: 0] rx_statistics_vector
        .rx_statistics_valid(rx_statistics_valid),          // output logic rx_statistics_valid

        .rx_reset(),                                        // output logic rx_reset
        .rx_enable(),                                       // output logic rx_enable
        .rx_mac_aclk        (rx_mac_aclk),                         // output logic rx_mac_aclk
        .rx_axis_mac_tdata  (rx_axis_mac_tdata),              // output logic [7 : 0] rx_axis_mac_tdata
        .rx_axis_mac_tvalid (rx_axis_mac_tvalid),            // output logic rx_axis_mac_tvalid
        .rx_axis_mac_tlast  (rx_axis_mac_tlast),              // output logic rx_axis_mac_tlast
        .rx_axis_mac_tuser  (rx_axis_mac_tuser),              // output logic rx_axis_mac_tuser
        
        .tx_ifg_delay(tx_ifg_delay),                        // input logic [7 : 0] tx_ifg_delay
        .tx_statistics_vector(tx_statistics_vector),        // output logic [31 : 0] tx_statistics_vector
        .tx_statistics_valid(tx_statistics_valid),          // output logic tx_statistics_valid
        
        .tx_reset(),                                        // output logic tx_reset
        .tx_enable(),                                       // output logic tx_enable
        .tx_mac_aclk        (tx_mac_aclk),                         // output logic tx_mac_aclk
        .tx_axis_mac_tdata  (tx_axis_mac_tdata),              // input logic [7 : 0] tx_axis_mac_tdata
        .tx_axis_mac_tvalid (tx_axis_mac_tvalid),            // input logic tx_axis_mac_tvalid
        .tx_axis_mac_tlast  (tx_axis_mac_tlast),              // input logic tx_axis_mac_tlast
        .tx_axis_mac_tuser  (tx_axis_mac_tuser),              // input logic [0 : 0] tx_axis_mac_tuser
        .tx_axis_mac_tready (tx_axis_mac_tready),            // output logic tx_axis_mac_tready
        
        .pause_req(pause_req),                              // input logic pause_req
        .pause_val(pause_val),                              // input logic [15 : 0] pause_val

        .speedis100(),                                      // output logic speedis100
        .speedis10100(),                                    // output logic speedis10100

        .mii_tx_clk (eth_mii_tx_clk),
        .mii_txd    (eth_mii_txd),
        .mii_tx_en  (eth_mii_tx_en),
        .mii_tx_er  (),
        .mii_rx_clk (eth_mii_rx_clk),
        .mii_rxd    (eth_mii_rxd),
        .mii_rx_dv  (eth_mii_rx_dv),
        .mii_rx_er  (eth_mii_rx_er),
        
        .rx_configuration_vector(rx_configuration_vector),  // input logic [79 : 0] rx_configuration_vector
        .tx_configuration_vector(tx_configuration_vector)   // input logic [79 : 0] tx_configuration_vector
    );

    
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
