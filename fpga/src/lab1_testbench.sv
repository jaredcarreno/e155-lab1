`timescale 1ns/1ns

module lab1_testbench();

	logic clk;
	logic reset;
	
	logic [3:0] s;
	logic [2:0] led;
	logic [6:0] seg;
	
	logic [2:0] led_expected; // only testing non-blinking LEDs
	logic [6:0] seg_expected;
	
	logic [31:0] vectornum, errors;
	logic [13:0] testvectors[10000:0];
	
	
//// Instantiate device under test (DUT)
	lab1_jc dut(reset, s, led, seg);
	
 //extract clock
	//assign clk = dut.clk;
	
always
// 'always' statement causes the statements in the block to be 
// continuously re-evaluated.
	begin
 //// Create clock with period of 10 time units. 
// Set the clk signal HIGH(1) for 5 units, LOW(0) for 5 units 
		clk=1; #5; 
		clk=0; #5;
	end
	
initial
	begin
		$readmemb("lab1.tv", testvectors);
		
		vectornum = 0;
		errors = 0;
		
		reset = 0; #22;
		reset = 1;
	end
	
always @(posedge clk)
	begin
		#1;
		{s, led_expected, seg_expected} = testvectors[vectornum];
	end
	
always @(negedge clk)
	if (reset) begin
		if(led[1:0] !== led_expected[1:0] || seg !== seg_expected) begin
			$display("Error: inputs %b", {s});
			$display("outputs = %b %b (%b %b expected)", led, seg, led_expected, seg_expected);
			errors = errors + 1;
		end
		
		vectornum = vectornum + 1;
		if (testvectors[vectornum] === 14'bx) begin
			$display("%d tests are completed with %d errors", vectornum, errors);
			
			$stop;
		end
	end
			  
endmodule	
			