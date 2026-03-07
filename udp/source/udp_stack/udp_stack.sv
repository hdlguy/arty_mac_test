// This block contains the logic to implement the UDP hardware stack.
// The MAC is external.
// 
module udp_stack #(
    parameter logic[47:0] local_mac     = 48'h00_0a_35_01_02_03,    // a Xilinx mac address
    parameter logic[31:0] local_ip      = 32'h10_00_00_80,          // 16.0.0.128
    parameter logic[15:0] local_port    = 16'h04d2,                 // 1234
    parameter logic[15:0] remote_port   = 16'h04d2                  // 1234
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
    output  logic           tx_axis_mac_tuser,
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


    // tx fifo
    logic[7:0] tx_fifo_tdata;
    logic tx_fifo_empty, tx_fifo_tlast, tx_fifo_tuser, tx_fifo_tready, tx_fifo_tvalid;
    mac_fifo tx_mac_fifo(
        .wr_clk(clk),              .full(tx_fifo_full),   .wr_en(tx_fifo_tvalid),     .din ({    tx_fifo_tlast,     tx_fifo_tuser,     tx_fifo_tdata}), 
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


    // receive arp requests and pass udp messages to application
    logic  arp_rx_dv_out;
    logic[47:0] remote_mac;
    logic[31:0] remote_ip;
    arp_rx #(.local_mac(local_mac), .local_ip(local_ip), .local_port(local_port)) arp_rx_inst (
        .clk(clk), 
        .rx_fifo_tvalid(rx_fifo_tvalid), .rx_fifo_tready(rx_fifo_tready), .rx_fifo_tdata(rx_fifo_tdata) , .rx_fifo_tlast(rx_fifo_tlast), .rx_fifo_tuser(rx_fifo_tuser),  // connect to rx fifo
        .dv_out(arp_rx_dv_out), .remote_mac(remote_mac), .remote_ip(remote_ip),
        .udp_tvalid(udp_rx_tvalid), .udp_tdata(udp_rx_tdata), .udp_tlast(udp_rx_tlast), .udp_tuser(udp_rx_tuser)
    );


    // send arp replies and format udp frames for transmit
    logic buf_tx_tvalid, buf_tx_tready, buf_tx_tlast, buf_tx_tuser;
    logic[7:0] buf_tx_tdata;
    logic length_tvalid, length_tready;
    logic[15:0] length_tdata;
    arp_tx #(.local_mac(local_mac), .local_ip(local_ip), .local_port(local_port), .remote_port(remote_port)) arp_tx_inst (
        .clk(clk),
        .tx_fifo_tvalid(tx_fifo_tvalid), .tx_fifo_tready(tx_fifo_tready), .tx_fifo_tdata(tx_fifo_tdata) , .tx_fifo_tlast(tx_fifo_tlast), .tx_fifo_tuser(tx_fifo_tuser),  // connect to tx fifo
        .arp_dv_in(arp_rx_dv_out), .remote_mac(remote_mac), .remote_ip(remote_ip),
        .udp_tvalid(buf_tx_tvalid), .udp_tready(buf_tx_tready), .udp_tdata(buf_tx_tdata), .udp_tlast(buf_tx_tlast), .udp_tuser(buf_tx_tuser),
        .length_tvalid(length_tvalid), .length_tready(length_tready), .length_tdata(length_tdata)
    );
    assign buf_tx_tuser = 0;


    // this buffers the tx udp packets and determines their length.
    totlen totlen_inst (
        .clk(clk),
        .s_tvalid(udp_tx_tvalid), .s_tready(udp_tx_tready), .s_tdata(udp_tx_tdata), .s_tlast(udp_tx_tlast),
        .m_tvalid(buf_tx_tvalid), .m_tready(buf_tx_tready), .m_tdata(buf_tx_tdata), .m_tlast(buf_tx_tlast),
        .length_tvalid(length_tvalid), .length_tready(length_tready), .length_tdata(length_tdata)
    );



    // an ILA debug core
    eth_ila eth_ila (
        .clk(clk), 
        .probe0({tx_fifo_tready, tx_fifo_tvalid, tx_fifo_tlast, tx_fifo_tuser, tx_fifo_tdata}), // 12
        .probe1({rx_fifo_tready, rx_fifo_tvalid, rx_fifo_tlast, rx_fifo_tuser, rx_fifo_tdata}), // 12
        .probe2({ udp_rx_tready,  udp_rx_tvalid,  udp_rx_tlast,  udp_rx_tuser,  udp_rx_tdata}), // 12
        .probe3({ udp_tx_tready,  udp_tx_tvalid,  udp_tx_tlast,  udp_tx_tuser,  udp_tx_tdata}), // 12
        .probe4({arp_rx_dv_out, length_tvalid, length_tready, length_tdata})                    // 19
    );

endmodule

/*
*/
