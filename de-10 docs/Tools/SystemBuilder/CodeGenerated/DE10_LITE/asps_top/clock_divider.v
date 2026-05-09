module clock_divider (clk, reset, CLK4Hz);
input clk, reset;
output CLK4Hz;
// ------------------------------------------------- //
reg CLK4Hz;
reg [24:0] count;
// ------------------------------------------------- //
always @(posedge clk or posedge reset)
begin
if(reset) // initial (zero)
begin
count <= 0;
CLK4Hz <= 0;
end
else
begin
if(count < 25000) //<------- THIS ONE ******************************************************
 count <= count + 1; // count 6.25 million
else
 begin
CLK4Hz = ~CLK4Hz; // toggle the clk high\low
count <= 0;
 end
end
end
// ------------------------------------------------- //
endmodule
//also from labs

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//i hate this piece of sh*t
//ok , focuse with me 
//if u want to synsithize the code on the fpga , SET THE IF OF LINE 17 to   exactly (* 6250000 *)
//if u want to testbech the top , SET TO (* 5 *)
//if u want to desim it , SET TO (* 25000 *)
//allahuma bala8t , allahuma fashhad