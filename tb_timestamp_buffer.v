`timescale 1ns / 1ps

module tb_timestamp_buffer;

    reg clk;
    reg rstn;
    reg enter_pulse;
    reg [1:0] car_id;
    reg [15:0] current_time;


    wire [15:0] saved_time;

    timestamp_buffer uut (
        .clk(clk), 
        .rstn(rstn), 
        .enter_pulse(enter_pulse), 
        .car_id(car_id), 
        .current_time(current_time), 
        .saved_time(saved_time)
    );

    // 10N clk
    always #5 clk = ~clk;

    //simulated global timer 
    always @(posedge clk) begin
        if (!rstn) current_time <= 16'd0;
        else current_time <= current_time + 1'b1;
    end

    initial begin
        clk = 0;
        rstn = 0;
        enter_pulse = 0;
        car_id = 2'b00;

        //Reset
        #20;
        rstn = 1; 
        
        #50;//make counter... , count

        //Car 1 Enters (Switch = 01)
        car_id = 2'b01; //(*)
        enter_pulse = 1; 
        #10; 
        enter_pulse = 0;

        #100;//lalalalalala...

        //Car 2 Enters (Switch = 10)
        car_id = 2'b10; //(**)
        enter_pulse = 1;
        #10;
        enter_pulse = 0;

        #50;//hi , how are you

        //Cars Exiting *reading mem
        //switchs to car one ,(should be equal to *)
        car_id = 2'b01;
        #40;
        
        // car 2 (**)
        car_id = 2'b10;
        #40;
        
        // trying car 3 ,(should be zero)
        car_id = 2'b11;
        #40;

        $stop;
    end

endmodule