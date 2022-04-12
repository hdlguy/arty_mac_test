module top #(
    parameter logic[47:0] local_mac     = 48'h00_0a_35_01_02_03,    // a Xilinx mac address
    parameter logic[31:0] local_ip      = 32'h10_00_00_80,          // 16.0.0.128
    parameter logic[15:0] local_port    = 16'h04d2                  // 1234
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

    logic clk, clk125, clk25, locked;
    clk_wiz clk_wiz_inst (.clkin100(clkin100), .resetn(resetn), .locked(locked), .clkout100(clk), .clkout125(clk125), .clkout25(clk25));
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

 /*   
    // tx fifo
    logic[7:0] tx_fifo_tdata;
    logic tx_fifo_empty, tx_fifo_tlast, tx_fifo_tuser, tx_fifo_tready, tx_fifo_tvalid;
    mac_fifo tx_mac_fifo(
        .wr_clk(clk),              .full(tx_fifo_full),   .wr_en(tx_fifo_tvalid),     .din ({tx_fifo_tlast, tx_fifo_tuser, tx_fifo_tdata}), 
        .rd_clk(tx_axis_mac_aclk), .empty(tx_fifo_empty), .rd_en(tx_axis_mac_tready), .dout({tx_axis_mac_tlast, tx_axis_mac_tuser, tx_axis_mac_tdata})
    );
    assign tx_fifo_tready     = ~tx_fifo_full;
    assign tx_axis_mac_tvalid = ~tx_fifo_empty;
    
    
    //rx fifo 
    logic[7:0] rx_fifo_tdata;
    logic rx_fifo_empty, rx_fifo_tlast, rx_fifo_tuser, rx_fifo_tready, rx_fifo_tvalid;
    mac_fifo rx_mac_fifo(
        .wr_clk(rx_axis_mac_aclk), .full(),               .wr_en(rx_axis_mac_tvalid), .din ({rx_axis_mac_tlast, rx_axis_mac_tuser, rx_axis_mac_tdata}), 
        .rd_clk(clk),              .empty(rx_fifo_empty), .rd_en(rx_fifo_tready),     .dout({    rx_fifo_tlast,     rx_fifo_tuser,     rx_fifo_tdata})
    );
    assign rx_fifo_tvalid = ~rx_fifo_empty;  


    // receive and decode arp requests
    logic  arp_rx_dv_out;
    logic[47:0] remote_mac;
    logic[31:0] remote_ip;
    logic udp_rx_tvalid, udp_rx_tready, udp_rx_tlast, udp_rx_tuser;
    logic[7:0] udp_rx_tdata;
    arp_rx #(.local_ip(local_ip)) arp_rx_inst (
        .clk(clk), 
        .rx_fifo_tvalid(rx_fifo_tvalid), .rx_fifo_tready(rx_fifo_tready), .rx_fifo_tdata(rx_fifo_tdata) , .rx_fifo_tlast(rx_fifo_tlast), .rx_fifo_tuser(rx_fifo_tuser),  // connect to rx fifo
        .dv_out(arp_rx_dv_out), .remote_mac(remote_mac), .remote_ip(remote_ip),
        .udp_tvalid(udp_rx_tvalid), .udp_tdata(udp_rx_tdata), .udp_tlast(udp_rx_tlast), .udp_tuser(udp_rx_tuser)
    );
    assign udp_rx_tready = 1;


    // send an arp reply
    logic udp_tx_tvalid, udp_tx_tready, udp_tx_tlast, udp_tx_tuser;
    logic[7:0] udp_tx_tdata;
    arp_tx #(.local_mac(local_mac), .local_ip(local_ip), .local_port(local_port)) arp_tx_inst (
        .clk(clk),
        .tx_fifo_tvalid(tx_fifo_tvalid), .tx_fifo_tready(tx_fifo_tready), .tx_fifo_tdata(tx_fifo_tdata) , .tx_fifo_tlast(tx_fifo_tlast), .tx_fifo_tuser(tx_fifo_tuser),  // connect to tx fifo
        .arp_dv_in(arp_rx_dv_out), .remote_mac(remote_mac), .remote_ip(remote_ip),
        .udp_tvalid(udp_tx_tvalid), .udp_tready(udp_tx_tready), .udp_tdata(udp_tx_tdata), .udp_tlast(udp_tx_tlast), .udp_tuser(udp_tx_tuser)
    );


    // a fifo to buffer udp tx frames
    logic udp_tx_fifo_empty, udp_tx_fifo_full;
    logic[7:0] udp_tx_fifo_tdata;
    udp_fifo udp_tx_fifo (
        .wr_clk(clk), .full(udp_tx_fifo_full),   .wr_en(udp_tx_fifo_tvalid), .din({udp_tx_fifo_tlast, udp_tx_fifo_tuser, udp_tx_fifo_tdata}),
        .rd_clk(clk), .empty(udp_tx_fifo_empty), .rd_en(udp_tx_tready),      .dout({    udp_tx_tlast,      udp_tx_tuser,      udp_tx_tdata})
    );
    assign udp_tx_tvalid      = ~udp_tx_fifo_empty;
    assign udp_tx_fifo_tready = ~udp_tx_fifo_full;
    
              
    // keep the udp_tx_fifo full of frames.
    udp_frame_gen gen_inst (.clk(clk), .enable(sw[0]), .m_tvalid(udp_tx_fifo_tvalid), .m_tready(udp_tx_fifo_tready), .m_tdata(udp_tx_fifo_tdata), .m_tlast(udp_tx_fifo_tlast), .m_tuser(udp_tx_fifo_tuser));


    
    eth_ila eth_ila (
        .clk(clk), 
        .probe0({tx_fifo_tready, tx_fifo_tvalid, tx_fifo_tlast, tx_fifo_tuser, tx_fifo_tdata}), // 12
        .probe1({rx_fifo_tready, rx_fifo_tvalid, rx_fifo_tlast, rx_fifo_tuser, rx_fifo_tdata}), // 12
        .probe2({ udp_rx_tready,  udp_rx_tvalid,  udp_rx_tlast,  udp_rx_tuser,  udp_rx_tdata}), // 12
        .probe3({ udp_tx_tready,  udp_tx_tvalid,  udp_tx_tlast,  udp_tx_tuser,  udp_tx_tdata}), // 12
        .probe4(arp_rx_dv_out)
    );
*/

    udp_stack #(.local_mac(local_mac), .local_ip(local_ip), .local_port(local_port)) udp_stack_inst (
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
    
    // a fifo to loop udp frames
    logic udp_loop_fifo_empty, udp_loop_fifo_full;
    udp_fifo udp_loop_fifo (
        .wr_clk(clk), .full (udp_loop_fifo_full),  .wr_en(udp_rx_tvalid), .din ({udp_rx_tlast, udp_rx_tuser, udp_rx_tdata}),
        .rd_clk(clk), .empty(udp_loop_fifo_empty), .rd_en(udp_tx_tready), .dout({udp_tx_tlast, udp_tx_tuser, udp_tx_tdata})
    );
    assign udp_rx_tready = ~udp_loop_fifo_full;
    assign udp_tx_tvalid = ~udp_loop_fifo_empty;


