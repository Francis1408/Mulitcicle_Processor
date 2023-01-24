module counter(clock, COUNTER_in, COUNTER_write, COUNTER_increment, COUNTER_out);

 input clock;
 input [16:0] COUNTER_in;
 input COUNTER_write;
 input COUNTER_increment;
 
 output [15:0] COUNTER_out;
 
 reg [15:0] counter_data;
 
 initial begin
	counter_data = 0;
 end
 
 always @(posedge clock) begin
	
	if(COUNTER_write) begin
		counter_data <= COUNTER_in;
	end
	
	if(COUNTER_increment) begin
		counter_data <= counter_data + 1;
	end
 
 end

 assign COUNTER_out = counter_data;

endmodule