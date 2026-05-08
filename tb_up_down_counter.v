`timescale 1ns / 1ps

module tb_up_down_counter;
    reg clk;
    reg rstn;
    reg up_pulse;
    reg down_pulse;

    wire [3:0] count;

    up_down_counter uut (
        .clk(clk),
        .rstn(rstn),
        .up_pulse(up_pulse),
        .down_pulse(down_pulse),
        .count(count)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rstn = 0; up_pulse = 0; down_pulse = 0;
        
        // Reset
        #10 rstn = 1;

        // Test Counting Up
        #20 up_pulse = 1; #10 up_pulse = 0;
        #20 up_pulse = 1; #10 up_pulse = 0;

        // Test Counting Down
        #20 down_pulse = 1; #10 down_pulse = 0;

        #50 $stop;
    end
endmodule
