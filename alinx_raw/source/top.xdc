create_clock -period 5.000 -name clkin200_p   -waveform {0.00 2.50}  [get_ports clkin200_p]
create_clock -period 8.000 -name rgmii_rxc -waveform {0.00 4.00}  [get_ports rgmii_rxc]

set_property IOSTANDARD DIFF_HSTL_I_12  [get_ports {clkin200_*}]
set_property ODT RTT_NONE               [get_ports {clkin200_*}]
set_property PACKAGE_PIN AE5            [get_ports clkin200_p]
set_property PACKAGE_PIN AF5            [get_ports clkin200_n]

set_property IOSTANDARD LVCMOS33    [get_ports alinx_led]
set_property PACKAGE_PIN AE12       [get_ports alinx_led]

set_property IOSTANDARD LVCMOS18    [get_ports rgmii_*]
set_property PACKAGE_PIN A7         [get_ports rgmii_txc]
set_property PACKAGE_PIN A8         [get_ports rgmii_txd[3]]
set_property PACKAGE_PIN A9         [get_ports rgmii_txd[2]]
set_property PACKAGE_PIN D9         [get_ports rgmii_txd[1]]
set_property PACKAGE_PIN E9         [get_ports rgmii_txd[0]]
set_property PACKAGE_PIN B9         [get_ports rgmii_tx_ctl]

set_property PACKAGE_PIN E5         [get_ports rgmii_rxc]
set_property PACKAGE_PIN C9         [get_ports rgmii_rxd[3]]
set_property PACKAGE_PIN F8         [get_ports rgmii_rxd[2]]
set_property PACKAGE_PIN B5         [get_ports rgmii_rxd[1]]
set_property PACKAGE_PIN A5         [get_ports rgmii_rxd[0]]
set_property PACKAGE_PIN B8         [get_ports rgmii_rx_ctl]

set_property PACKAGE_PIN D5         [get_ports rgmii_reset_n]

set_property IOB TRUE               [get_ports rgmii_rxd[*]]
set_property IOB TRUE               [get_ports rgmii_rx_ctl]

#set_property IOB TRUE               [get_ports rgmii_txd[*]]
#set_property IOB TRUE               [get_ports rgmii_tx_ctl]
#set_property IOB TRUE               [get_ports rgmii_txc]


#set_input_delay -clock [get_clocks {eth_mii_rxc}] -clock_fall    -min -add_delay 3.0 [get_ports {eth_mii_rxd[*]}]
#set_input_delay -clock [get_clocks {eth_mii_rxc}] -clock_fall    -max -add_delay 3.9 [get_ports {eth_mii_rxd[*]}]
#set_input_delay -clock [get_clocks {eth_mii_rxc}]                -min -add_delay 3.0 [get_ports {eth_mii_rxd[*]}]
#set_input_delay -clock [get_clocks {eth_mii_rxc}]                -max -add_delay 3.9 [get_ports {eth_mii_rxd[*]}]

#set_input_delay -clock [get_clocks {eth_mii_rxc}] -clock_fall    -min -add_delay 3.0 [get_ports {eth_mii_rx_ctl}]
#set_input_delay -clock [get_clocks {eth_mii_rxc}] -clock_fall    -max -add_delay 3.9 [get_ports {eth_mii_rx_ctl}]
#set_input_delay -clock [get_clocks {eth_mii_rxc}]                -min -add_delay 3.0 [get_ports {eth_mii_rx_ctl}]
#set_input_delay -clock [get_clocks {eth_mii_rxc}]                -max -add_delay 3.9 [get_ports {eth_mii_rx_ctl}]

#set_max_delay -to [get_ports {rgmii_txd[*]}]    16.666
#set_min_delay -to [get_ports {rgmii_txd[*]}]    0.0
#set_max_delay -to [get_ports {rgmii_rst_n}]     16.666
#set_min_delay -to [get_ports {rgmii_rst_n}]     0.0
#set_max_delay -to [get_ports {rgmii_txc}]    16.666
#set_min_delay -to [get_ports {rgmii_txc}]    0.0
#set_max_delay -to [get_ports {rgmii_tx_ctl}]    16.666
#set_min_delay -to [get_ports {rgmii_tx_ctl}]    0.0

set_property IOSTANDARD LVCMOS33    [get_ports {usb_uart_*}]
set_property PACKAGE_PIN AH12       [get_ports {usb_uart_rxd}]
set_property PACKAGE_PIN AH11       [get_ports {usb_uart_txd}]

set_property IOSTANDARD LVCMOS33    [get_ports {scl}]
set_property PULLUP TRUE            [get_ports {scl}]
set_property PACKAGE_PIN B10        [get_ports {scl}]
set_property IOSTANDARD LVCMOS33    [get_ports {sda}]
set_property PULLUP TRUE            [get_ports {sda}]
set_property PACKAGE_PIN C11        [get_ports {sda}]


