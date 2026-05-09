module global_timer(
    input clk_250ms,
    input rstn,
    output reg [15:0] current_time // counts to 4.5 hours
);
    always @(posedge clk_250ms or negedge rstn) begin
        if (!rstn)
            current_time <= 16'd0;
        else
            current_time <= current_time + 1'b1;
    end
endmodule
