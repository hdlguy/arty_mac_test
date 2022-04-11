module arp_tx_tb ();

    logic       tx_fifo_tvalid;
    logic       tx_fifo_tready=0; 
    logic[7:0]  tx_fifo_tdata;
    logic       tx_fifo_tlast; 
    logic       tx_fifo_tuser; 
    logic       arp_dv_in;
    logic[47:0] remote_mac;
    logic[31:0] remote_ip;
    logic       udp_tvalid;
    logic       udp_tready;
    logic[7:0]  udp_tdata;
    logic       udp_tlast; 
    logic       udp_tuser;

    localparam logic[47:0] local_mac = 48'h00_0a_35_01_02_03;
    localparam logic[31:0] local_ip  = 32'h10_00_00_80;
    localparam logic[15:0] local_port  = 16'h04d2;

    assign remote_mac = 48'h94_10_3e_b7_e2_01;
    assign remote_ip  = 32'h10_00_00_c8;

    logic  clk = 0; localparam  clk_period = 10; always #( clk_period/2)  clk =  ~clk;

    arp_tx #(.local_mac(local_mac), .local_ip(local_ip), .local_port(local_port)) uut (.*);          

    
    logic fifo_empty, fifo_full;
    logic[7:0] fifo_tdata;
    udp_fifo udp_tx_fifo (
        .wr_clk(clk), .full(fifo_full),   .wr_en(fifo_tvalid), .din({fifo_tlast, fifo_tuser, fifo_tdata}),
        .rd_clk(clk), .empty(fifo_empty), .rd_en(udp_tready),  .dout({udp_tlast,  udp_tuser,  udp_tdata})
    );
    assign udp_tvalid = ~fifo_empty;
    assign fifo_tready    = ~fifo_full;
              
    
    initial begin
            
        forever begin
            arp_dv_in = 0;
            #(clk_period*1000);
        
            arp_dv_in = 1;
            #(clk_period*1);
        end
    
    end


    // throttle the tx mac fifo a little.
    logic[2:0] tready_count = 7;
    always_ff @(posedge clk) begin
        tready_count <= tready_count - 1;
        if (tready_count==0) begin
            tx_fifo_tready <= 1;
        end else begin
            tx_fifo_tready <= 0;
        end
    end
       
    
    // keep the udp_tx_fifo full of frames.
    udp_frame_gen gen_inst (.clk(clk), .m_tvalid(fifo_tvalid), .m_tready(fifo_tready), .m_tdata(fifo_tdata), .m_tlast(fifo_tlast), .m_tuser(fifo_tuser));

/*
    localparam int Nudp = 256;
    assign fifo_tvalid = 1;
    assign fifo_tuser = 0;
    int fifo_count=0;
    always_ff @(posedge clk) begin
        if ((fifo_tready) && (fifo_tvalid)) begin
            if (fifo_count == Nudp-1) begin
                fifo_count <= 0;
            end else begin
                fifo_count <= fifo_count + 1;
            end
        end
    end
    assign fifo_tdata = fifo_count;
    assign fifo_tlast = (fifo_count == Nudp-1) ? 1 : 0;
*/

endmodule

/*
module udp_frame_gen (
    input   logic       clk,
    output  logic       m_tvalid,
    input   logic       m_tready, 
    output  logic[7:0]  m_tdata,
    output  logic       m_tlast, 
    output  logic       m_tuser
);

    localparam int Nudp = 32;
*/
