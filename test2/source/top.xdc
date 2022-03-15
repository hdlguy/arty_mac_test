
set_property IOSTANDARD LVCMOS33    [get_ports eth_refclk]
set_property SLEW SLOW              [get_ports eth_refclk]
set_property PACKAGE_PIN G18        [get_ports eth_refclk]

set_property IOSTANDARD LVCMOS33    [get_ports led[*]]
set_property PACKAGE_PIN T10        [get_ports led[3]]
set_property PACKAGE_PIN  T9        [get_ports led[2]]
set_property PACKAGE_PIN  J5        [get_ports led[1]]
set_property PACKAGE_PIN  H5        [get_ports led[0]]


set_property IOSTANDARD LVCMOS33    [get_ports led_b[*]]
set_property PACKAGE_PIN  E1        [get_ports led_b[0]]
set_property PACKAGE_PIN  G4        [get_ports led_b[1]]
set_property PACKAGE_PIN  H4        [get_ports led_b[2]]
set_property PACKAGE_PIN  K2        [get_ports led_b[3]]


set_property IOSTANDARD LVCMOS33    [get_ports sw[*]]
set_property PACKAGE_PIN A10        [get_ports sw[3]]
set_property PACKAGE_PIN C10        [get_ports sw[2]]
set_property PACKAGE_PIN C11        [get_ports sw[1]]
set_property PACKAGE_PIN A8         [get_ports sw[0]]

set_property IOSTANDARD LVCMOS33    [get_ports btn[*]]
set_property PACKAGE_PIN B8         [get_ports btn[3]]
set_property PACKAGE_PIN B9         [get_ports btn[2]]
set_property PACKAGE_PIN C9         [get_ports btn[1]]
set_property PACKAGE_PIN D9         [get_ports btn[0]]


##set_property IOSTANDARD LVCMOS33    [get_ports clk_in]
##set_property PACKAGE_PIN   E3       [get_ports clk_in]


##set_property IOSTANDARD LVCMOS33    [get_ports glbl_rstn]
##set_property PACKAGE_PIN   C2       [get_ports glbl_rstn]
##set_false_path -from                [get_ports glbl_rstn]


##set_property IOSTANDARD LVCMOS33    [get_ports phy_resetn]
##set_property PACKAGE_PIN   C16      [get_ports phy_resetn]


##set_property IOSTANDARD LVCMOS33    [get_ports gtx_clk_bufg_out]
##set_property PACKAGE_PIN   G18      [get_ports gtx_clk_bufg_out]


##set_property IOSTANDARD LVCMOS33    [get_ports tx_statistics_s]
##set_property PACKAGE_PIN   G13      [get_ports tx_statistics_s]


##set_property IOSTANDARD LVCMOS33    [get_ports rx_statistics_s]
##set_property PACKAGE_PIN   B11      [get_ports rx_statistics_s]



#################

#set_property IOSTANDARD LVCMOS33  [get_ports clk_in]
#set_property PACKAGE_PIN   E3     [get_ports clk_in]

#set_property IOSTANDARD LVCMOS33  [get_ports glbl_rstn]
#set_property PACKAGE_PIN   C2     [get_ports glbl_rstn]
#set_false_path -from              [get_ports glbl_rstn]

##### Module LEDs_8Bit constraints
#set_property IOSTANDARD  LVCMOS33 [get_ports activity_flash]
#set_property PACKAGE_PIN  H5      [get_ports activity_flash] ;# [get_ports led[0]]

#set_property IOSTANDARD  LVCMOS33 [get_ports frame_error]
#set_property PACKAGE_PIN  J5      [get_ports frame_error] ;#[get_ports led[1]]

##### Module Push_Buttons_4Bit constraints
#set_property IOSTANDARD  LVCMOS33 [get_ports update_speed]
#set_property PACKAGE_PIN D9       [get_ports update_speed] ;#[get_ports btn[0]]

#set_property IOSTANDARD  LVCMOS33 [get_ports config_board]
#set_property PACKAGE_PIN C9       [get_ports config_board] ;#[get_ports btn[1]]

