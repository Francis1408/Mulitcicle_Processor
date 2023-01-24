module g_reg(clock, G_in, G_write, G_out, G_cond_check);

 input clock;
 input [15:0] G_in;
 input G_write;
 
 output [15:0] G_out;
 output reg G_cond_check;
 
 reg [15:0] G_data;
 
 initial begin
	G_cond_check = 0;
 end
 
 always @(posedge clock) begin
	
	if(G_write) begin
	   $write("Writing on G reg");
		G_data <= G_in;
	end
	
	if(!G_data) begin
		$write("G reg data equal to zero\n");
		G_cond_check = 1;
	end
	else begin
		G_cond_check = 0;
	end
 end

 assign G_out = G_data;

endmodule



