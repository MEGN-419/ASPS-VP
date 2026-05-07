module edge_detector(
    input clk, 
    input rstn, 
    input sync_btn,   // From the synchronizer
    output pulse_out  // The final single pulse
);
    wire delayed_btn;
    // Delay the signal by one clock cycle
    d_ff stage3 (.d(sync_btn), .rstn(rstn), .clk(clk), .q(delayed_btn));
    assign pulse_out = sync_btn & ~delayed_btn;

endmodule
