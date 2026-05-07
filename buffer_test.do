vlib work
vmap work work
vlog timestamp_buffer.v tb_timestamp_buffer.v
vsim tb_timestamp_buffer
add wave -position insertpoint sim:/tb_timestamp_buffer/*
add wave -position insertpoint sim:/tb_timestamp_buffer/uut/memory_array
run 400ns
