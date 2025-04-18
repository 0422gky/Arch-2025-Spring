# clk
set_property PACKAGE_PIN E3 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

# reset
set_property PACKAGE_PIN C12 [get_ports {reset}]
set_property IOSTANDARD LVCMOS33 [get_ports {reset}]

# result
set_property PACKAGE_PIN H17 [get_ports {result[0]}]
set_property PACKAGE_PIN K15 [get_ports {result[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[1]}]
