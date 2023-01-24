module multiplexer(MUX_select, MUX_IR_out, MUX_COUNTER_out, MUX_REGBANK_Rx_out, MUX_REGBANK_Ry_out, MUX_G_out, MUX_out, MUX_DIN);


/* MUX TABLE
	
			Data output  		| 	MUX_select
	 -------------------------------------
	 Reg IR data  				|   0000
	 Reg Rx data 				|   0001
	 Reg Ry data 				|   0010
	 Counter data				|   0011
	 Reg IR immediate 		| 	 0100
	 Reg IR immediate(top)	|   0101
	 Reg G data             |   0110
	 DIN data               |   0111
	 
	
	*/


 input [3:0]  MUX_select;
 input [16:0] MUX_IR_out;
 input [15:0] MUX_COUNTER_out;
 input [15:0] MUX_REGBANK_Rx_out;
 input [15:0] MUX_REGBANK_Ry_out;
 input [15:0] MUX_G_out;
 input [16:0] MUX_DIN;

 output [16:0] MUX_out;
 
 reg [16:0] MUX_content;


 always @(*) begin
 
	case(MUX_select) 
	
	
		4'b0000: begin // Reg IR data
			$write("Opening IR data port");
			MUX_content <=  MUX_IR_out;
		
		end
		
		4'b0001: begin // Reg Rx data
			$write("Opening Rx data port");
			MUX_content <= {1'b0, MUX_REGBANK_Rx_out};
		
		end
		
		4'b0010: begin // Reg Ry data
			$write("Opening Ry data port");
			MUX_content <= {1'b0, MUX_REGBANK_Ry_out};
		
		end
		
		
		4'b0011: begin // Reg Counter Data
			$write("Opening Counter data port");
			MUX_content <= {1'b0, MUX_COUNTER_out};
		
		end
		
		4'b0100: begin //  IR imedediate
			$write("Opening Imediate data port");
			MUX_content <= {7'b0, MUX_IR_out[8:0]};
		end
		
		4'b0101: begin // IR imediate top
			$write("Opening Imediate Top data port");
			MUX_content <= {MUX_IR_out[8:0], 7'b0};
		end
		
		4'b0110: begin // Reg G data
			$write("Opening G data port");
			MUX_content <= {1'b0, MUX_G_out};
		end
		
		4'b0111: begin // DIN data
			$write("Opening DIN data port");
			MUX_content <= MUX_DIN;
		end
	
	endcase
 
 end
 
 assign MUX_out = MUX_content;


endmodule
