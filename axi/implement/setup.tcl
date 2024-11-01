# This script sets up a Vivado project with all ip references resolved.
# In Linux:
#   vivado -mode batch -source setup.tcl
# In windows use xtcl shell
#   source setup.tcl
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force -part xc7a100ticsg324-1L proj
set_property target_language verilog [current_project]
set_property default_lib work [current_project]

#read_ip ../source/udp_stack/totlen/totlen_data_fifo/totlen_data_fifo.xci
#read_ip ../source/udp_stack/totlen/totlen_length_fifo/totlen_length_fifo.xci
#read_ip ../source/clk_wiz/clk_wiz.xci
#read_ip ../source/udp_stack/mac_fifo/mac_fifo.xci
#read_ip ../source/udp_stack/udp_fifo/udp_fifo.xci
#read_ip ../source/udp_stack/eth_ila/eth_ila.xci
read_ip ../source/ila_top/ila_top.xci
read_ip ../source/test_bram/test_bram.xci
reset_target all [get_files *.xci]
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

# Recreate the Block Diagram of the processor system.
source ../source/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]


#read_verilog -sv ../../alex_forencich/lfsr.v  
#read_verilog -sv ../../alex_forencich/axis_gmii_rx.v  
#read_verilog -sv ../../alex_forencich/axis_gmii_tx.v  
#read_verilog -sv ../../alex_forencich/ssio_sdr_in.v
#read_verilog -sv ../../alex_forencich/eth_mac_1g.v  
#read_verilog -sv ../../alex_forencich/mii_phy_if.v
#read_verilog -sv ../../alex_forencich/eth_mac_mii.v  

#read_verilog -sv ../source/udp_frame_rx/udp_frame_rx.sv
#read_verilog -sv ../source/udp_frame_gen/udp_frame_gen.sv
#read_verilog -sv ../source/udp_stack/udp_stack.sv
#read_verilog -sv ../source/udp_stack/totlen/totlen.sv
#read_verilog -sv ../source/temac.sv
#read_verilog -sv ../source/udp_stack/arp_rx/arp_rx.sv
#read_verilog -sv ../source/udp_stack/arp_tx/arp_tx.sv

read_verilog -sv ../source/axi_master/axi4_master_master_full_v1_0_M00_AXI.v  
read_verilog -sv ../source/axi_master/axi4_master.v

read_verilog -sv ../source/top.sv

read_xdc ../source/top.xdc  

close_project


