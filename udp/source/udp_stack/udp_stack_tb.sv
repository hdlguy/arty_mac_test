module udp_stack_tb ();

    // rx data from temac
    logic           rx_axis_mac_aclk;
    logic           rx_axis_mac_tvalid;
    logic[7:0]      rx_axis_mac_tdata;
    logic           rx_axis_mac_tlast;
    logic           rx_axis_mac_tuser;
    // tx data to temac
    logic           tx_axis_mac_aclk;
    logic           tx_axis_mac_tvalid;
    logic           tx_axis_mac_tready=0;
    logic[7:0]      tx_axis_mac_tdata;
    logic           tx_axis_mac_tlast;
    logic           tx_axis_mac_tuser;
    // udp message to receive
    logic           udp_rx_tvalid; 
    logic           udp_rx_tready; 
    logic[7:0]      udp_rx_tdata;
    logic           udp_rx_tlast; 
    logic           udp_rx_tuser;
    // udp message to transmit
    logic           udp_tx_tvalid; 
    logic           udp_tx_tready; 
    logic[7:0]      udp_tx_tdata;
    logic           udp_tx_tlast; 
    logic           udp_tx_tuser;

    logic clk=0; localparam clk_period=10; always #(clk_period/2)  clk=~clk;
    assign rx_axis_mac_aclk = clk;
    assign tx_axis_mac_aclk = clk;
    
    localparam logic[47:0] local_mac    = 48'h00_0a_35_01_02_03;
    localparam logic[31:0] local_ip     = 32'h10_00_00_80;  // 16.0.0.128
    localparam logic[15:0] local_port   = 16'h04d2;         // 1234
    localparam logic[15:0] remote_port  = 16'h04d2;         // 1234

    udp_stack #(.local_mac(local_mac), .local_ip(local_ip), .local_port(local_port), .remote_port(remote_port)) uut (.*);            
    
    // define a legal arp packet
    localparam int arp_len = 46;
    logic[0:arp_len-1][7:0] arp_bytes;
    assign arp_bytes[ 0: 5] = 48'hff_ff_ff_ff_ff_ff;
    assign arp_bytes[ 6:11] = 48'h94_10_3e_b7_e2_01;
    assign arp_bytes[12:13] = 16'h0806;
    assign arp_bytes[14:15] = 16'h0001;
    assign arp_bytes[16:17] = 16'h0800;
    assign arp_bytes[18:19] = 16'h0604;
    assign arp_bytes[20:21] = 16'h0001;
    assign arp_bytes[22:27] = 48'h94_10_3e_b7_e2_01;
    assign arp_bytes[28:31] = 32'h10_00_00_c8;
    assign arp_bytes[32:37] = 48'h00_00_00_00_00_00;
    assign arp_bytes[38:41] = 32'h10_00_00_80;
    
    // define a legal udp packet
    localparam int udp_len = 50;
    logic[0:udp_len-1][7:0] udp_bytes;
    assign udp_bytes[ 0: 5] = local_mac;
    assign udp_bytes[ 6:11] = 48'h94_10_3e_b7_e2_01;
    assign udp_bytes[12:13] = 16'h0800;
    assign udp_bytes[   14] = 8'h45;
    assign udp_bytes[   15] = 8'h00;
    assign udp_bytes[16:17] = 16'h0021;
    assign udp_bytes[18:19] = 16'h92d8;
    assign udp_bytes[20:21] = 16'h0400;
    assign udp_bytes[   22] = 8'h40;
    assign udp_bytes[   23] = 8'h11;
    assign udp_bytes[24:25] = 16'h0000;
    assign udp_bytes[26:29] = 32'h10_00_00_c8;
    assign udp_bytes[30:33] = 32'h10_00_00_80;
    assign udp_bytes[34:35] = 16'h9a0d;
    assign udp_bytes[36:37] = 16'h04d2;
    assign udp_bytes[38:39] = 16'h000c;
    assign udp_bytes[40:41] = 16'h0000;
    assign udp_bytes[42:45] = 32'h55_66_77_88;
    assign udp_bytes[46:49] = 32'h00_00_00_00; // padding
    
    assign udp_rx_tready = 1;
    
    initial begin
        rx_axis_mac_tvalid = 0;
        rx_axis_mac_tdata  = 8'bxxxx_xxxx;
        rx_axis_mac_tlast  = 0;
        rx_axis_mac_tuser  = 0; 
        #(clk_period*10);

        forever begin

             // a arp frame
            for (int i=0; i<arp_len; i++) begin        
                rx_axis_mac_tvalid = 1;
                rx_axis_mac_tdata  = arp_bytes[i];
                if (i==arp_len-1) rx_axis_mac_tlast = 1; else rx_axis_mac_tlast = 0;
                #(clk_period*1);

                rx_axis_mac_tvalid = 0;
                rx_axis_mac_tdata  = arp_bytes[i];
                if (i==arp_len-1) rx_axis_mac_tlast = 1; else rx_axis_mac_tlast = 0;
                #(clk_period*7);
            end                       

            // a gap
            rx_axis_mac_tvalid = 0;
            rx_axis_mac_tdata  = 8'bxxxx_xxxx;
            rx_axis_mac_tlast = 0;
            #(clk_period*40);
            
            
            // a udp frame
            for (int i=0; i<udp_len; i++) begin        
                rx_axis_mac_tvalid = 1;
                rx_axis_mac_tdata  = udp_bytes[i];
                if (i==udp_len-1) rx_axis_mac_tlast = 1; else rx_axis_mac_tlast = 0;
                #(clk_period*1);

                rx_axis_mac_tvalid = 0;
                rx_axis_mac_tdata  = udp_bytes[i];
                if (i==udp_len-1) rx_axis_mac_tlast = 1; else rx_axis_mac_tlast = 0;
                #(clk_period*7);
            end
            
            
            // a gap
            rx_axis_mac_tvalid = 0;
            rx_axis_mac_tdata  = 8'bxxxx_xxxx;
            rx_axis_mac_tlast = 0;
            #(clk_period*40);
            
        end
                      
    end

    logic gen_enable;
    udp_frame_gen udp_frame_gen_inst(.clk(clk), .enable(gen_enable), .m_tvalid(udp_tx_tvalid ), .m_tready(udp_tx_tready), .m_tdata(udp_tx_tdata), .m_tlast(udp_tx_tlast), .m_tuser(udp_tx_tuser));

    initial begin
        gen_enable = 0;
        #(clk_period*1000);
        gen_enable = 1;
    end
    
    // generate a realistic tready
    logic[2:0] tx_tready_count = 0;
    always_ff @(posedge clk) begin
        tx_tready_count <= tx_tready_count + 1;    
        if (tx_tready_count == 7) tx_axis_mac_tready <= 1; else tx_axis_mac_tready <= 0;
    end

endmodule

/*
module udp_frame_gen (
    //
    input  logic            clk,
    input  logic            enable,
    // fifo interface
    output logic [7 : 0]    m_tdata,
    output logic            m_tvalid,
    output logic            m_tlast,
    output logic            m_tuser,
    input  logic            m_tready
);

*/
