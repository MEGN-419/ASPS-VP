module asps_top(
    input MAX10_CLK1_50, 
    input [9:0] SW,      
    input [1:0] KEY,     
    
    output [9:0] LEDR,   
    output [6:0] HEX0,   
    output [6:0] HEX1,   
    output [6:0] HEX2,   
    output [6:0] HEX3    
);

    // board inputs
    wire clk = MAX10_CLK1_50;
    wire rstn = SW[0];              
    wire [1:0] car_id = SW[2:1];    
    wire [3:0] cost_rate = {2'b00, SW[4:3]}; 
    
    // invert the active-low buttons
    wire entry_btn = ~KEY[0];   
    wire exit_btn  = ~KEY[1];   

    // internal wires
    wire clk_4Hz; 
    wire enter_pulse, exit_pulse;
    wire [3:0] ccount;
    wire empty_flag, full_flag, alarm_flag;
    wire [15:0] current_time;
    wire [15:0] saved_time;
    wire [15:0] total_cost;

    // clock divider
    clock_divider clk_div (
        .clk(clk), .reset(~rstn), .CLK4Hz(clk_4Hz) 
    );

    // button conditioners
    button_conditioner btn_in (
        .clk(clk),
		.rstn(rstn), 
		.raw_btn(entry_btn), 
		.final_pulse(enter_pulse)
    );
    button_conditioner btn_out (
        .clk(clk), 
		.rstn(rstn), 
		.raw_btn(exit_btn), 
		.final_pulse(exit_pulse)
    );

    // main fsm
    car_counter_fsm fsm (
        .clk(clk), .rstn(rstn), .enter_pulse(enter_pulse), .exit_pulse(exit_pulse), 
        .ccount(ccount), .empty_flag(empty_flag), .full_flag(full_flag), .alarm(alarm_flag)
    );

    // timer and memory
    global_timer timer (
        .clk_250ms(clk_4Hz), 
		.rstn(rstn), 
		.current_time(current_time)
    );

    timestamp_buffer mem (
        .clk(clk), .rstn(rstn), .enter_pulse(enter_pulse & ~full_flag), .exit_pulse(exit_pulse), 
        .car_id(car_id), .current_time(current_time), .saved_time(saved_time)
    );

    // cost math
    cost_calculator calc (
        .current_time(current_time), 
		.entry_time(saved_time), 
        .cost_rate(cost_rate), 
		.total_cost(total_cost)
    );

   //The Display Decoders 
    sevenSegments disp_count (
        .bcd(ccount), .dec(HEX0)
    );
    
    // Use Math to split the binary cost into decimal digits
    sevenSegments disp_cost_low (
        .bcd(total_cost % 10), .dec(HEX1)       
    );
    sevenSegments disp_cost_mid (
        .bcd((total_cost / 10) % 10), .dec(HEX2) 
    );
    sevenSegments disp_cost_high (
        .bcd((total_cost / 100) % 10), .dec(HEX3) 
    );

    // leds
    assign LEDR[0] = empty_flag;
    assign LEDR[1] = full_flag;
    assign LEDR[9] = alarm_flag;

endmodule
