module car_counter_fsm(
    input clk,
    input rstn,
    input enter_pulse, 
    input exit_pulse, 
    output reg [3:0] ccount,
    output empty_flag,
    output full_flag,
    output reg alarm    // Alarm is now a clocked register!
);
    // State Encoding
    parameter S_EMPTY = 2'b00;
    parameter S_ONE   = 2'b01;
    parameter S_TWO   = 2'b10;
    parameter S_FULL  = 2'b11;

    reg [1:0] current_state, next_state;

    // flag generation
    assign empty_flag = (current_state == S_EMPTY);
    assign full_flag  = (current_state == S_FULL);

    // State & Sticky Alarm Memory
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= S_EMPTY;
            alarm <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // STICKY ALARM LOGIC
            if ((current_state == S_FULL && enter_pulse) || (current_state == S_EMPTY && exit_pulse)) begin
                alarm <= 1'b1; // Turn alarm ON if illegal move is attempted
            end else if (enter_pulse || exit_pulse) begin
                alarm <= 1'b0; // Turn alarm OFF when a valid move finally happens
            end
        end
    end

    // Combinational Block (Next State & Car Count)
    always @(*) begin
        next_state = current_state; // default
        
        case (current_state)
            S_EMPTY: begin
                ccount = 4'd0;
                if (enter_pulse) next_state = S_ONE;
            end
            S_ONE: begin
                ccount = 4'd1;
                if (enter_pulse) next_state = S_TWO;
                else if (exit_pulse) next_state = S_EMPTY;
            end
            S_TWO: begin
                ccount = 4'd2;
                if (enter_pulse) next_state = S_FULL;
                else if (exit_pulse) next_state = S_ONE;
            end
            S_FULL: begin
                ccount = 4'd3;
                if (exit_pulse) next_state = S_TWO;
            end
            default: next_state = S_EMPTY;
        endcase
    end

endmodule