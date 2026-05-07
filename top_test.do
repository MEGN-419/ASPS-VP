vlib work
vmap work work
vlog asps_top.v tb_asps_top.v clock_divider.v button_conditioner.v synchronizer.v edge_detector.v d_ff.v car_counter_fsm.v global_timer.v timestamp_buffer.v cost_calculator.v sevenSegments.v
vsim tb_asps_top
add wave -position insertpoint sim:/tb_asps_top/MAX10_CLK1_50
add wave -position insertpoint sim:/tb_asps_top/SW
add wave -position insertpoint sim:/tb_asps_top/KEY
add wave -position insertpoint sim:/tb_asps_top/LEDR
add wave -position insertpoint sim:/tb_asps_top/HEX0
add wave -divider "Internal System Wires"
add wave -radix unsigned -position insertpoint sim:/tb_asps_top/uut/current_time
add wave -radix unsigned -position insertpoint sim:/tb_asps_top/uut/saved_time
add wave -radix unsigned -position insertpoint sim:/tb_asps_top/uut/total_cost

run 3000ns
