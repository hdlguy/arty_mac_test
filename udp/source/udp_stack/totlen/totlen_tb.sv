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
    
    logic[3:0] state=0, next_state;
    always_comb begin
    
        next_state = state;
        length_tready = 0;
        m_tready = 0;
        
        case (state)
            0: begin
                next_state = 1;
            end
            
            1: begin
                if (length_tvalid) begin
                    next_state = 2;
                end
            end
            
            2: begin
                next_state = 3;
                length_tready = 1;
            end
            
            3: begin
                if ((m_tvalid==1) && (m_tlast==1)) begin
                    next_state = 4; 
                end
                m_tready = 1;
            end
                
            4: begin
                next_state = 0;
            end
            
            default: begin
                next_state = 0;    
            end
            
        endcase
    end
    
    always_ff @(posedge clk) state <= next_state;


endmodule
