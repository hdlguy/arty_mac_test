# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj
set_property part xc7a35ticsg324-1L [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

#read_ip ../frame_gen_fifo/frame_gen_fifo.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

read_verilog -sv ../frame_gen.sv
read_verilog -sv ../frame_gen_tb.sv

add_files -fileset sim_1 -norecurse ./frame_gen_tb_behav.wcfg

close_project

#########################



