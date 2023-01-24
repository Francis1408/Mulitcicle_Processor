module control(clock, 
					Instruction, 
					IR_in, 
					PC_in, 
					PC_increment, 
					REGBANK_in, 
					MUX_select, 
					Done, 
					ALU_add_sub, 
					ALU_and, 
					ALU_barrel_shift,
					A_write_signal, 
					G_write_signal,
					G_cond_check,
					REGBANK_write_address,
					ADDR_write,
					DOUT_write,
					RAM_write,
					RAM_fetch);

	/* INSTRUCTIONS TABLE
		
	 Inst	 |  		Command  	|   Tag
	 -----------------------------------
	  mv   | Rx <- OP2 			  | 0000
	  mvt  | Rx <- #D  			  | 0001
	  add  | Rx <- Rx + OP2 	  | 0010
	  sub  | Rx <- Rx - OP2 	  | 0011
	  and  | Rx <- Rx & OP2 	  | 0100
	  lsl  | Rx <- Rx << OP2	  | 0101
	  lsr  | Rx <- Rx >> OP2	  | 0110
	  asr  | Rx <- Rx >>> OP2    | 0111
	  ror  | Rx <- Rx <<>> OP2   | 1000
	  b    | Pc <- label         | 1001 
	  beq  | if(G = 0)Pc <- label| 1010
	  bne  | if(G != 0)Pc <-label| 1011
	  ld   | Rx <- [Ry]          | 1100
	  st   | [Ry] <- Rx          | 1101
	  
	*/
	
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
	

 input [16:0] Instruction;
 input clock;
 input G_cond_check;

 output reg IR_in;
 output reg PC_in;
 output reg PC_increment;
 output reg REGBANK_in;
 output reg [3:0] MUX_select;
 output reg ALU_add_sub;
 output reg ALU_and;
 output reg A_write_signal;
 output reg G_write_signal;
 output reg Done;
 output reg [2:0] ALU_barrel_shift;
 output reg REGBANK_write_address;
 output reg ADDR_write;
 output reg DOUT_write;
 output reg RAM_write;
 output reg RAM_fetch;
 
 // Internal Wires
 
 reg [3:0] cicles;
 
 initial begin
  cicles = 4'b1111;
 end

 always @(posedge clock) begin
 
	if(cicles == 4'b1111) begin
		$write(" Fetching Instruction ");
		Done <= 0;
		PC_increment <= 0;
		cicles <= 4'b0000;
		IR_in <= 0;
	   PC_in <= 0;
	   PC_increment <= 0;
	   REGBANK_in <= 0;
	   MUX_select <= 0;
	   ALU_add_sub <= 0;
	   ALU_and <= 0;
	   A_write_signal <= 0;
	   G_write_signal <= 0;
	   Done <= 0;
	   ALU_barrel_shift <= 0;
	   REGBANK_write_address <= 0;
	   ADDR_write <= 0;
	   DOUT_write <= 0;
	   RAM_write <= 0;
	   RAM_fetch <= 0;
	end
 
   if(cicles == 4'b0000) begin
		$write("T0 = Load instruction "); 
		IR_in <= 1;
		cicles <= 4'b0001;
		MUX_select <= 4'b0000;
		REGBANK_write_address <= 1;
	end
	
	else if(cicles == 4'b0001) begin
		$write("T1 = Wait cicle ");
		IR_in <= 0;
		cicles <= 4'b0010;
	end
	
	
	else begin
		case(Instruction[16:13]) 

// -------------------------------- M V ------------------------------------------	
		
			4'b0000: begin // MV
				
				if(!Instruction[12:12]) begin // Mv Ry
					$write("Mv Ry Command");
					if(cicles == 4'b0010) begin
						$write("T2 = Select Ry and Write");
						REGBANK_write_address <= 0; // Close write_add
						MUX_select <= 4'b0010; // Select Ry
						REGBANK_in <= 1; // RxIn
						cicles <= 4'b0011; // Goes to T2
					end
					
					else if(cicles == 4'b0011) begin
						$write("T3 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
						IR_in <= 1;
					end
				end
				
				else if(Instruction[12:12]) begin // Mv Imediate
					$write("Mv Imediate Command");
					if(cicles == 4'b0010) begin
						REGBANK_write_address <= 0;
						$write("T2 = Select IR Imediate and Write");
						MUX_select <= 4'b0100; // Select IR Imediate
						REGBANK_in <= 1; // RxIn
						cicles <= 4'b0011; // Goes to T2
					end
					
					else if(cicles == 4'b0011) begin
						$write("T3 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end	
			end
	
// -------------------------------- M V T ------------------------------------------	

			4'b0001: begin // MVT
				$write("Mvt Intruction");
				if(cicles == 4'b0010) begin
					REGBANK_write_address <= 0;
					$write("T2 = Select IR Imediate and Write");
					MUX_select <= 4'b0101; // Select IR Top Imediate
					REGBANK_in <= 1; // Rxin
					cicles <= 4'b0011; // Goes to T2
				end
				
				else if(cicles == 4'b0011) begin
					$write("T3 = Done, clear signals, Increment PC, Show Result");
					REGBANK_in <= 0;
					cicles <= 4'b1111;
					PC_increment <= 1;
					Done <= 1;
				end
			end
			
// -------------------------------- A D D ------------------------------------------	
 
		  4'b0010: begin // ADD
			  if(!Instruction[12:12]) begin
				  $write("Add Instrution Ry");
				  if(cicles == 4'b0010) begin
						REGBANK_write_address <= 0;
						$write("T2 = Select RX and write on Reg A");
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
				  end
				  
				  else if(cicles == 4'b0011) begin
						$write("T3 = Select Ry, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0010; // Ryin
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_add_sub <= 1;
						cicles <= 4'b0100;
				  end
				  
				  else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						ALU_add_sub <= 0;
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
				  end
				  
				  else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
				  end
			  end
		
			  else if(Instruction[12:12]) begin
					$write("Add Instruction Imeddiate");
					if(cicles == 4'b0010) begin
						REGBANK_write_address <= 0;
						$write("T2 = Select RX and write on Reg A");
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
					end
				  
					else if(cicles == 4'b0011) begin
						$write("T3 = Select Immediate, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0100; // Immediate
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_add_sub <= 1;
						cicles <= 4'b0100;
					end
				  
					else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						ALU_add_sub <= 0;
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
					end
				  
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
			end
			
// -------------------------------- S U B ------------------------------------------

			4'b0011: begin // SUB
			  if(!Instruction[12:12]) begin
				  $write("Sub Instrution Ry");
				  if(cicles == 4'b0010) begin
						REGBANK_write_address <= 0;
						$write("T2 = Select RX and write on Reg A");
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
				  end
				  
				  else if(cicles == 4'b0011) begin
						$write("T3 = Select Ry, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0010; // Ryin
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_add_sub <= 0;
						cicles <= 4'b0100;
				  end
				  
				  else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
				  end
				  
				  else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
				  end
			  end
		
			  else if(Instruction[12:12]) begin
					$write("Sub Instruction Imeddiate");
					if(cicles == 4'b0010) begin
						REGBANK_write_address <= 0;
						$write("T2 = Select RX and write on Reg A");
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
					end
				  
					else if(cicles == 4'b0011) begin
						$write("T3 = Select Immediate, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0100; // Immediate
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_add_sub <= 0;
						cicles <= 4'b0100;
					end
				  
					else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
					end
				  
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
			end
			
// -------------------------------- A N D ------------------------------------------

			4'b0100: begin // AND
			  if(!Instruction[12:12]) begin
				  $write("And Instrution Ry");
				  if(cicles == 4'b0010) begin
						REGBANK_write_address <= 0;
						$write("T2 = Select RX and write on Reg A");
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
				  end
				  
				  else if(cicles == 4'b0011) begin
						$write("T3 = Select Ry, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0010; // Ryin
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_and <= 1;
						cicles <= 4'b0100;
				  end
				  
				  else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_and <= 0;
				  end
				  
				  else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
				  end
			  end
		
			  else if(Instruction[12:12]) begin
					$write("And Instruction Imeddiate");
					if(cicles == 4'b0010) begin
						REGBANK_write_address <= 0;
						$write("T2 = Select RX and write on Reg A");
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
					end
				  
					else if(cicles == 4'b0011) begin
						$write("T3 = Select Immediate, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0100; // Immediate
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_and <= 1;
						cicles <= 4'b0100;
					end
				  
					else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_and <= 0;
					end
				  
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
			end
			
// --------------------------------L S L ------------------------------------------	
	
			4'b0101: begin //LSL
				if(!Instruction[12:12]) begin
				$write("Barrel Shift Left Ry");
				if(cicles == 4'b0010) begin
					REGBANK_write_address <= 0;
					$write("T2 = Select RX and write on Reg A");
					MUX_select <= 4'b0001; // Rxin
					A_write_signal <= 1; 
					cicles <= 4'b0011; // Goes to T2
				  end
				  
				 else if(cicles == 4'b0011) begin
						$write("T3 = Select Ry, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0010; // Ryin
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_barrel_shift <= 3'b001; 
						cicles <= 4'b0100;
				  end
				  
				  else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_barrel_shift <= 0;
					end
					
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
				
				else if(Instruction[12:12]) begin
					$write(" Barrel Shift Left Immediate");
					if(cicles == 4'b0010) begin
						$write("T2 = Select RX and write on Reg A");
						REGBANK_write_address <= 0;
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
					end
				  
					else if(cicles == 4'b0011) begin
						$write("T3 = Select Immediate, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0100; // Immediate
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_barrel_shift <= 3'b001;
						cicles <= 4'b0100;
					end
				  
					else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_barrel_shift <= 3'b000;
					end
				  
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
			end

// -------------------------------- L S R ------------------------------------------	 			
	
			4'b0110: begin //LSR
				if(!Instruction[12:12]) begin
				$write("Barrel Shift Right Ry");
				if(cicles == 4'b0010) begin
					REGBANK_write_address <= 0;
					$write("T2 = Select RX and write on Reg A");
					MUX_select <= 4'b0001; // Rxin
					A_write_signal <= 1; 
					cicles <= 4'b0011; // Goes to T2
				  end
				  
				 else if(cicles == 4'b0011) begin
						$write("T3 = Select Ry, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0010; // Ryin
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_barrel_shift <= 3'b010; 
						cicles <= 4'b0100;
				  end
				  
				  else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_barrel_shift <= 0;
					end
					
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
				
				else if(Instruction[12:12]) begin
					$write(" Barrel Shift Right Immediate");
					if(cicles == 4'b0010) begin
						$write("T2 = Select RX and write on Reg A");
						REGBANK_write_address <= 0;
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
					end
				  
					else if(cicles == 4'b0011) begin
						$write("T3 = Select Immediate, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0100; // Immediate
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_barrel_shift <= 3'b010;
						cicles <= 4'b0100;
					end
				  
					else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_barrel_shift <= 3'b000;
					end
				  
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
			end
// -------------------------------- A S R ------------------------------------------	 			
	
			4'b0111: begin //ASR
				if(!Instruction[12:12]) begin
				$write("Arithmetic Shift Right Ry");
				if(cicles == 4'b0010) begin
					REGBANK_write_address <= 0;
					$write("T2 = Select RX and write on Reg A");
					MUX_select <= 4'b0001; // Rxin
					A_write_signal <= 1; 
					cicles <= 4'b0011; // Goes to T2
				  end
				  
				 else if(cicles == 4'b0011) begin
						$write("T3 = Select Ry, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0010; // Ryin
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_barrel_shift <= 3'b011; 
						cicles <= 4'b0100;
				  end
				  
				  else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_barrel_shift <= 0;
					end
					
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
				
				else if(Instruction[12:12]) begin
					$write(" Arithmetic Right Immediate");
					if(cicles == 4'b0010) begin
						$write("T2 = Select RX and write on Reg A");
						REGBANK_write_address <= 0;
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
					end
				  
					else if(cicles == 4'b0011) begin
						$write("T3 = Select Immediate, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0100; // Immediate
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_barrel_shift <= 3'b011;
						cicles <= 4'b0100;
					end
				  
					else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_barrel_shift <= 3'b000;
					end
				  
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
			end
	
// -------------------------------- R O R ------------------------------------------	 			
	
			4'b1000: begin //ASR
				if(!Instruction[12:12]) begin
				$write("Rotate Shift Right Ry");
				if(cicles == 4'b0010) begin
					REGBANK_write_address <= 0;
					$write("T2 = Select RX and write on Reg A");
					MUX_select <= 4'b0001; // Rxin
					A_write_signal <= 1; 
					cicles <= 4'b0011; // Goes to T2
				  end
				  
				 else if(cicles == 4'b0011) begin
						$write("T3 = Select Ry, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0010; // Ryin
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_barrel_shift <= 3'b100; 
						cicles <= 4'b0100;
				  end
				  
				  else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_barrel_shift <= 0;
					end
					
					else if(cicles == 4'b0101) begin
						$write("T5 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
				
				else if(Instruction[12:12]) begin
					$write(" Rotate Right Immediate");
					if(cicles == 4'b0010) begin
						$write("T2 = Select RX and write on Reg A");
						REGBANK_write_address <= 0;
						MUX_select <= 4'b0001; // Rxin
						A_write_signal <= 1; 
						cicles <= 4'b0011; // Goes to T2
					end
				  
					else if(cicles == 4'b0011) begin
						$write("T3 = Select Immediate, Execute operation ULA and write on Reg G");
						MUX_select <= 4'b0100; // Immediate
						A_write_signal <= 0; 
						G_write_signal <= 1;
						ALU_barrel_shift <= 3'b100;
						cicles <= 4'b0100;
					end
				  
					else if(cicles == 4'b0100) begin
						$write("T4 = Select G, Write Result on RX ");
						MUX_select <= 4'b0110; // RgIn
						G_write_signal <= 0;
						REGBANK_in <= 1;
						cicles <= 4'b0101;
						ALU_barrel_shift <= 3'b000;
					end
				  
					else if(cicles == 4'b0101) begin
						$write("T4 = Done, clear signals, Increment PC, Show Result");
						REGBANK_in <= 0;
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				end
			end
			
// -------------------------------- BRANCH ------------------------------------------
			
			4'b1001: begin
				$write("Always Branch command");
				if(cicles == 4'b0010) begin
					$write("T2 = Select IR Imeddiate, Write on Counter");
					REGBANK_write_address <= 0;
					MUX_select <= 4'b0100; // Ir imeddiate
					PC_in <= 1;
					cicles <= 4'b0011;			
				 end
			 
				 else if(cicles == 4'b0011) begin
					$write("T3 = Done, clear signals, Show Result");
					PC_in <= 0;
					cicles <= 4'b1111;
					MUX_select <= 4'b0011;
					Done <= 1;
				 end
			end
			
// -------------------------------- BRANCH EQUAL ------------------------------------------
			
			4'b1010: begin
				$write("Branch Equal command");
				if(cicles == 4'b0010) begin
					$write("T2 = Checking condition");
					if(G_cond_check) begin
						$write("T2 = Condition Passed. Select IR Imeddiate, Write on Counter");
						REGBANK_write_address <= 0;
						MUX_select <= 4'b0100; // Ir imeddiate
						PC_in <= 1;
						cicles <= 4'b0011;
					end
					else begin
						$write("T2 = Condition NOT Passed. Done, Increment PC");
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				 end
			 
				 else if(cicles == 4'b0011) begin
					$write("T3 = Done, clear signals, Show Result");
					PC_in <= 0;
					cicles <= 4'b1111;
					MUX_select <= 4'b0011;
					Done <= 1;
				 end
			end
			
// -------------------------------- BRANCH NOT EQUAL ------------------------------------------
			
			4'b1011: begin
				$write("Branch NOT Equal command");
				if(cicles == 4'b0010) begin
					$write("T2 = Checking condition");
					if(!G_cond_check) begin
						$write("T2 = Condition Passed. Select IR Imeddiate, Write on Counter");
						REGBANK_write_address <= 0;
						MUX_select <= 4'b0100; // Ir imeddiate
						PC_in <= 1;
						cicles <= 4'b0011;
					end
					else begin
						$write("T2 = Condition NOT Passed. Done, Increment PC");
						cicles <= 4'b1111;
						PC_increment <= 1;
						Done <= 1;
					end
				 end
			 
				 else if(cicles == 4'b0011) begin
					$write("T3 = Done, clear signals, Show Result");
					PC_in <= 0;
					cicles <= 4'b1111;
					MUX_select <= 4'b0011;
					Done <= 1;
				 end
			end

// -------------------------------- LOAD INSTRUCTION ------------------------------------------		
		
			4'b1100: begin // ld
				$write("Load RAM command");
				if(cicles == 4'b0010) begin
					$write("T2 = Select RY, write data on ADDR");
					REGBANK_write_address <= 0;
					MUX_select <= 4'b0010; // RY
					ADDR_write <= 1; 
					cicles <= 4'b0011;	
				end
				
				else if(cicles == 4'b0011) begin
					$write("T3 = Read on RAM");
					ADDR_write <= 0;
					RAM_write <= 0;
					cicles <= 4'b0100;
				end
				 
				else if(cicles == 4'b0100) begin
					$write("T4 = Read RAM data, write on Rx");
					RAM_fetch <= 1;
					MUX_select <= 4'b0111;
					REGBANK_in <= 1;
					cicles <= 4'b1000;
				end
				
				else if(cicles == 4'b1000) begin
					$write("T5 = Done, clear signals, Increment PC, Show Result");
					RAM_fetch <= 0;
					MUX_select <= 4'b0001;
					REGBANK_in <= 0;
					PC_increment <= 1;
					Done <= 1;
					cicles <= 4'b1111;
				end		
			end
			
// -------------------------------- STORE INSTRUCTION ------------------------------------------

			4'b1101: begin
				$write("Store RAM command");
				if(cicles == 4'b0010) begin
					$write("T2 = Select RY, write data on ADDR");
					REGBANK_write_address <= 0;
					MUX_select <= 4'b0010; // RY
					ADDR_write <= 1; 
					cicles <= 4'b0011;		
				end
				
				else if(cicles == 4'b011) begin
					$write("T3 = Select Rx, write data on DOUT");
					MUX_select <= 4'b0001; // RX
					ADDR_write <= 0;
					DOUT_write <= 1;
					cicles <= 4'b0100;			
				end
				
				else if(cicles == 4'b0100) begin
					$write("T4 = Send Data to RAM");
					DOUT_write <= 0;
					RAM_write <= 1;
					cicles <= 4'b0101;
				end
				
				else if(cicles == 4'b0101) begin
					$write("T5 = Done, clear signals, Increment PC, Show Result");
					MUX_select <= 4'b0001;
					RAM_write <= 0;
					PC_increment <= 1;
					Done <= 1;
					cicles <= 4'b1111;
				end
			end	
		endcase
	end 
 end
 


endmodule
