# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property board_part digilentinc.com:arty-a7-100:part0:1.1 [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

read_ip ../source/clk_wiz/clk_wiz.xci
read_ip ../source/data_ila/data_ila.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

source ../source/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]

read_verilog -sv ../source/top.sv
read_verilog -sv ../source/top_tb.sv


close_project

#########################



