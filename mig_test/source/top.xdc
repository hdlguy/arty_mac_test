#
set_max_delay 10 -datapath_only -from [all_ffs] -to [get_ports ddr3_sdram_reset_n]

set_property IOSTANDARD LVCMOS33    [get_ports clkin100]
set_property PACKAGE_PIN   E3       [get_ports clkin100]

#set_property IOSTANDARD LVCMOS33    [get_ports led[*]]
#set_property PACKAGE_PIN T10        [get_ports led[3]]
#set_property PACKAGE_PIN  T9        [get_ports led[2]]
#set_property PACKAGE_PIN  J5        [get_ports led[1]]
#set_property PACKAGE_PIN  H5        [get_ports led[0]]

#set_property IOSTANDARD LVCMOS33    [get_ports led_b[*]]
#set_property PACKAGE_PIN  E1        [get_ports led_b[0]]
#set_property PACKAGE_PIN  G4        [get_ports led_b[1]]
#set_property PACKAGE_PIN  H4        [get_ports led_b[2]]
#set_property PACKAGE_PIN  K2        [get_ports led_b[3]]

#set_property IOSTANDARD LVCMOS33    [get_ports sw[*]]
#set_property PACKAGE_PIN A10        [get_ports sw[3]]
#set_property PACKAGE_PIN C10        [get_ports sw[2]]
#set_property PACKAGE_PIN C11        [get_ports sw[1]]
#set_property PACKAGE_PIN A8         [get_ports sw[0]]

#set_property IOSTANDARD LVCMOS33    [get_ports btn[*]]
#set_property PACKAGE_PIN B8         [get_ports btn[3]]
#set_property PACKAGE_PIN B9         [get_ports btn[2]]
#set_property PACKAGE_PIN C9         [get_ports btn[1]]
#set_property PACKAGE_PIN D9         [get_ports btn[0]]

#set_property IOSTANDARD LVCMOS33    [get_ports resetn]
#set_property PACKAGE_PIN   C2       [get_ports resetn]
#set_false_path -from                [get_ports resetn]

#set_property IOSTANDARD LVCMOS33    [get_ports eth_refclk]
#set_property SLEW SLOW              [get_ports eth_refclk]
#set_property PACKAGE_PIN G18        [get_ports eth_refclk]
#set_property IOSTANDARD LVCMOS33    [get_ports eth_mii_rst_n]
#set_property SLEW SLOW              [get_ports eth_mii_rst_n]
#set_property PACKAGE_PIN C16        [get_ports eth_mii_rst_n]
##set_property IOSTANDARD  LVCMOS33   [get_ports eth_mdc]
##set_property PACKAGE_PIN F16        [get_ports eth_mdc]
##set_property IOSTANDARD  LVCMOS33   [get_ports eth_mdio]
##set_property PACKAGE_PIN K13        [get_ports eth_mdio]

#set_property IOSTANDARD  LVCMOS33   [get_ports eth_mii_rxd[*]]
#set_property PACKAGE_PIN G17        [get_ports eth_mii_rxd[3]]
#set_property PACKAGE_PIN E18        [get_ports eth_mii_rxd[2]]
#set_property PACKAGE_PIN E17        [get_ports eth_mii_rxd[1]]
#set_property PACKAGE_PIN D18        [get_ports eth_mii_rxd[0]]

#set_property IOSTANDARD  LVCMOS33   [get_ports eth_mii_txd[*]]
#set_property PACKAGE_PIN H17        [get_ports eth_mii_txd[3]]
#set_property PACKAGE_PIN J13        [get_ports eth_mii_txd[2]]
#set_property PACKAGE_PIN J14        [get_ports eth_mii_txd[1]]
#set_property PACKAGE_PIN H14        [get_ports eth_mii_txd[0]]

#set_property IOSTANDARD  LVCMOS33   [get_ports eth_mii_tx_en]
#set_property PACKAGE_PIN H15        [get_ports eth_mii_tx_en]

#set_property IOSTANDARD  LVCMOS33   [get_ports eth_mii_rx_dv]
#set_property PACKAGE_PIN G16        [get_ports eth_mii_rx_dv]
#set_property IOSTANDARD  LVCMOS33   [get_ports eth_mii_rx_er]
#set_property PACKAGE_PIN C17        [get_ports eth_mii_rx_er]
#set_property IOSTANDARD  LVCMOS33   [get_ports eth_mii_rx_clk]
#set_property PACKAGE_PIN F15        [get_ports eth_mii_rx_clk]
#set_property IOSTANDARD  LVCMOS33   [get_ports eth_mii_tx_clk]
#set_property PACKAGE_PIN H16        [get_ports eth_mii_tx_clk]


