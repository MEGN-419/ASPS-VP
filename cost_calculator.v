module cost_calculator(
    input [15:0] current_time,
    input [15:0] entry_time,
    input [3:0] cost_rate,      //changed using switches
    output reg [15:0] total_cost
);
    reg [15:0] time_spent;
	
    always @(*) begin
        time_spent = current_time - entry_time;
        total_cost = time_spent * cost_rate;
    end

endmodule
