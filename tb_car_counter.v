`timescale 1ns / 1ps

module tb_car_counter;

    reg clk;
    reg rstn;
    reg enter_pulse;
    reg exit_pulse;

    wire [3:0] ccount;
    wire empty_flag;
    wire full_flag;
    wire alarm;

    //Unit Under Test \/
    car_counter_fsm uut (
        .clk(clk), 
        .rstn(rstn), 
        .enter_pulse(enter_pulse), 
        .exit_pulse(exit_pulse), 
        .ccount(ccount), 
        .empty_flag(empty_flag), 
        .full_flag(full_flag), 
        .alarm(alarm)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rstn = 0;
        enter_pulse = 0;
        exit_pulse = 0;

        // Reset
        #10;
        rstn = 1;
        
        //Test Car exits when empty
        #10 exit_pulse = 1; #10 exit_pulse = 0; 
        
        //enter 3 cars
        #20 enter_pulse = 1; #10 enter_pulse = 0; // Cc= 1
        #20 enter_pulse = 1; #10 enter_pulse = 0; // cc = 2
        #20 enter_pulse = 1; #10 enter_pulse = 0; // cc = 3 (ff->1)

        //Test Car tries to enter when full
        #20 enter_pulse = 1; #10 enter_pulse = 0; 
        
        //Drive 1 car out
        #20 exit_pulse = 1; #10 exit_pulse = 0;   // cc = 2
        
        #50 $stop;
    end

endmodule
