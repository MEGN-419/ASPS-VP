vlib work
vmap work work
vlog up_down_counter.v tb_up_down_counter.v
vsim tb_up_down_counter

add wave -position insertpoint sim:/tb_up_down_counter/clk
add wave -position insertpoint sim:/tb_up_down_counter/rstn
add wave -position insertpoint sim:/tb_up_down_counter/up_pulse
add wave -position insertpoint sim:/tb_up_down_counter/down_pulse
add wave -radix unsigned -position insertpoint sim:/tb_up_down_counter/count
add wave -position insertpoint sim:/tb_up_down_counter/uut/current_state

run 200ns