endmodule


/*
module udp_stack #(
    parameter logic[47:0] local_mac     = 48'h00_0a_35_01_02_03,    // a Xilinx mac address
    parameter logic[31:0] local_ip      = 32'h10_00_00_80,          // 16.0.0.128
    parameter logic[15:0] local_port    = 16'h04d2                  // 1234
) (
    input   logic           clk,
    // rx data from temac
    input   logic           rx_axis_mac_aclk,
    input   logic           rx_axis_mac_tvalid,
    input   logic[7:0]      rx_axis_mac_tdata,
    input   logic           rx_axis_mac_tlast,
    input   logic           rx_axis_mac_tuser,
    // tx data to temac
    input   logic           tx_axis_mac_aclk,
    output  logic           tx_axis_mac_tvalid,
    input   logic           tx_axis_mac_tready,
    output  logic[7:0]      tx_axis_mac_tdata,
    output  logic           tx_axis_mac_tlast,
    output  logic           tx_axis_mac_tuser
    // udp message to receive
    output  logic           udp_rx_tvalid, 
    input   logic           udp_rx_tready, 
    output  logic[7:0]      udp_rx_tdata,
    output  logic           udp_rx_tlast, 
    output  logic           udp_rx_tuser,
    // udp message to transmit
    input   logic           udp_tx_tvalid, 
    output  logic           udp_tx_tready, 
    input   logic[7:0]      udp_tx_tdata,
    input   logic           udp_tx_tlast, 
    input   logic           udp_tx_tuser
);
*/
