module car_counter_fsm(
    input clk,
    input rstn,
    input enter_pulse, 
    input exit_pulse, 
    input is_vacant,     // <--- NEW INPUT: Sensor checks if the specific spot is empty!
    output empty_flag,
    output full_flag,
    output reg alarm, 
    output valid_enter,  
    output valid_exit    
);
    // State Encoding
    parameter S_EMPTY = 2'b00;
    parameter S_ONE   = 2'b01;
    parameter S_TWO   = 2'b10;
    parameter S_FULL  = 2'b11;

    reg [1:0] current_state, next_state;

    // Flag generation
    assign empty_flag = (current_state == S_EMPTY);
    assign full_flag  = (current_state == S_FULL);

    // GENERATE THE SAFE UP/DOWN PULSES
    assign valid_enter = enter_pulse & ~full_flag;
    assign valid_exit  = exit_pulse & ~is_vacant; // <--- CLOSES THE LOOPHOLE!

    // State & Sticky Alarm Memory
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= S_EMPTY;
            alarm <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // STICKY ALARM LOGIC
            if ((enter_pulse && full_flag) || (exit_pulse && is_vacant)) begin
                alarm <= 1'b1; // Trigger alarm if full entry OR vacant exit attempted!
            end else if (valid_enter || valid_exit) begin
                alarm <= 1'b0; // Turn alarm OFF when a valid move happens
            end
        end
    end

    // Combinational Block 
    always @(*) begin
        next_state = current_state; // default
        
        case (current_state)
            S_EMPTY: if (valid_enter) next_state = S_ONE;
            S_ONE:   if (valid_enter) next_state = S_TWO; else if (valid_exit) next_state = S_EMPTY;
            S_TWO:   if (valid_enter) next_state = S_FULL; else if (valid_exit) next_state = S_ONE;
            S_FULL:  if (valid_exit) next_state = S_TWO;
            default: next_state = S_EMPTY;
        endcase
    end

endmodule
//last ver : added is_vacant to prevent phantom exits!