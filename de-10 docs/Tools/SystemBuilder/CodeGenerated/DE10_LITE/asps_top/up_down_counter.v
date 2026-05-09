module up_down_counter(
    input clk,
    input rstn,
    input up_pulse,
    input down_pulse,
    output reg [3:0] count
);

    // The states literally the count
    parameter C_ZERO  = 4'd0;
    parameter C_ONE   = 4'd1;
    parameter C_TWO   = 4'd2;
    parameter C_THREE = 4'd3;

    reg [3:0] current_state, next_state;

    //State Memory Block
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= C_ZERO;
        end else begin
            current_state <= next_state;
        end
    end

    //Next State & Output Logic Block
    always @(*) begin
        // Default behaviors
        next_state = current_state; 
        count = current_state;      // The output is just the current state

        // FSM Transitions
        case (current_state)
            C_ZERO: begin
                if (up_pulse) next_state = C_ONE;
            end
            
            C_ONE: begin
                if (up_pulse) next_state = C_TWO;
                else if (down_pulse) next_state = C_ZERO;
            end
            
            C_TWO: begin
                if (up_pulse) next_state = C_THREE;
                else if (down_pulse) next_state = C_ONE;
            end
            
            C_THREE: begin
               
                if (down_pulse) next_state = C_TWO;
            end
            
            default: next_state = C_ZERO;
        endcase
    end

endmodule
//made the counter an fsm ,rather than behavioral , so it strictly count up to 3 (4 states : 0>1>2>3)