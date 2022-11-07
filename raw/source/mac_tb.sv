//
module mac_tb ();


    logic[1:0]        reset;
    logic[1:0]        rx_mac_aclk;
    logic[1:0]        rx_reset;
    logic[1:0]        tx_mac_aclk;
    logic[1:0]        tx_reset;
    logic[1:0] [7:0]  tx_axis_tdata;
    logic[1:0]        tx_axis_tvalid;
    logic[1:0]        tx_axis_tready;
    logic[1:0]        tx_axis_tlast;
    logic[1:0]        tx_axis_tuser;
    logic[1:0] [7:0]  rx_axis_tdata;
    logic[1:0]        rx_axis_tvalid;
    logic[1:0]        rx_axis_tlast;
    logic[1:0]        rx_axis_tuser;
    logic[1:0]        mii_rx_clk;
    logic[1:0] [3:0]  mii_rxd;
    logic[1:0]        mii_rx_dv;
    logic[1:0]        mii_rx_er;
    logic[1:0]        mii_tx_clk;
    logic[1:0] [3:0]  mii_txd;
    logic[1:0]        mii_tx_en;
    logic[1:0]        mii_tx_er;
    logic[1:0]        tx_start_packet;
    logic[1:0]        tx_error_underflow;
    logic[1:0]        rx_start_packet;
    logic[1:0]        rx_error_bad_frame;
    logic[1:0]        rx_error_bad_fcs;


    logic  clk = 0; localparam  clk_period = 40; always #( clk_period/2)  clk =  ~clk;


    eth_mac_mii # (
        .TARGET             ("XILINX"), // target ("SIM", "GENERIC", "XILINX", "ALTERA")
        .CLOCK_INPUT_STYLE  ("BUFR"),   // Clock input style ("BUFG", "BUFR", "BUFIO", "BUFIO2")
        .ENABLE_PADDING     (1),
        .MIN_FRAME_LENGTH   (64)
    ) mac_1 (
        .rst            (reset[1]),
        
        .tx_clk         (tx_mac_aclk[1]),
        .tx_rst         (tx_reset[1]),
        .tx_axis_tdata  (tx_axis_tdata[1]),
        .tx_axis_tvalid (tx_axis_tvalid[1]),
        .tx_axis_tready (tx_axis_tready[1]),
        .tx_axis_tlast  (tx_axis_tlast[1]),
        .tx_axis_tuser  (tx_axis_tuser[1]),
        
        .rx_clk         (rx_mac_aclk[1]),
        .rx_rst         (rx_reset[1]),
        .rx_axis_tdata  (rx_axis_tdata[1]),
        .rx_axis_tvalid (rx_axis_tvalid[1]),
        .rx_axis_tlast  (rx_axis_tlast[1]),
        .rx_axis_tuser  (rx_axis_tuser[1]),
        
        .mii_rx_clk     (mii_rx_clk[1]),
        .mii_rxd        (mii_rxd[1]),
        .mii_rx_dv      (mii_rx_dv[1]),
        .mii_rx_er      (mii_rx_er[1]),
        .mii_tx_clk     (mii_tx_clk[1]),
        .mii_txd        (mii_txd[1]),
        .mii_tx_en      (mii_tx_en[1]),
        .mii_tx_er      (mii_tx_er[1]),
        
        .tx_start_packet(tx_start_packet[1]),
        .tx_error_underflow(tx_error_underflow[1]),
        .rx_start_packet(rx_start_packet[1]),
        .rx_error_bad_frame(rx_error_bad_frame[1]),
        .rx_error_bad_fcs(rx_error_bad_fcs[1]),
        
        .ifg_delay      (12)
    );


    eth_mac_mii # (
        .TARGET             ("XILINX"), // target ("SIM", "GENERIC", "XILINX", "ALTERA")
        .CLOCK_INPUT_STYLE  ("BUFR"),   // Clock input style ("BUFG", "BUFR", "BUFIO", "BUFIO2")
        .ENABLE_PADDING     (1),
        .MIN_FRAME_LENGTH   (64)
    ) mac_0 (
        .rst            (reset[0]),
        
        .tx_clk         (tx_mac_aclk[0]),
        .tx_rst         (tx_reset[0]),
        .tx_axis_tdata  (tx_axis_tdata[0]),
        .tx_axis_tvalid (tx_axis_tvalid[0]),
        .tx_axis_tready (tx_axis_tready[0]),
        .tx_axis_tlast  (tx_axis_tlast[0]),
        .tx_axis_tuser  (tx_axis_tuser[0]),
        
        .rx_clk         (rx_mac_aclk[0]),
        .rx_rst         (rx_reset[0]),
        .rx_axis_tdata  (rx_axis_tdata[0]),
        .rx_axis_tvalid (rx_axis_tvalid[0]),
        .rx_axis_tlast  (rx_axis_tlast[0]),
        .rx_axis_tuser  (rx_axis_tuser[0]),
        
        .mii_rx_clk     (mii_rx_clk[0]),
        .mii_rxd        (mii_rxd[0]),
        .mii_rx_dv      (mii_rx_dv[0]),
        .mii_rx_er      (mii_rx_er[0]),
        .mii_tx_clk     (mii_tx_clk[0]),
        .mii_txd        (mii_txd[0]),
        .mii_tx_en      (mii_tx_en[0]),
        .mii_tx_er      (mii_tx_er[0]),
        
        .tx_start_packet(tx_start_packet[0]),
        .tx_error_underflow(tx_error_underflow[0]),
        .rx_start_packet(rx_start_packet[0]),
        .rx_error_bad_frame(rx_error_bad_frame[0]),
        .rx_error_bad_fcs(rx_error_bad_fcs[0]),
        
        .ifg_delay      (12)
    );


    assign mii_rx_clk[0] = clk;
    assign mii_tx_clk[0] = clk;
    assign mii_rxd[0]   = mii_txd[1];
    assign mii_rx_er[0] = mii_tx_er[1];
    assign mii_rx_dv[0] = mii_tx_en[1];

    assign mii_rx_clk[1] = clk;
    assign mii_tx_clk[1] = clk;
    assign mii_rxd[1]   = mii_txd[0];
    assign mii_rx_er[1] = mii_tx_er[0];
    assign mii_rx_dv[1] = mii_tx_en[0];


    initial begin
        reset = 2'b11;
        #(clk_period*10);
        reset = 2'b00;
    end
    
    assign tx_axis_tvalid[1] = 1;
    assign tx_axis_tvalid[0] = 1;

    always_ff @(posedge mii_tx_clk[1]) begin  
        if (tx_reset[1]) begin
            tx_axis_tdata[1] <= 0;
            tx_axis_tlast[1] <= 0;
        end else begin
            if (tx_axis_tready[1]) begin
                tx_axis_tdata[1] <= tx_axis_tdata[1] + 1;
            end                     
        end
    end

    always_ff @(posedge mii_tx_clk[0]) begin          
        if (tx_reset[0]) begin
            tx_axis_tdata[0] <= 0;
            tx_axis_tlast[1] <= 0;
        end else begin
            if (tx_axis_tready[0]) begin
                tx_axis_tdata[0] <= tx_axis_tdata[0] + 1;
            end                        
        end               
    end
    
    assign tx_axis_tlast[1] = (tx_axis_tdata[1] == 255) ? 1'b1 : 1'b0;
    assign tx_axis_tlast[0] = (tx_axis_tdata[0] == 255) ? 1'b1 : 1'b0;
    assign tx_axis_tuser[1] = 0;
    assign tx_axis_tuser[0] = 0;

