module frame_rx_tb ();

    localparam int Nregs = 16;

    logic       rx_fifo_tvalid,     fifo_tvalid;
    logic       rx_fifo_tready,     fifo_tready; 
    logic[7:0]  rx_fifo_tdata,      fifo_tdata;
    logic       rx_fifo_tlast,      fifo_tlast; 
    logic       rx_fifo_tuser,      fifo_tuser; 
    logic       dv_out;
    logic[Nregs-1:0][31:0] wr_val;

    logic  clk = 0; localparam  clk_period = 10; always #( clk_period/2)  clk =  ~clk;

    frame_rx #(.Nregs(Nregs)) uut (.*);        
    
    logic  aclk = 0; localparam  aclk_period = 40; always #( aclk_period/2)  aclk =  ~aclk;
    
    logic fifo_empty, fifo_full;
    mac_fifo rx_fifo (
        .wr_clk(aclk), .full(fifo_full), .wr_en(fifo_tvalid), .din({fifo_tlast, fifo_tuser, fifo_tdata}),      
        .rd_clk(clk), .empty(fifo_empty), .rd_en(rx_fifo_tready),  .dout({rx_fifo_tlast, rx_fifo_tuser, rx_fifo_tdata})
    );
    assign rx_fifo_tvalid = ~fifo_empty;
    assign fifo_tready    = ~fifo_full;
    
    int j;
    initial begin
        fifo_tvalid = 0;
        fifo_tdata  = 8'bxxxx_xxxx;
        fifo_tlast  = 0;
        fifo_tuser  = 0; 
        j = 0;       
        #(aclk_period*10);
        
        forever begin

            // ethernet header, 6 byte destination + 6 byte source + 2 byte type = 14 bytes
            for (int i=0; i<14; i++) begin        
                fifo_tvalid = 1;
                fifo_tdata  = 0;
                fifo_tlast = 0;
                #(aclk_period*1);
            end

            // add 6 byte GFAS header                  
            fifo_tvalid = 1;
            fifo_tdata  = 8'hfa;
            fifo_tlast = 0;
            #(aclk_period*1);
            
            fifo_tvalid = 1;
            fifo_tdata  = 8'hf3;
            fifo_tlast = 0;
            #(aclk_period*1);
            
            fifo_tvalid = 1;
            fifo_tdata  = 8'hde;
            fifo_tlast = 0;
            #(aclk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'had;
            fifo_tlast = 0;
            #(aclk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'hbe;
            fifo_tlast = 0;
            #(aclk_period*1);
                        
            fifo_tvalid = 1;
            fifo_tdata  = 8'hef;
            fifo_tlast = 0;
            #(aclk_period*1);                                                               
    
            for (int i=0; i<Nregs*4; i++) begin        
                fifo_tvalid = 1;
                fifo_tdata  = j+i+1;
                if (i == (Nregs*4-1)) fifo_tlast = 1; else fifo_tlast = 0;
                #(aclk_period*1);
            end
                    
            fifo_tvalid = 0;
            fifo_tdata  = 8'bxxxx_xxxx;
            fifo_tlast = 0;
            #(aclk_period*20);
        
            j++;
            
        end
                      
    end

endmodule



/*

module frame_rx #(
    parameter int Nregs = 16
)(
    input   logic       clk,
    // axi-stream interface from rx fifo.
    input   logic       rx_fifo_tvalid,
    input   logic       rx_fifo_tready, 
    input   logic[7:0]  rx_fifo_tdata,
    input   logic       rx_fifo_tlast, 
    input   logic       rx_fifo_tuser, 
    // register interface
    output  logic[Nregs-1:0][31:0] wr_val  // register file
);

*/
