`timescale 1ns / 1ps

module tb_asps_top;

    reg MAX10_CLK1_50;
    reg [9:0] SW;
    reg [1:0] KEY;

    wire [9:0] LEDR;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;

    asps_top uut (
        .MAX10_CLK1_50(MAX10_CLK1_50), 
        .SW(SW), 
        .KEY(KEY), 
        .LEDR(LEDR), 
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3)
    );

    // 50 MHz Clock Generation
    always #10 MAX10_CLK1_50 = ~MAX10_CLK1_50;

    initial begin

        MAX10_CLK1_50 = 0;
        SW = 10'b00000_00000;
        KEY = 2'b11; //inverted , all off

        // Reset off
        #20;
        SW[0] = 1; // Turn system ON
        
        //tiktok - no not the app
        #200;

        // --- TEST ALARM ON EMPTY ---
        // Press Exit Button ,key  1 (illegally)
        KEY[1] = 0; #100; // Hold down
        KEY[1] = 1; #100; // Release

        //Car 1 Enter ,Set Rate to 2 L.E., Car ID to 01
        // Rate = SW[4:3], Car ID = SW[2:1]
        SW = 10'b00000_10_01_1; 
        
        // Press Entry Button ,key 0
        KEY[0] = 0; #100; // Hold down
        KEY[0] = 1; #100; // Release

        //one sheep , two sheep , 3 sheep
        #500;

        //Car 2 Enters Keep Rate 2 L.E., change Car ID to 10
        SW = 10'b00000_10_10_1;

        // Press Entry Button
        KEY[0] = 0; #100; 
        KEY[0] = 1; #100;

        //zzzzzzzzzz....
        #500;
        
        //Car 3 Enters (Garage hits max capacity here!)
        KEY[0] = 0; #100; 
        KEY[0] = 1; #100;

        // --- TEST ALARM ON FULL ---
        // trying to enter 4th car
        KEY[0] = 0; #100; 
        KEY[0] = 1; #100;

        //Car 1 Exit, switches to Car ID 01 to check cost, then opens gate
        SW = 10'b00000_10_01_1;
        #100; // Pause to let the system calculate the cost for Car 1
        
        // Press Exit Button ,key  1
        KEY[1] = 0;
        #100; 
        KEY[1] = 1; #100; 

        #200;
        
        //Check Car 2's Cost ,Switch ID to 10
        SW = 10'b00000_10_10_1;
        #200;

        $stop;
    end
endmodule