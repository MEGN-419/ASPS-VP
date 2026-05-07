module timestamp_buffer(
    input clk,
    input rstn,
    input enter_pulse,
    input exit_pulse,
    input [1:0] car_id,           // Switches (Now used ONLY for viewing and exiting)
    input [15:0] current_time,    // Timer 
    output reg [15:0] saved_time  // Output to the cost calculator
);

    reg [15:0] memory_array [0:3]; 
    integer i;

    // Writing to Memory
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            // Reset all spots to 0 (Empty)
            for (i = 0; i < 4; i = i + 1) begin
                memory_array[i] <= 16'd0;
            end
            
        end else if (enter_pulse) begin
            //Find the first empty spot and park the car there
            if (memory_array[0] == 16'd0) begin
                memory_array[0] <= current_time;
            end else if (memory_array[1] == 16'd0) begin
                memory_array[1] <= current_time;
            end else if (memory_array[2] == 16'd0) begin
                memory_array[2] <= current_time;
            end else if (memory_array[3] == 16'd0) begin
                memory_array[3] <= current_time;
            end
            
        end else if (exit_pulse) begin       
            //Erase the specific ticket selected by the switches
            memory_array[car_id] <= 16'd0; 
        end
    end

    // Reading from Memory
    always @(*) begin
        saved_time = memory_array[car_id];
    end

endmodule