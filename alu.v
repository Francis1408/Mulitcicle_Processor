module alu(A_in, BUS_in, ALU_out, add_sub, and_signal, barrel_shift);

 input [15:0] A_in;
 input [16:0] BUS_in;
 input add_sub;
 input and_signal;
 input [2:0] barrel_shift;
 
 reg [15:0] ALU_data;
 
 output [15:0] ALU_out;
 
 wire [4:0] operation;
 
 assign operation = {barrel_shift ,and_signal, add_sub};

 always @(*) begin
 
	case (operation)
 
		5'b00000: begin // SUB
	
		ALU_data <= A_in - BUS_in [15:0];
		
		end
		
		5'b00001: begin // ADD
	
		ALU_data <= A_in + BUS_in [15:0];
		
		end
		
		5'b00010: begin // AND
		
		ALU_data <= A_in & BUS_in[15:0];
		
		end

		5'b00100: begin // LSL
		
		ALU_data <= A_in << BUS_in[3:0];
		
		end
	
		5'b01000: begin // LSR
		
		ALU_data <= A_in >> BUS_in[3:0];
		
		end
		
		5'b01100: begin // ASR
		
		ALU_data <= {{16{A_in[15:15]}}, A_in} >> BUS_in[3:0];
		
		end
		
		5'b10000: begin // ROR
		
		ALU_data <= (A_in >> BUS_in[3:0]) | (A_in << (16 - BUS_in[3:0]));
		
		end
		
	endcase
 
 end
 
 assign ALU_out = ALU_data;

endmodule
