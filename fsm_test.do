vlib work
vmap work work
vlog car_counter_fsm.v tb_car_counter.v
vsim tb_car_counter
add wave -position insertpoint sim:/tb_car_counter/*
run 300ns
