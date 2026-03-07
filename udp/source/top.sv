module top #(
    parameter logic[47:0] local_mac     = 48'h00_0a_35_01_02_03,    // a Xilinx mac address
    parameter logic[31:0] local_ip      = 32'h10_00_00_80,          // 16.0.0.128
    parameter logic[15:0] local_port    = 16'h04d2,                 // 1234
    parameter logic[15:0] remote_port   = 16'h04d2                  // 1234
) (
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
    output  logic           eth_refclk      
);

    assign led_b = sw;

    logic clk, clk25, locked;
    clk_wiz clk_wiz_inst (.clkin100(clkin100), .resetn(resetn), .locked(locked), .clkout100(clk), .clkout25(clk25));
    assign eth_refclk = clk25;
    

    logic           rx_axis_mac_aclk;
    logic           rx_axis_mac_tvalid;
    logic [7 : 0]   rx_axis_mac_tdata;
    logic           rx_axis_mac_tlast;
    logic           rx_axis_mac_tuser;
                                           
    logic           tx_axis_mac_aclk;
    logic           tx_axis_mac_tvalid;
    logic           tx_axis_mac_tready;
    logic [7 : 0]   tx_axis_mac_tdata;
    logic           tx_axis_mac_tlast;
    logic           tx_axis_mac_tuser;
                                           
    // this is a wrapper containing the Xilinx TEMAC core.
    temac temac_inst (
        .resetn(locked),
        //
        .eth_mii_tx_clk (eth_mii_tx_clk), 
        .eth_mii_txd    (eth_mii_txd), 
        .eth_mii_tx_en  (eth_mii_tx_en),  
        .eth_mii_rx_clk (eth_mii_rx_clk), 
        .eth_mii_rxd    (eth_mii_rxd), 
        .eth_mii_rx_dv  (eth_mii_rx_dv), 
        .eth_mii_rx_er  (eth_mii_rx_er), 
        .eth_mii_rst_n  (eth_mii_rst_n),
        //    
        .rx_axis_aclk   (rx_axis_mac_aclk), 
        .rx_axis_tvalid (rx_axis_mac_tvalid),                                       
        .rx_axis_tdata  (rx_axis_mac_tdata), 
        .rx_axis_tlast  (rx_axis_mac_tlast), 
        .rx_axis_tuser  (rx_axis_mac_tuser),
        //
        .tx_axis_aclk   (tx_axis_mac_aclk), 
        .tx_axis_tvalid (tx_axis_mac_tvalid), 
        .tx_axis_tready (tx_axis_mac_tready),  
        .tx_axis_tdata  (tx_axis_mac_tdata), 
        .tx_axis_tlast  (tx_axis_mac_tlast), 
        .tx_axis_tuser  (tx_axis_mac_tuser)
    );



    logic udp_rx_tvalid, udp_rx_tready, udp_rx_tlast, udp_rx_tuser;
    logic[7:0] udp_rx_tdata;
    logic udp_tx_tvalid, udp_tx_tready, udp_tx_tlast, udp_tx_tuser;
    logic[7:0] udp_tx_tdata;

    udp_stack #(.local_mac(local_mac), .local_ip(local_ip), .local_port(local_port), .remote_port(remote_port)) udp_stack_inst (
        .clk(clk),
        // rx data from temac
        .rx_axis_mac_aclk   (rx_axis_mac_aclk   ),
        .rx_axis_mac_tvalid (rx_axis_mac_tvalid ),
        .rx_axis_mac_tdata  (rx_axis_mac_tdata  ),
        .rx_axis_mac_tlast  (rx_axis_mac_tlast  ),
        .rx_axis_mac_tuser  (rx_axis_mac_tuser  ),
        // tx data to temac
        .tx_axis_mac_aclk   (tx_axis_mac_aclk   ),
        .tx_axis_mac_tvalid (tx_axis_mac_tvalid ),
        .tx_axis_mac_tready (tx_axis_mac_tready ),
        .tx_axis_mac_tdata  (tx_axis_mac_tdata  ),
        .tx_axis_mac_tlast  (tx_axis_mac_tlast  ),
        .tx_axis_mac_tuser  (tx_axis_mac_tuser  ),
        // udp message to receive
        .udp_rx_tvalid      (udp_rx_tvalid  ), 
        .udp_rx_tready      (udp_rx_tready  ), 
        .udp_rx_tdata       (udp_rx_tdata   ),
        .udp_rx_tlast       (udp_rx_tlast   ), 
        .udp_rx_tuser       (udp_rx_tuser   ),
        // udp message to transmit
        .udp_tx_tvalid      (udp_tx_tvalid  ), 
        .udp_tx_tready      (udp_tx_tready  ), 
        .udp_tx_tdata       (udp_tx_tdata   ),
        .udp_tx_tlast       (udp_tx_tlast   ), 
        .udp_tx_tuser       (udp_tx_tuser   )
    );

/*
    // a fifo to loop udp frames
    logic udp_loop_fifo_empty, udp_loop_fifo_full;
    udp_fifo udp_loop_fifo (
        .wr_clk(clk), .full (udp_loop_fifo_full),  .wr_en(udp_rx_tvalid), .din ({udp_rx_tlast, udp_rx_tuser, udp_rx_tdata}),
        .rd_clk(clk), .empty(udp_loop_fifo_empty), .rd_en(udp_tx_tready), .dout({udp_tx_tlast, udp_tx_tuser, udp_tx_tdata})
    );
    assign udp_rx_tready = ~udp_loop_fifo_full;
    assign udp_tx_tvalid = ~udp_loop_fifo_empty;
*/

    // a register file we can write with udp messages.
    localparam int Nregs = 16;
    logic[Nregs-1:0][31:0] wr_regs;
    logic wr_regs_dv;
    udp_frame_rx #(.Nregs(Nregs)) udp_frame_rx_inst (
        .clk(clk), 
        .rx_tvalid(udp_rx_tvalid), .rx_tready(udp_rx_tready), .rx_tdata(udp_rx_tdata), .rx_tlast(udp_rx_tlast), .rx_tuser(udp_rx_tuser),
        .dv_out(wr_regs_dv), .wr_val(wr_regs)
    );

    assign led = wr_regs[2][3:0];

    // a frame generator to pump out udp test payloads.
    udp_frame_gen frame_gen_inst (
        .clk(clk), .enable(sw[0]),
        .m_tvalid(udp_tx_tvalid), .m_tready(udp_tx_tready), .m_tdata(udp_tx_tdata), .m_tlast(udp_tx_tlast), .m_tuser(udp_tx_tuser)
    );

endmodule


/*
module udp_frame_rx #(
    parameter int Nregs = 16
)(
    input   logic                   clk,
    // axi-stream interface from rx fifo.
    input   logic                   rx_tvalid,
    output  logic                   rx_tready, 
    input   logic[7:0]              rx_tdata,
    input   logic                   rx_tlast, 
    input   logic                   rx_tuser, 
    // register interface
    output  logic                   dv_out = 0,
    output  logic[Nregs-1:0][31:0]  wr_val // register file
);
module udp_frame_gen (
    input   logic       clk,
    input   logic       enable,
    output  logic       m_tvalid,
    input   logic       m_tready, 
    output  logic[7:0]  m_tdata,
    output  logic       m_tlast, 
    output  logic       m_tuser
);
*/


