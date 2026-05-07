`timescale 1ns / 1ps

module tb_cost_calculator;

    reg [15:0] current_time;
    reg [15:0] entry_time;
    reg [3:0] cost_rate;

    wire [15:0] total_cost;

    cost_calculator uut (
        .current_time(current_time), 
        .entry_time(entry_time), 
        .cost_rate(cost_rate), 
        .total_cost(total_cost)
    );

    initial begin
        current_time = 0;
        entry_time = 0;
        cost_rate = 1;

        #10;
        
        // Test Case 1: 1 L.E.
        // Car entered at  5, leaves at  20. 
        // Expected Math: (20 - 5) * 1 = 15 L.E. (1111)
        current_time = 16'd20;
        entry_time = 16'd5;
        cost_rate = 4'd1;
        #20;


        // Test Case 2: 2 L.E.
        // Car entered at  10, leaves at 50.
        // Expected Math: (50 - 10) * 2 = 80 L.E.(0101 0000)
        current_time = 16'd50;
        entry_time = 16'd10;
        cost_rate = 4'd2;
        #20;

        // Test Case 3: Zero Time in Garage 
        // Car entered at tick 30, leaves at tick 30.
        // Expected Math: (30 - 30) * 3 = 0 L.E. (0)
      
        current_time = 16'd30;
        entry_time = 16'd30;
        cost_rate = 4'd3;
        #20;
        
        // Test Case 4: High Numbers
        // Car entered at 500, leaves at 1000. Rate is 5.
        // Expected Math: (1000 - 500) * 5 = 2500 L.E.(1001 1100 0100)
        current_time = 16'd1000;
        entry_time = 16'd500;
        cost_rate = 4'd5;
        #20;
		
        $stop;
    end

endmodule
