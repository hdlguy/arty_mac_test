

module arp_rx (
    input   logic                   clk,
    // axi-stream interface from rx fifo.
    output  logic                   tx_fifo_tvalid,
    input   logic                   tx_fifo_tready, 
    output  logic[7:0]              tx_fifo_tdata,
    output  logic                   tx_fifo_tlast, 
    output  logic                   tx_fifo_tuser, 
    // 
    input   logic                   dv_in = 0,
    input   logic[47:0]             remote_mac,
    input   logic[31:0]             remote_ip
);

