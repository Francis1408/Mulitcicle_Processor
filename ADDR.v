module ADDR(clock, ADDR_in, ADDR_out, ADDR_write);

 input clock;
 input [16:0] ADDR_in;
 input ADDR_write;
 
 output [15:0] ADDR_out;
 
 reg [15:0] ADDR_data;
 
 always @(posedge clock) begin
	
	if(ADDR_write) begin
		ADDR_data <= ADDR_in [15:0];
	end
 
 end

 assign ADDR_out = ADDR_data;



endmodule