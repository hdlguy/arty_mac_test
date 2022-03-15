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

#read_ip ../source/temac_core/temac_core.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

source ../source/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]

read_verilog -sv    ../source/axi_regfile/axi_regfile_v1_0_S00_AXI.sv
read_verilog -sv ../source/top.sv

read_xdc ../source/top.xdc  

close_project


