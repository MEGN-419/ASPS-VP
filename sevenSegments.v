module sevenSegments (bcd,dec);
input [3:0]bcd;
output reg [6:0] dec;
always@(bcd)
		begin 
			case(bcd)
				4'b0000 : dec = ~7'b1111110; // 0
				4'b0001 : dec = ~7'b0110000; // 1
				4'b0010 : dec = ~7'b1101101; // 2
				4'b0011 : dec = ~7'b1111001; // 3
				4'b0100 : dec = ~7'b0110011; // 4
				4'b0101 : dec = ~7'b1011011; // 5
				4'b0110 : dec = ~7'b1011111; // 6
				4'b0111 : dec = ~7'b1110000; // 7
				4'b1000 : dec = ~7'b1111111; // 8
				4'b1001 : dec = ~7'b1111011; // 9
				4'b1010 : dec = ~7'b1110111; // A 
				4'b1011 : dec = ~7'b1111111; // B
 				4'b1100 : dec = ~7'b1001000; // =
			default : dec = ~7'b1111110; //0 default  
			endcase 
		end
endmodule

