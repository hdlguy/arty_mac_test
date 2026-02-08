//
module temac (
    input   logic           resetn,      // active low reset
    // phy
    input   logic           eth_mii_tx_clk,
    output  logic [3:0]     eth_mii_txd,    
    output  logic           eth_mii_tx_en,  
    input   logic           eth_mii_rx_clk,              
    input   logic [3:0]     eth_mii_rxd,     
    input   logic           eth_mii_rx_dv,           
    input   logic           eth_mii_rx_er,
    output  logic           eth_mii_rst_n,
    // rx data
    output  logic           rx_axis_aclk,
    output  logic [7 : 0]   rx_axis_tdata,
    output  logic           rx_axis_tvalid,
    output  logic           rx_axis_tlast,
    output  logic           rx_axis_tuser,
    // tx data
    output  logic           tx_axis_aclk,
    input   logic           tx_axis_tvalid,
    output  logic           tx_axis_tready,
    input   logic [7 : 0]   tx_axis_tdata,
    input   logic           tx_axis_tlast,
    input   logic           tx_axis_tuser
);

    logic [27:0] rx_statistics_vector;
    logic rx_statistics_valid;

    logic glbl_rstn;
    logic rx_axi_rstn;
    logic tx_axi_rstn;
                                           
    logic [7:0] tx_ifg_delay;
    logic [31:0] tx_statistics_vector;
    logic tx_statistics_valid;
                                           
    logic pause_req;
    logic [15:0] pause_val;
                                           
    assign glbl_rstn        = resetn; 
    assign rx_axi_rstn      = resetn; 
    assign tx_axi_rstn      = resetn; 
    assign eth_mii_rst_n    = resetn;

    // *************************************************************
    eth_mac_mii # (
        .TARGET             ("XILINX"), // target ("SIM", "GENERIC", "XILINX", "ALTERA")
        .CLOCK_INPUT_STYLE  ("BUFR"),   // Clock input style ("BUFG", "BUFR", "BUFIO", "BUFIO2")
        .ENABLE_PADDING     (1),
        .MIN_FRAME_LENGTH   (64)
    ) eth_mac_mii_inst (
        .rst            (~glbl_rstn),
        
        .tx_clk         (tx_axis_aclk),
        .tx_rst         (),
        .tx_axis_tdata  (tx_axis_tdata),
        .tx_axis_tvalid (tx_axis_tvalid),
        .tx_axis_tready (tx_axis_tready),
        .tx_axis_tlast  (tx_axis_tlast),
        .tx_axis_tuser  (tx_axis_tuser),
        
        .rx_clk         (rx_axis_aclk),
        .rx_rst         (),
        .rx_axis_tdata  (rx_axis_tdata),
        .rx_axis_tvalid (rx_axis_tvalid),
        .rx_axis_tlast  (rx_axis_tlast),
        .rx_axis_tuser  (rx_axis_tuser),
        
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
        .rx_mac_aclk(rx_axis_aclk),                         // output logic rx_mac_aclk
        .rx_axis_mac_tdata(rx_axis_tdata),              // output logic [7 : 0] rx_axis_mac_tdata
        .rx_axis_mac_tvalid(rx_axis_tvalid),            // output logic rx_axis_mac_tvalid
        .rx_axis_mac_tlast(rx_axis_tlast),              // output logic rx_axis_mac_tlast
        .rx_axis_mac_tuser(rx_axis_tuser),              // output logic rx_axis_mac_tuser
        
        .tx_ifg_delay(tx_ifg_delay),                        // input logic [7 : 0] tx_ifg_delay
        .tx_statistics_vector(tx_statistics_vector),        // output logic [31 : 0] tx_statistics_vector
        .tx_statistics_valid(tx_statistics_valid),          // output logic tx_statistics_valid
        
        .tx_reset(),                                        // output logic tx_reset
        .tx_enable(),                                       // output logic tx_enable
        .tx_mac_aclk(tx_axis_aclk),                         // output logic tx_mac_aclk
        .tx_axis_mac_tdata(tx_axis_tdata),              // input logic [7 : 0] tx_axis_mac_tdata
        .tx_axis_mac_tvalid(tx_axis_tvalid),            // input logic tx_axis_mac_tvalid
        .tx_axis_mac_tlast(tx_axis_tlast),              // input logic tx_axis_mac_tlast
        .tx_axis_mac_tuser(tx_axis_tuser),              // input logic [0 : 0] tx_axis_mac_tuser
        .tx_axis_mac_tready(tx_axis_tready),            // output logic tx_axis_mac_tready
        
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
*/

endmodule



