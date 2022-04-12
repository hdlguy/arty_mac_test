//
module totlen_tb ();

    logic           s_tvalid;
    logic           s_tready;
    logic[7:0]      s_tdata=0;
    logic           s_tlast;
    logic           m_tvalid;
    logic           m_tready;
    logic[7:0]      m_tdata;
    logic           m_tlast;
    logic           length_tvalid;
    logic           length_tready;
    logic[15:0]     length_tdata;

    logic  clk = 0; localparam  clk_period = 10; always #( clk_period/2)  clk =  ~clk;

    totlen uut (.*);
    
    assign m_tready = 1;
    assign length_tready = 1;

    int length = 4;
    initial begin    
    
        s_tvalid = 0;
        s_tdata = 0;
        s_tlast = 0;
        #(clk_period*100);        
                
        forever begin
            
            
            for (int i=0; i<length; i++) begin
            
                s_tvalid = 0;
                #(clk_period*3);
        
                s_tvalid = 1;
                s_tdata++;
                if (i==length-1) s_tlast = 1; else s_tlast = 0;
                #(clk_period*1);
                
            end
            
            length++;
            
        end
    end


endmodule
