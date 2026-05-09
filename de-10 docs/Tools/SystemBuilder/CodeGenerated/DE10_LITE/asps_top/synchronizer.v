module synchronizer(
    input clk, 
    input rstn, 
    input async_btn,  // Raw bouncy button
    output sync_btn   // Clean synced button
);
    wire ff1_out;
    // Instantiate two D Flip-Flops
    d_ff s1 (.d(async_btn), .rstn(rstn), .clk(clk), .q(ff1_out));
    d_ff s2 (.d(ff1_out),   .rstn(rstn), .clk(clk), .q(sync_btn));

endmodule
