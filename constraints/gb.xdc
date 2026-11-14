###################
# TIMING CONTRAINTS
###################

# define system clock and period
create_clock -period 8.000 -name clock125 -waveform {0.000 4.000} [get_ports clock125]

#################
# PIN CONSTRAINTS
#################

# CLK source 125 MHz
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports clock125]

# Reset button - BTNC
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports reset_async]