endmodule

/*
module eth_mac_mii #
(
    // target ("SIM", "GENERIC", "XILINX", "ALTERA")
    parameter TARGET = "GENERIC",
    // Clock input style ("BUFG", "BUFR", "BUFIO", "BUFIO2")
    // Use BUFR for Virtex-5, Virtex-6, 7-series
    // Use BUFG for Ultrascale
    // Use BUFIO2 for Spartan-6
    parameter CLOCK_INPUT_STYLE = "BUFIO2",
    parameter ENABLE_PADDING = 1,
    parameter MIN_FRAME_LENGTH = 64
)
(
    input  wire        rst,
    output wire        rx_clk,
    output wire        rx_rst,
    output wire        tx_clk,
    output wire        tx_rst,

    input  wire [7:0]  tx_axis_tdata,
    input  wire        tx_axis_tvalid,
    output wire        tx_axis_tready,
    input  wire        tx_axis_tlast,
    input  wire        tx_axis_tuser,

    output wire [7:0]  rx_axis_tdata,
    output wire        rx_axis_tvalid,
    output wire        rx_axis_tlast,
    output wire        rx_axis_tuser,

    input  wire        mii_rx_clk,
    input  wire [3:0]  mii_rxd,
    input  wire        mii_rx_dv,
    input  wire        mii_rx_er,
    input  wire        mii_tx_clk,
    output wire [3:0]  mii_txd,
    output wire        mii_tx_en,
    output wire        mii_tx_er,

    output wire        tx_start_packet,
    output wire        tx_error_underflow,
    output wire        rx_start_packet,
    output wire        rx_error_bad_frame,
    output wire        rx_error_bad_fcs,

    input  wire [7:0]  ifg_delay
);
*/

