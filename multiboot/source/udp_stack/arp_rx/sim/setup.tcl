# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj
set_property part xc7a35ticsg324-1L [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

read_ip ../../mac_fifo/mac_fifo.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

read_verilog -sv ../arp_rx.sv
read_verilog -sv ../arp_rx_tb.sv

add_files -fileset sim_1 -norecurse ./arp_rx_tb_behav.wcfg

close_project

#########################



