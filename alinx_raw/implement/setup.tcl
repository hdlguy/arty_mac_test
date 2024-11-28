# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -part xczu2cg-sfvc784-1-e -force proj
#create_project -force proj 
#set_property part xc7a35ticsg324-1L [current_project]
#set_property board_part digilentinc.com:arty-a7-35:part0:1.0 [current_project]
set_property target_language verilog [current_project]
set_property default_lib work [current_project]

read_ip ../source/temac_core/temac_core.xci
read_ip ../source/clk_wiz/clk_wiz.xci
read_ip ../source/mac_fifo/mac_fifo.xci
read_ip ../source/eth_ila/eth_ila.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

read_verilog -sv ../../alex_forencich/lfsr.v  
read_verilog -sv ../../alex_forencich/axis_gmii_rx.v  
read_verilog -sv ../../alex_forencich/axis_gmii_tx.v  
read_verilog -sv ../../alex_forencich/ssio_sdr_in.v
read_verilog -sv ../../alex_forencich/eth_mac_1g.v  
read_verilog -sv ../../alex_forencich/mii_phy_if.v
read_verilog -sv ../../alex_forencich/eth_mac_mii.v  

read_verilog -sv ../source/frame_gen/frame_gen.sv
read_verilog -sv ../source/frame_rx/frame_rx.sv

read_verilog -sv ../source/top.sv

read_xdc ../source/top.xdc  

set_property top top [current_fileset]

close_project


