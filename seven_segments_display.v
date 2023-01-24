module seven_segments_display(PROC_in, DISP_out_HEX0, DISP_out_HEX1, DISP_done);

 input [16:0] PROC_in;
 input DISP_done;
 output reg [6:0] DISP_out_HEX0;
 output reg [6:0] DISP_out_HEX1;


 always @(*) begin
	
	if(DISP_done == 1) begin	
		case(PROC_in)
				16'b0000000000000000: begin
					DISP_out_HEX0 = 7'b1000000; //0
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000000001: begin 
					DISP_out_HEX0 = 7'b1111001; //1
					DISP_out_HEX1 = 7'b1000000; //0
				end	
				16'b0000000000000010: begin 
					DISP_out_HEX0 = 7'b0100100; //2
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000000011: begin 
					DISP_out_HEX0 = 7'b0110000; //3
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000000100: begin 
					DISP_out_HEX0 = 7'b0011001; //4
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000000101: begin 
					DISP_out_HEX0 = 7'b0010010; //5
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000000110: begin 
					DISP_out_HEX0 = 7'b0000010; //6
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000000111: begin 
					DISP_out_HEX0 = 7'b1011000; //7
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000001000: begin 
					DISP_out_HEX0 = 7'b0000000; //8
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000001001: begin
					DISP_out_HEX0 = 7'b0011000; //9
					DISP_out_HEX1 = 7'b1000000; //0
				end
				16'b0000000000001010: begin 
					DISP_out_HEX0 = 7'b1000000; //0
					DISP_out_HEX1 = 7'b1111001; //1
				end
				16'b0000000000001011: begin 
					DISP_out_HEX0 = 7'b1111001; //1
					DISP_out_HEX1 = 7'b1111001; //1
				end
				16'b0000000000001100: begin 
					DISP_out_HEX0 = 7'b0100100; //2
					DISP_out_HEX1 = 7'b1111001; //1
				end
				16'b0000000000001101: begin 
					DISP_out_HEX0 = 7'b0110000; //3
					DISP_out_HEX1 = 7'b1111001; //1
				end
				16'b0000000000001101: begin 
					DISP_out_HEX0 = 7'b0011001; //4
					DISP_out_HEX1 = 7'b1111001; //1
				end
				16'b0000000000001101: begin 
					DISP_out_HEX0 = 7'b0010010; //5
					DISP_out_HEX1 = 7'b1111001; //1
				end
				default : begin 
					DISP_out_HEX0 = 7'b1000000; //0
					DISP_out_HEX1 = 7'b1000000; //0	
				end
		endcase
	end 
	else begin
			DISP_out_HEX0 = 7'b1111111; // Turned Off
			DISP_out_HEX1 = 7'b1111111;
		end
 end
 
endmodule
