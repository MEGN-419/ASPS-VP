`timescale 1ns / 1ps

module tb_timestamp_buffer;

    reg clk;
    reg rstn;
    reg enter_pulse;
    reg exit_pulse;    // <--- ADDED MISSING WIRE
    reg [1:0] car_id;
    reg [15:0] current_time;

    wire [15:0] saved_time;

    timestamp_buffer uut (
        .clk(clk), 
        .rstn(rstn), 
        .enter_pulse(enter_pulse), 
        .exit_pulse(exit_pulse), // <--- WIRED UP
        .car_id(car_id), 
        .current_time(current_time), 
        .saved_time(saved_time)
    );

    // 10N clk
    always #5 clk = ~clk;

    // simulated global timer 
    always @(posedge clk) begin
        if (!rstn) current_time <= 16'd0;
        else current_time <= current_time + 1'b1;
    end

    initial begin
        clk = 0; rstn = 0; enter_pulse = 0; exit_pulse = 0; car_id = 2'b00;

        // Reset
        #20 rstn = 1; 
        #50;

        // Car 1 Enters (System auto-parks in Slot 0)
        enter_pulse = 1; #10; enter_pulse = 0;
        #100;

        // Car 2 Enters (System auto-parks in Slot 1)
        enter_pulse = 1; #10; enter_pulse = 0;
        #50;

        // Manager checks Car 1
        car_id = 2'b00; #40;
        
        // Manager checks Car 2
        car_id = 2'b01; #40;

        // Car 2 Exits (Manager selects Slot 1 and presses exit)
        car_id = 2'b01;
        exit_pulse = 1; #10; exit_pulse = 0;
        #40;

        // Car 3 Enters (System should auto-park in the newly empty Slot 1!)
        enter_pulse = 1; #10; enter_pulse = 0;
        #40;

        $stop;
    end
endmodule