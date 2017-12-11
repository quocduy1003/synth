set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA

set_max_fanout 50 [current_design]
set_max_fanout 50 [get_ports clk]
set_max_fanout 50 [get_ports rst_n]
set_max_fanout 50 [get_ports input_factor_01]
set_max_fanout 50 [get_ports input_factor_02]

set_ideal_network [get_ports rst_n]

create_clock [get_ports clk]  -name clk  -period 100  -waveform {0 50}

set_clock_latency 0.1  [get_clocks clk]
set_clock_uncertainty 0.1  [get_clocks clk]
set_clock_transition -max -rise 0.1 [get_clocks clk]
set_clock_transition -max -fall 0.1 [get_clocks clk]
set_clock_transition -min -rise 0.1 [get_clocks clk]
set_clock_transition -min -fall 0.1 [get_clocks clk]

set_input_delay -clock clk 1 [get_ports clk] 
set_input_delay -clock clk 1 [get_ports rst_n]
set_input_delay -clock clk 1 [get_ports input_factor_01]
set_input_delay -clock clk 1 [get_ports input_factor_02]

set_output_delay -clock clk 1 [get_ports output_multiply]

