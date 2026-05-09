module button_conditioner(
    input clk, 
    input rstn, 
    input raw_btn, 
    output final_pulse
);
    wire safe_sync_signal;
    //  Sync the button
    synchronizer sync_inst (
        .clk(clk), 
        .rstn(rstn), 
        .async_btn(raw_btn), 
        .sync_btn(safe_sync_signal)
    );
    //Turn it into a pulse
    edge_detector edge_inst (
        .clk(clk), 
        .rstn(rstn), 
        .sync_btn(safe_sync_signal), 
        .pulse_out(final_pulse)
    );

endmodule
	