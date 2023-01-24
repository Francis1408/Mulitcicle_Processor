module external_mux(EMUX_select, RAM_output, ROM_output, EMUX_out);

 input EMUX_select;
 input [15:0] RAM_output;
 input [16:0] ROM_output;
 
 output [16:0] EMUX_out;
 
 reg [16:0] EMUX_content;
 
 always @(*) begin
 
	case(EMUX_select)
	
		1'b0: begin
			$write("Opening ROM port");
			EMUX_content <= ROM_output;			
		end
		
		1'b1: begin
			$write("Opening RAM port");
			EMUX_content <= {1'b0, RAM_output};
		end
	
	endcase
 
 end
 
 assign EMUX_out = EMUX_content;




endmodule
