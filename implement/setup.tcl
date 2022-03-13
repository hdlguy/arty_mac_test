# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
#set_property part xc7a35ticsg324-1L [current_project]
set_property board_part digilentinc.com:arty-a7-35:part0:1.0 [current_project]
set_property target_language verilog [current_project]
set_property default_lib work [current_project]
#load_features ipintegrator
#tclapp::install ultrafast -quiet

read_ip ../source/mac_clk_wiz/mac_clk_wiz.xci
read_ip ../source/tri_mode_ethernet_mac_0/tri_mode_ethernet_mac_0.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

read_verilog -sv ../source/tri_mode_ethernet_mac_0_axi_pat_gen.v            
read_verilog -sv ../source/tri_mode_ethernet_mac_0_example_design.v    
read_verilog -sv ../source/tri_mode_ethernet_mac_0_sync_block.v
read_verilog -sv ../source/tri_mode_ethernet_mac_0_axi_pipe.v               
read_verilog -sv ../source/tri_mode_ethernet_mac_0_syncer_level.v

read_verilog -sv ../source/tri_mode_ethernet_mac_0_basic_pat_gen.v          
read_verilog -sv ../source/tri_mode_ethernet_mac_0_fifo_block.v        
read_verilog -sv ../source/tri_mode_ethernet_mac_0_ten_100_1g_eth_fifo.v

read_verilog -sv ../source/tri_mode_ethernet_mac_0_address_swap.v   
read_verilog -sv ../source/tri_mode_ethernet_mac_0_bram_tdp.v               
read_verilog -sv ../source/tri_mode_ethernet_mac_0_frame_typ.v         
read_verilog -sv ../source/tri_mode_ethernet_mac_0_tx_client_fifo.v

read_verilog -sv ../source/tri_mode_ethernet_mac_0_axi_lite_sm.v    
read_verilog -sv ../source/tri_mode_ethernet_mac_0_clk_wiz.v                
read_verilog -sv ../source/tri_mode_ethernet_mac_0_reset_sync.v        

read_verilog -sv ../source/tri_mode_ethernet_mac_0_axi_mux.v        
read_verilog -sv ../source/tri_mode_ethernet_mac_0_example_design_clocks.v  
read_verilog -sv ../source/tri_mode_ethernet_mac_0_rx_client_fifo.v

read_verilog -sv ../source/tri_mode_ethernet_mac_0_axi_pat_check.v  
read_verilog -sv ../source/tri_mode_ethernet_mac_0_example_design_resets.v  
read_verilog -sv ../source/tri_mode_ethernet_mac_0_support.v

read_xdc ../source/tri_mode_ethernet_mac_0_example_design.xdc  
read_xdc ../source/tri_mode_ethernet_mac_0_user_phytiming.xdc

close_project


