module arp_rx_tb ();

    logic       rx_fifo_tvalid,     fifo_tvalid;
    logic       rx_fifo_tready,     fifo_tready; 
    logic[7:0]  rx_fifo_tdata,      fifo_tdata;
    logic       rx_fifo_tlast,      fifo_tlast; 
    logic       rx_fifo_tuser,      fifo_tuser; 
    logic       dv_out;
    logic[47:0] remote_mac;
    logic[31:0] remote_ip;
    logic       udp_tvalid;
    logic       udp_tready;
    logic[7:0]  udp_tdata;
    logic       udp_tlast; 
    logic       udp_tuser;    

    localparam logic[47:0] local_mac = 48'h00_0a_35_01_02_03;
    localparam logic[31:0] local_ip  = 32'h10_00_00_80;  // 16.0.0.128

    logic  clk = 0; localparam  clk_period = 10; always #(clk_period/2)  clk =  ~clk;

    arp_rx #(.local_mac(local_mac), .local_ip(local_ip)) uut (.*);            
    
    logic fifo_empty, fifo_full;
    mac_fifo rx_fifo (
        .wr_clk(clk), .full(fifo_full),  .wr_en(fifo_tvalid),     .din({fifo_tlast, fifo_tuser, fifo_tdata}),      
        .rd_clk(clk), .empty(fifo_empty), .rd_en(rx_fifo_tready),  .dout({rx_fifo_tlast, rx_fifo_tuser, rx_fifo_tdata})
    );
    assign rx_fifo_tvalid = ~fifo_empty;
    assign fifo_tready    = ~fifo_full;

    // 94:10:3e:b7:e2:01
    
    // define a legal udp packet
    localparam int udp_len = 46;
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
    assign udp_bytes[38:39] = 16'h000d;
    assign udp_bytes[40:41] = 16'h0000;
    assign udp_bytes[42:45] = 32'h55_66_77_88;
    
    assign udp_tready = 1;
    
    initial begin
        fifo_tvalid = 0;
        fifo_tdata  = 8'bxxxx_xxxx;
        fifo_tlast  = 0;
        fifo_tuser  = 0; 
        #(clk_period*10);

        forever begin

            // an arp frame
            // destination address for broadcast
            for (int i=0; i<6; i++) begin        
                fifo_tvalid = 1;
                fifo_tdata  = 8'hff;
                fifo_tlast = 0;
                #(clk_period*1);
            end
            
            // source address from computer
            fifo_tvalid = 1;
            fifo_tdata  = 8'h94;
            fifo_tlast = 0;
            #(clk_period*1);
            
            fifo_tvalid = 1;
            fifo_tdata  = 8'h10;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'h3e;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'hb7;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'he2;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
    
            fifo_tvalid = 1;
            fifo_tdata  = 8'h01;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
    
            // frame type
            fifo_tvalid = 1;
            fifo_tdata  = 8'h08;
            fifo_tlast = 0;
            #(clk_period*1);                                                               

            fifo_tvalid = 1;
            fifo_tdata  = 8'h06;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            // hardware type = ethernet
            fifo_tvalid = 1;
            fifo_tdata  = 8'h00;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            fifo_tvalid = 1;
            fifo_tdata  = 8'h01;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            // protocol = ip
            fifo_tvalid = 1;
            fifo_tdata  = 8'h08;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            fifo_tvalid = 1;
            fifo_tdata  = 8'h00;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            // hardware size
            fifo_tvalid = 1;
            fifo_tdata  = 8'h06;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            // protocol size
            fifo_tvalid = 1;
            fifo_tdata  = 8'h04;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            // operation
            fifo_tvalid = 1;
            fifo_tdata  = 8'h00;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            fifo_tvalid = 1;
            fifo_tdata  = 8'h01;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
                    
            // source address from computer, again
            fifo_tvalid = 1;
            fifo_tdata  = 8'h94;
            fifo_tlast = 0;
            #(clk_period*1);
            
            fifo_tvalid = 1;
            fifo_tdata  = 8'h10;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'h3e;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'hb7;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'he2;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
    
            fifo_tvalid = 1;
            fifo_tdata  = 8'h01;
            fifo_tlast = 0;
            #(clk_period*1);                                                               
    
            // source ip address from computer, 16.0.0.200
            fifo_tvalid = 1;
            fifo_tdata  = 8'h10;
            fifo_tlast = 0;
            #(clk_period*1);
            
            fifo_tvalid = 1;
            fifo_tdata  = 8'h00;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'h00;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'hc8;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            // destination mac address, not known so all zeros 
            for (int i=0; i<6; i++) begin        
                fifo_tvalid = 1;
                fifo_tdata  = 8'h00;
                fifo_tlast = 0;
                #(clk_period*1);
            end
            
            // target ip address for fpga, 16.0.0.128
            fifo_tvalid = 1;
            fifo_tdata  = 8'h10;
            fifo_tlast = 0;
            #(clk_period*1);
            
            fifo_tvalid = 1;
            fifo_tdata  = 8'h00;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'h00;
            fifo_tlast = 0;
            #(clk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'h80;
            fifo_tlast = 1;
            #(clk_period*1);
                        

            // a gap
            fifo_tvalid = 0;
            fifo_tdata  = 8'bxxxx_xxxx;
            fifo_tlast = 0;
            #(clk_period*40);
            
            
            // a udp frame
            for (int i=0; i<udp_len; i++) begin        
                fifo_tvalid = 1;
                fifo_tdata  = udp_bytes[i];
                if (i==udp_len-1) fifo_tlast = 1; else fifo_tlast = 0;
                #(clk_period*1);
            end
            
            
            // a gap
            fifo_tvalid = 0;
            fifo_tdata  = 8'bxxxx_xxxx;
            fifo_tlast = 0;
            #(clk_period*40);
            
        end
                      
    end

endmodule


