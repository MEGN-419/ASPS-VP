// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

module tb();
    reg CLOCK_50 = 0;               // DE-series 50 MHz clock
    reg [9:0] SW = 0;               // DE-series SW switches
    reg [3:0] KEY = 0;              // DE-series pushbutton keys
    wire [(8*6)-1:0] HEX;           // HEX displays (six ports)
    wire [9:0] LEDR;                // DE-series LEDs

    reg key_action = 0;             // the next three signals are used only
    reg [7:0] scan_code = 0;        // if a PS/2 keyboard is being emulated in
    wire [2:0] ps2_lock_control;    // the DESim project

    wire [9:0] VGA_X;               // "VGA" column
    wire [8:0] VGA_Y;               // "VGA" row
    wire [23:0] VGA_COLOR;          // "VGA pixel" colour
    wire plot;                      // "Pixel" is drawn when this is pulsed
    wire [31:0] GPIO;               // DE-series GPIO port

    initial $sim_fpga(CLOCK_50, SW, KEY, LEDR, HEX, key_action, scan_code, 
                      ps2_lock_control, VGA_X, VGA_Y, VGA_COLOR, plot, GPIO);
                      
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    

    always #10
        CLOCK_50 <= ~CLOCK_50;
        
    // We reverse the bits so the numbers draw correctly, 
    // AND we keep the screens in the correct physical order (0, 1, 2, 3)
    assign HEX[ 7: 0] = ~{1'b0, ~HEX0[0], ~HEX0[1], ~HEX0[2], ~HEX0[3], ~HEX0[4], ~HEX0[5], ~HEX0[6]};
    assign HEX[15: 8] = ~{1'b0, ~HEX1[0], ~HEX1[1], ~HEX1[2], ~HEX1[3], ~HEX1[4], ~HEX1[5], ~HEX1[6]};
    assign HEX[23:16] = ~{1'b0, ~HEX2[0], ~HEX2[1], ~HEX2[2], ~HEX2[3], ~HEX2[4], ~HEX2[5], ~HEX2[6]};
    assign HEX[31:24] = ~{1'b0, ~HEX3[0], ~HEX3[1], ~HEX3[2], ~HEX3[3], ~HEX3[4], ~HEX3[5], ~HEX3[6]};
    assign HEX[39:32] = ~8'b0; // Turn off unused screen
    assign HEX[47:40] = ~8'b0; // Turn off unused screen
    

    asps_top DUT (
        .MAX10_CLK1_50(CLOCK_50), 
        .SW(SW), 
        .KEY(KEY[1:0]),     // We only need KEY0 and KEY1
        .LEDR(LEDR), 
        .HEX0(HEX0), 
        .HEX1(HEX3), 
        .HEX2(HEX2), 
        .HEX3(HEX1)
    );

endmodule