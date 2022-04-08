# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property part xc7a35ticsg324-1L [current_project]
#set_property board_part digilentinc.com:arty-a7-35:part0:1.0 [current_project]
set_property target_language verilog [current_project]
set_property default_lib work [current_project]

read_ip ../source/temac_core/temac_core.xci
read_ip ../source/clk_wiz/clk_wiz.xci
read_ip ../source/mac_fifo/mac_fifo.xci
read_ip ../source/eth_ila/eth_ila.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]


read_verilog -sv ../source/arp_rx/arp_rx.sv
read_verilog -sv ../source/arp_tx/arp_tx.sv

read_verilog -sv ../source/top.sv

read_xdc ../source/top.xdc  

close_project


