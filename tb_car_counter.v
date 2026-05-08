`timescale 1ns / 1ps

module tb_car_counter;

    reg clk;
    reg rstn;
    reg enter_pulse;
    reg exit_pulse;

    wire empty_flag;
    wire full_flag;
    wire alarm;
    wire valid_enter;
    wire valid_exit;

    //Unit Under Test
    car_counter_fsm uut (
        .clk(clk), 
        .rstn(rstn), 
        .enter_pulse(enter_pulse), 
        .exit_pulse(exit_pulse), 
        .empty_flag(empty_flag), 
        .full_flag(full_flag), 
        .alarm(alarm),
        .valid_enter(valid_enter),  // <--- NEW
        .valid_exit(valid_exit)     // <--- NEW
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rstn = 0; enter_pulse = 0; exit_pulse = 0;

        // Reset
        #10 rstn = 1;
        
        // Test Car exits when empty (Should trigger alarm, NO valid_exit)
        #10 exit_pulse = 1; #10 exit_pulse = 0; 
        
        // Enter 3 cars (Should generate 3 valid_enter pulses)
        #20 enter_pulse = 1; #10 enter_pulse = 0; 
        #20 enter_pulse = 1; #10 enter_pulse = 0; 
        #20 enter_pulse = 1; #10 enter_pulse = 0; 

        // Test Car tries to enter when full (Should trigger alarm, NO valid_enter)
        #20 enter_pulse = 1; #10 enter_pulse = 0; 
        
        // Drive 1 car out (Should generate 1 valid_exit pulse)
        #20 exit_pulse = 1; #10 exit_pulse = 0;   
        
        #50 $stop;
    end

endmodule