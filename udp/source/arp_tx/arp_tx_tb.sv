module arp_tx_tb ();

    logic       tx_fifo_tvalid;
    logic       tx_fifo_tready; 
    logic[7:0]  tx_fifo_tdata;
    logic       tx_fifo_tlast; 
    logic       tx_fifo_tuser; 
    logic       dv_in;
    logic[47:0] remote_mac;
    logic[31:0] remote_ip;

    localparam logic[47:0] local_mac = 48'h00_0a_35_01_02_03;
    localparam logic[31:0] local_ip  = 32'h10_00_00_80;

    assign remote_mac = 48'h94_10_3e_b7_e2_01;
    assign remote_ip  = 32'h10_00_00_c8;

    logic  clk = 0; localparam  clk_period = 10; always #( clk_period/2)  clk =  ~clk;

    arp_tx #(.local_mac(local_mac), .local_ip(local_ip)) uut (.*);            
    
    initial begin
            
        tx_fifo_tready = 0;
        dv_in = 0;
        #(clk_period*10);
        
        dv_in = 1;
        #(clk_period*1);
                
        dv_in = 0;
        #(clk_period*10);
    
        forever begin
            tx_fifo_tready = ~tx_fifo_tready;
            #(clk_period*1);
        end
        
    end

endmodule


