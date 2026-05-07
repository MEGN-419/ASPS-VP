module timestamp_buffer(
    input clk,
    input rstn,
    input enter_pulse,
    input [1:0] car_id,     //from switches       
    input [15:0] current_time,    //timer 
    output reg [15:0] saved_time   //time enterd
);

    //car 0 :16b
	//car 1 :16b
	//car 2 :16b
    reg [15:0] memory_array [0:3]; 
    integer i;

    //Writing to Memory
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            //reset
            for (i = 0; i < 4; i = i + 1) begin
                memory_array[i] <= 16'd0;
            end
        end else if (enter_pulse) begin
            // save time on enter 
            memory_array[car_id] <= current_time;
        end
    end

    //Reading from Memory
    always @(*) begin
        saved_time = memory_array[car_id];
    end

endmodule