#set_property IOSTANDARD  LVCMOS33 [get_ports pause_req_s]
#set_property PACKAGE_PIN B9       [get_ports pause_req_s] ;#[get_ports btn[2]]

#set_property IOSTANDARD  LVCMOS33 [get_ports reset_error]
#set_property PACKAGE_PIN B8       [get_ports reset_error] ;#[get_ports btn[3]]

##### Module DIP_Switches_4Bit constraints
#set_property IOSTANDARD  LVCMOS33 [get_ports mac_speed[*]]
#set_property PACKAGE_PIN C11      [get_ports mac_speed[1]] ;#[get_ports sw[1]]
#set_property PACKAGE_PIN A8       [get_ports mac_speed[0]] ;#[get_ports sw[0]]


#set_property IOSTANDARD  LVCMOS33 [get_ports gen_tx_data]
#set_property PACKAGE_PIN C10      [get_ports gen_tx_data] ;#[get_ports sw[2]]

#set_property IOSTANDARD  LVCMOS33 [get_ports chk_tx_data]
#set_property PACKAGE_PIN A10      [get_ports chk_tx_data] ;#[get_ports sw[3]]

#set_property IOSTANDARD  LVCMOS33 [get_ports phy_resetn]
#set_property PACKAGE_PIN   C16    [get_ports phy_resetn]

#set_property IOSTANDARD  LVCMOS33 [get_ports serial_response]
#set_property PACKAGE_PIN  T9      [get_ports serial_response] ;#[get_ports led[2]]

#set_property IOSTANDARD LVCMOS33  [get_ports tx_statistics_s]
#set_property PACKAGE_PIN   G13    [get_ports tx_statistics_s]

#set_property IOSTANDARD LVCMOS33  [get_ports rx_statistics_s]
#set_property PACKAGE_PIN   B11    [get_ports rx_statistics_s]

##set_property IOSTANDARD  LVCMOS33 [get_ports mdc]
##set_property IOSTANDARD  LVCMOS33 [get_ports mdio]

##set_property IOSTANDARD  LVCMOS33 [get_ports mii_rxd[3]]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_rxd[2]]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_rxd[1]]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_rxd[0]]

##set_property IOSTANDARD  LVCMOS33 [get_ports mii_txd[3]]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_txd[2]]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_txd[1]]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_txd[0]]


##set_property IOSTANDARD  LVCMOS33 [get_ports mii_tx_en]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_tx_er]

##set_property IOSTANDARD  LVCMOS33 [get_ports mii_rx_dv]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_rx_er]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_rx_clk]
##set_property IOSTANDARD  LVCMOS33 [get_ports mii_tx_clk]

## TB clock pin gtx_clk_bufg_out 
#set_property IOSTANDARD LVCMOS33  [get_ports gtx_clk_bufg_out]
#set_property PACKAGE_PIN   G18    [get_ports gtx_clk_bufg_out]


#create_clock -name clk_in -period 10.000 [get_ports clk_in]
#set_input_jitter clk_in 0.050

##create_clock -name clk_in_p -period 5.000 [get_ports clk_in_p]
##set_input_jitter clk_in_p 0.050

##set axi_clk_name [get_clocks -of [get_pins example_clocks/clock_generator/mmcm_adv_inst/CLKOUT1]]
#set axi_clk_name [get_clocks example_clocks/clock_generator/inst/clk_in1]
#set axi_clk_name [get_clocks example_clocks/clock_generator/inst/clk_in1]
#set axi_clk_name [get_clocks clk_out2_mac_clk_wiz]

#############################################################
## Input Delay constraints
#############################################################
## these inputs are alll from either dip switchs or push buttons
## and therefore have no timing associated with them
#set_false_path -from [get_ports config_board]
#set_false_path -from [get_ports pause_req_s]
#set_false_path -from [get_ports reset_error]
#set_false_path -from [get_ports mac_speed[0]]
#set_false_path -from [get_ports mac_speed[1]]
#set_false_path -from [get_ports gen_tx_data]
#set_false_path -from [get_ports chk_tx_data]

## no timing requirements but want the capture flops close to the IO
#set_max_delay -from [get_ports update_speed] 4 -datapath_only


