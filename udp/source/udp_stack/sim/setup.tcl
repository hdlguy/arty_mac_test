# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj
set_property part xc7a35ticsg324-1L [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]

read_ip ../mac_fifo/mac_fifo.xci
read_ip ../udp_fifo/udp_fifo.xci
read_ip ../totlen/totlen_data_fifo/totlen_data_fifo.xci
read_ip ../totlen/totlen_length_fifo/totlen_length_fifo.xci
read_ip ../eth_ila/eth_ila.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]


read_verilog -sv ../arp_rx/arp_rx.sv
read_verilog -sv ../arp_tx/arp_tx.sv
read_verilog -sv ../totlen/totlen.sv
read_verilog -sv ../udp_stack.sv
read_verilog -sv ../../udp_frame_gen/udp_frame_gen.sv
read_verilog -sv ../udp_stack_tb.sv

add_files -fileset sim_1 -norecurse ./udp_stack_tb_behav.wcfg

close_project

#########################



