module ir_reg(DIN, clock, IR_write, IR_out);

 input clock;
 input [16:0] DIN;
 input IR_write;

 output [16:0] IR_out;

 reg [16:0] ir_data;


 always @(posedge clock) begin

	if(IR_write) begin
		ir_data <= DIN;
	end

  end

 assign IR_out = ir_data;

endmodule