## Ignore pause deserialiser as only present to prevent logic stripping
#set_false_path -from [get_ports pause_req*]
#set_false_path -from [get_cells pause_req* -filter {IS_SEQUENTIAL}]
#set_false_path -from [get_cells pause_val* -filter {IS_SEQUENTIAL}]


#############################################################
## Output Delay constraints
#############################################################

#set_false_path -to [get_ports frame_error]
##set_false_path -to [get_ports frame_errorn]
#set_false_path -to [get_ports serial_response]
#set_false_path -to [get_ports tx_statistics_s]
#set_false_path -to [get_ports rx_statistics_s]
#set_output_delay -clock $axi_clk_name 1 [get_ports mdc]

## no timing associated with output
#set_false_path -from [get_cells -hier -filter {name =~ *phy_resetn_int_reg}] -to [get_ports phy_resetn]

#############################################################
## Example design Clock Crossing Constraints                          #
#############################################################
#set_false_path -from [get_cells -hier -filter {name =~ *phy_resetn_int_reg}] -to [get_cells -hier -filter {name =~ *axi_lite_reset_gen/reset_sync*}]


## control signal is synched over clock boundary separately
#set_false_path -from [get_cells -hier -filter {name =~ tx_stats_reg[*]}] -to [get_cells -hier -filter {name =~ tx_stats_shift_reg[*]}]
#set_false_path -from [get_cells -hier -filter {name =~ rx_stats_reg[*]}] -to [get_cells -hier -filter {name =~ rx_stats_shift_reg[*]}]



#############################################################
## Ignore paths to resync flops
#############################################################
#set_false_path -to [get_pins -filter {REF_PIN_NAME =~ PRE} -of [get_cells -hier -regexp {.*\/reset_sync.*}]]
#set_false_path -to [get_pins -filter {REF_PIN_NAME =~ D} -of [get_cells -regexp {.*\/.*_sync.*}]]
#set_max_delay -from [get_cells tx_stats_toggle_reg] -to [get_cells tx_stats_sync/data_sync_reg0] 6 -datapath_only
#set_max_delay -from [get_cells rx_stats_toggle_reg] -to [get_cells rx_stats_sync/data_sync_reg0] 6 -datapath_only



##
#####
########
###########
##############
##################
##FIFO BLOCK CONSTRAINTS

#############################################################
## FIFO Clock Crossing Constraints                          #
#############################################################

## control signal is synched separately so this is a false path
#set_max_delay -from [get_cells -hier -filter {name =~ *rx_fifo_i/rd_addr_reg[*]}]                         -to [get_cells -hier -filter {name =~ *fifo*wr_rd_addr_reg[*]}] 3.2 -datapath_only
#set_max_delay -from [get_cells -hier -filter {name =~ *rx_fifo_i/wr_store_frame_tog_reg}]                 -to [get_cells -hier -filter {name =~ *fifo_i/resync_wr_store_frame_tog/data_sync_reg0}] 3.2 -datapath_only
#set_max_delay -from [get_cells -hier -filter {name =~ *rx_fifo_i/update_addr_tog_reg}]                    -to [get_cells -hier -filter {name =~ *rx_fifo_i/sync_rd_addr_tog/data_sync_reg0}] 3.2 -datapath_only
#set_max_delay -from [get_cells -hier -filter {name =~ *tx_fifo_i/rd_addr_txfer_reg[*]}]                   -to [get_cells -hier -filter {name =~ *fifo*wr_rd_addr_reg[*]}] 3.2 -datapath_only
#set_max_delay -from [get_cells -hier -filter {name =~ *tx_fifo_i/wr_frame_in_fifo_reg}]                   -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_wr_frame_in_fifo/data_sync_reg0}] 3.2 -datapath_only
#set_max_delay -from [get_cells -hier -filter {name =~ *tx_fifo_i/wr_frames_in_fifo_reg}]                  -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_wr_frames_in_fifo/data_sync_reg0}] 3.2 -datapath_only
#set_max_delay -from [get_cells -hier -filter {name =~ *tx_fifo_i/frame_in_fifo_valid_tog_reg}]            -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_fif_valid_tog/data_sync_reg0}] 3.2 -datapath_only
#set_max_delay -from [get_cells -hier -filter {name =~ *tx_fifo_i/rd_txfer_tog_reg}]                       -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_rd_txfer_tog/data_sync_reg0}] 3.2 -datapath_only
#set_max_delay -from [get_cells -hier -filter {name =~ *tx_fifo_i/rd_tran_frame_tog_reg}]                  -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_rd_tran_frame_tog/data_sync_reg0}] 3.2 -datapath_only

