module lab1_jc(input logic reset, [3:0] s,
				output logic [2:0] led, [6:0] seg);
	
	logic led_state = 0;
	logic [24:0] counter = 0;
	logic clk;
	
	assign led[0] = s[1] ^ s[0];
	assign led[1] = s[2] & s[3];
	
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
	
	// divider
	always_ff @(posedge clk)
		begin
			if(counter == 10000000) begin
				counter <= 0;
				led[2] <= ~led[2]; // not because its continuous
			end
			
			else if(reset == 0) begin
				counter <= 0;
				led[2] <= 0;
			end
			
			else begin
				counter <= counter + 1;
			end
		end
		
	seven_segment s1(s, seg);
	
	
endmodule