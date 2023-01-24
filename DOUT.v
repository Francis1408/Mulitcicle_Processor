module DOUT(clock, DOUT_in, DOUT_out, DOUT_write);

 input clock;
 input [16:0] DOUT_in;
 input DOUT_write;
 
 output [15:0] DOUT_out;
 
 reg [15:0] DOUT_data;
 
 always @(posedge clock) begin
	
	if(DOUT_write) begin
		DOUT_data <= DOUT_in [15:0];
	end
 
 end

 assign DOUT_out = DOUT_data;


endmodule
