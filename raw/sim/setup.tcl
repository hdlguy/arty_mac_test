# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property part xc7a35ticsg324-1L [current_project]
set_property target_language verilog [current_project]
set_property default_lib work [current_project]

#read_ip ../source/temac_core/temac_core.xci
#read_ip ../source/mac_fifo/mac_fifo.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

read_verilog -sv ../source/lfsr.v  
read_verilog -sv ../source/axis_gmii_rx.v  
read_verilog -sv ../source/axis_gmii_tx.v  
read_verilog -sv ../source/ssio_sdr_in.v
read_verilog -sv ../source/eth_mac_1g.v  
read_verilog -sv ../source/mii_phy_if.v
read_verilog -sv ../source/eth_mac_mii.v  
read_verilog -sv ../source/mac_tb.sv  

#read_verilog -sv ../source/frame_gen/frame_gen.sv
#read_verilog -sv ../source/frame_rx/frame_rx.sv


close_project