#set_power_opt -exclude_cells [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ *.bram.* }]

######################################
#### CDC Waivers
######################################
#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "This data-bus is part of the DMUX synchronizer, which is essentially a false paths and can be ignored." -from [get_pins {*x_stats_reg[*]/C}] -to [get_pins {*x_stats_shift_reg[*]/D}]

#create_waiver -quiet -type CDC -id {CDC-10} -user "tri_mode_ethernet_mac" -tags "11999" -desc "The CDC-10 warning is waived because it is safe to ignore" -from [get_pins {*x_stats_reg[*]/C}] -to [get_pins {*x_stats_shift_reg[*]/D}]

#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Can be safely ignored. These Control signals are inputs from board DIP switches and are expected to be static during MAC operations and thus a false path for all practical purposes." -from [get_ports gen_tx_data]

#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Can be safely ignored. These Control signals are inputs from board DIP switches and are expected to be static during MAC operations and thus a false path for all practical purposes." -from [get_ports pause_req_*]

#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Can be safely ignored. These Control signals are inputs from board DIP switches and are expected to be static during MAC operations and thus a false path for all practical purposes." -from [get_ports config_board] -to [list [get_pins enable_address_swap_reg/CE] [get_pins enable_phy_loopback_reg/CE] ] 
#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "This data-bus is part of the DMUX synchronizer, which is essentially a false paths and can be ignored." -from [get_pins pause_req_reg/C]
#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Control register o/p expected to be static during MAC operations and thus a false path for all practical purposes and thus can be ignored." -from [get_pins {config_vector_controller/tx_speed_reg[1]/C}] -to [list [get_pins -of [get_cells -hier -filter {name =~ */gmii_mii_rx_gen/alignment_err_reg_reg*}] -filter {name =~ *D}] [get_pins -of [get_cells -hier -filter {name =~ */gmii_mii_rx_gen/rx_dv_reg3_reg*}] -filter {name =~ *D}] ]
#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Can be safely ignored. These Control signals are inputs from board DIP switches and are expected to be static during MAC operations and thus a false path for all practical purposes." -from [get_ports {mac_speed[*]}] -to [list [get_pins {axi_lite_controller/speed_reg[*]/D}] [get_pins  -of [get_cells -hier -filter {name =~ */axi_pat_gen_inst/add_credit_reg*}] -filter {name =~ *D}] [get_pins {config_vector_controller/tx_speed_reg[*]/D}] ]
#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Can be safely ignored. These Control signals are inputs from board DIP switches and are expected to be static during MAC operations and thus a false path for all practical purposes." -from [get_ports chk_tx_data]

#create_waiver -quiet -type CDC -id {CDC-11} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Part of reset synchronizer. Safe to ignore" -from [get_pins example_resets/phy_resetn_int_reg/C] -to [get_pins example_resets/axi_lite_reset_gen/reset_sync*/CE]
#create_waiver -quiet -type CDC -id {CDC-1} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Part of reset synchronizer. Safe to ignore" -from [get_pins example_resets/phy_resetn_int_reg/C] -to [get_pins example_resets/axi_lite_reset_gen/reset_sync*/CE]
#create_waiver -quiet -type CDC -id {CDC-10} -user "tri_mode_ethernet_mac" -tags "11999" -desc "Part of reset synchronizer. Safe to ignore" -from [get_pins example_resets/glbl_reset_gen/reset_sync4/C] -to [get_pins -of [get_cells -hier -filter {name =~ */idelayctrl_reset_gen/reset_sync0*}] -filter {name =~ *PRE}]



