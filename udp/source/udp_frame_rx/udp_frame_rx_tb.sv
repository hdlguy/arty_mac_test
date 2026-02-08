module udp_frame_rx_tb ();

    localparam int Nregs = 16;

    logic       rx_tvalid,     fifo_tvalid;
    logic       rx_tready,     fifo_tready; 
    logic[7:0]  rx_tdata,      fifo_tdata;
    logic       rx_tlast,      fifo_tlast; 
    logic       rx_tuser,      fifo_tuser; 
    logic       dv_out;
    logic[Nregs-1:0][31:0] wr_val;

    logic  clk = 0; localparam  clk_period = 10; always #( clk_period/2)  clk =  ~clk;

    udp_frame_rx #(.Nregs(Nregs)) uut (.*);            
    
    logic fifo_empty, fifo_full;
    mac_fifo rx_fifo (
        .wr_clk(clk), .full(fifo_full),   .wr_en(fifo_tvalid), .din({fifo_tlast, fifo_tuser, fifo_tdata}),      
        .rd_clk(clk), .empty(fifo_empty), .rd_en(rx_tready),   .dout({ rx_tlast,   rx_tuser,   rx_tdata})
    );
    assign rx_tvalid   = ~fifo_empty;
    assign fifo_tready = ~fifo_full;
    
    int j;
    initial begin
        fifo_tvalid = 0;
        fifo_tdata  = 8'bxxxx_xxxx;
        fifo_tlast  = 0;
        fifo_tuser  = 0; 
        j = 0;       
        #(clk_period*10);
        
        forever begin                                                          
    
            for (int i=0; i<Nregs*4; i++) begin        
                fifo_tvalid = 1;
                fifo_tdata  = j+i+1;
                if (i == (Nregs*4-1)) fifo_tlast = 1; else fifo_tlast = 0;
                #(clk_period*1);
            end
                    
            fifo_tvalid = 0;
            fifo_tdata  = 8'bxxxx_xxxx;
            fifo_tlast = 0;
            #(clk_period*20);
        
            j++;
            
        end
                      
    end

endmodule



/*
*/
