module top (
    input   logic           clkin100,   // 100MHz oscillator
    input   logic           resetn,     // red reset button
    //
    output  logic [3:0]     led,
    output  logic [3:0]     led_b,
    input   logic [3:0]     btn,
    input   logic [3:0]     sw,
    //
    output  logic [3:0]     eth_mii_txd,    
    output  logic           eth_mii_tx_en,          
    input   logic [3:0]     eth_mii_rxd,     
    input   logic           eth_mii_rx_dv,           
    input   logic           eth_mii_rx_er,           
    input   logic           eth_mii_rx_clk,                   
    output  logic           eth_mii_rst_n,
    output  logic           eth_mdc,                     
    inout   logic           eth_mdio,
    output  logic           eth_refclk      
);

    logic clk, clk125, clk25, locked;
    clk_wiz clk_wiz_inst (.clkin100(clkin100), .resetn(resetn), .locked(locked), .clkout100(clk), .clkout125(clk125), .clkout25(clk25));
    
    logic glbl_rstn;
    assign glbl_rstn   = locked; 
    assign rx_axi_rstn = locked; 
    assign tx_axi_rstn = locked; 
    
    logic [27 : 0] rx_statistics_vector;
    logic rx_statistics_valid;

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
                                           
    logic [79 : 0] rx_configuration_vector;

    logic [79 : 0] tx_configuration_vector;
    assign tx_configuration_vector[79:32] = { 8'h00, 8'h0a, 8'h35, 8'h00, 8'h01, 8'h02 }; // Transmitter Pause Frame Source Address[47:0]
    assign tx_configuration_vector[31:16] = 1600; // Transmitter Max Frame Size[15:0].
    assign tx_configuration_vector[15] = 0; // Reserved
    assign tx_configuration_vector[14] = 0; // Transmitter Max Frame Enable
    assign tx_configuration_vector[13:12] = 2'b01; // Transmitter Speed Configuration
    assign tx_configuration_vector[11: 9] = 3'b000; // Reserved
    assign tx_configuration_vector[8] = 0; // Transmitter Interframe Gap Adjust Enable.
    assign tx_configuration_vector[7] = 0; // Reserved
    assign tx_configuration_vector[6] = 0; // Transmitter Half-Duplex
    assign tx_configuration_vector[5] = 0; // Transmitter Flow Control Enable
    assign tx_configuration_vector[4] = 0; // Transmitter Jumbo Frame Enable
    assign tx_configuration_vector[3] = 0; // Transmitter In-Band FCS Enable
    assign tx_configuration_vector[2] = 0; // Transmitter VLAN Enable
    assign tx_configuration_vector[1] = 1; // Transmitter Enable
    assign tx_configuration_vector[0] = 0; // Transmitter Reset

    temac_core temac_core_inst (
        .glbl_rstn(glbl_rstn),                              // input logic glbl_rstn
        .rx_axi_rstn(rx_axi_rstn),                          // input logic rx_axi_rstn
        .tx_axi_rstn(tx_axi_rstn),                          // input logic tx_axi_rstn

        .rx_statistics_vector(rx_statistics_vector),        // output logic [27 : 0] rx_statistics_vector
        .rx_statistics_valid(rx_statistics_valid),          // output logic rx_statistics_valid

        .rx_reset(rx_reset),                                // output logic rx_reset
        .rx_enable(rx_enable),                              // output logic rx_enable
        .rx_mac_aclk(rx_mac_aclk),                          // output logic rx_mac_aclk
        .rx_axis_mac_tdata(rx_axis_mac_tdata),              // output logic [7 : 0] rx_axis_mac_tdata
        .rx_axis_mac_tvalid(rx_axis_mac_tvalid),            // output logic rx_axis_mac_tvalid
        .rx_axis_mac_tlast(rx_axis_mac_tlast),              // output logic rx_axis_mac_tlast
        .rx_axis_mac_tuser(rx_axis_mac_tuser),              // output logic rx_axis_mac_tuser
        
        .tx_ifg_delay(tx_ifg_delay),                        // input logic [7 : 0] tx_ifg_delay
        .tx_statistics_vector(tx_statistics_vector),        // output logic [31 : 0] tx_statistics_vector
        .tx_statistics_valid(tx_statistics_valid),          // output logic tx_statistics_valid
        
        .tx_reset(tx_reset),                                // output logic tx_reset
        .tx_enable(tx_enable),                              // output logic tx_enable
        .tx_mac_aclk(tx_mac_aclk),                          // output logic tx_mac_aclk
        .tx_axis_mac_tdata(tx_axis_mac_tdata),              // input logic [7 : 0] tx_axis_mac_tdata
        .tx_axis_mac_tvalid(tx_axis_mac_tvalid),            // input logic tx_axis_mac_tvalid
        .tx_axis_mac_tlast(tx_axis_mac_tlast),              // input logic tx_axis_mac_tlast
        .tx_axis_mac_tuser(tx_axis_mac_tuser),              // input logic [0 : 0] tx_axis_mac_tuser
        .tx_axis_mac_tready(tx_axis_mac_tready),            // output logic tx_axis_mac_tready
        
        .pause_req(pause_req),                              // input logic pause_req
        .pause_val(pause_val),                              // input logic [15 : 0] pause_val

        .speedis100(speedis100),                            // output logic speedis100
        .speedis10100(speedis10100),                        // output logic speedis10100

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

    assign tx_ifg_delay = 0;
    assign pause_req = 0;
    assign pause_val = 0;
    
    // generate some kind of tx data
    logic tx_fifo_full, tx_fifo_empty;
    logic [31:0] tx_count = 0;
    always_ff @(posedge clk) begin
        if (0 == tx_fifo_full) begin
            tx_count <= tx_count + 1;
            if (tx_count[3:0] == 15) s_axis_tx_tlast <= 1; else s_axis_tx_tlast <= 0;
        end
    end
        
    eth_tx_fifo tx_fifo_inst (
        .wr_clk(clk),           .full(tx_fifo_full),     .wr_en(1'b1),               .din(tx_count),         
        .rd_clk(tx_mac_aclk),   .empty(tx_fifo_empty),   .rd_en(s_axis_tx_tready),   .dout(s_axis_tx_tdata)
    );
    assign s_axis_tx_tvalid = ~tx_fifo_empty;
    assign s_axis_tx_tuser = 0;
    
    tx_fifo_ila tx_ila_inst(.clk(clk), .probe0({tx_fifo_full, tx_count, s_axis_tx_tlast})); // 34
    

endmodule

