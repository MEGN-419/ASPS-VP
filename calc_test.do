vlib work
vmap work work
vlog cost_calculator.v tb_cost_calculator.v
vsim tb_cost_calculator
add wave -position insertpoint sim:/tb_cost_calculator/*
radix -unsigned

run 100ns
