module a_reg(clock, A_in, A_write, A_out);

input clock;
input [16:0] A_in;
input A_write;

output [15:0] A_out;

reg [15:0] A_data;

 always @(posedge clock) begin
	
	if(A_write) begin
		A_data <= A_in [15:0];
	end
	
 end

assign A_out = A_data;

endmodule