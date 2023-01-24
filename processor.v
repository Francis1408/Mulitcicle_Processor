module processor(clock, DIN, Display, Done, ROM_address, RAM_address, RAM_data, RAM_write, MUX_fetch_signal);


/*
  Instruction Type   DataType RegXAddress  Immediate  RegYAddress
		[16:13]			  [12]		[11:9]		[8:0]			[2:0]
*/

// Processor Inputs
 input clock;
 input [16:0] DIN;
 output [16:0] Display;
 output Done;
 output [15:0] ROM_address;
 output [15:0] RAM_address;
 output [15:0] RAM_data;
 output RAM_write;
 output MUX_fetch_signal;
 
// Processor Internal Wires
 wire [16:0] Buswires;
 
// --------------- MODULES INPUTS AND OUTPUTS ----------------
 

// ----IR REG ----
 wire IR_write;
 wire [16:0] IR_out;
 
// ---- CONTROLLER ----
 wire [16:0] FSM_instruction_in;
 wire FSM_IR_write_signal;
 wire FSM_PC_write_signal;
 wire FSM_PC_increment_signal;
 wire FSM_REGBANK_write_signal;
 wire FSM_ALU_add_sub;
 wire FSM_ALU_and;
 wire [2:0] FSM_ALU_barrel_shift;
 wire FSM_A_write_signal;
 wire FSM_G_write_signal;
 wire [3:0] FSM_MUX_select;
 wire FSM_G_cond_check;
 wire FSM_done;
 wire FSM_REGBANK_write_address;
 wire FSM_ADDR_write_signal;
 wire FSM_DOUT_write_signal;
 wire FSM_RAM_write_signal;
 wire FSM_RAM_fetch_signal;
 
// ----- MULTIPLEXER ---
 wire [3:0]  MUX_select;
 wire [16:0] MUX_IR_out;
 wire [15:0] MUX_COUNTER_out;
 wire [15:0] MUX_REGBANK_Rx_out;
 wire [15:0] MUX_REGBANK_Ry_out;
 wire [15:0] MUX_G_out;
 wire [16:0] MUX_out; // Output
 
// ----- COUNTER ----  
 wire [16:0] COUNTER_in;
 wire COUNTER_write;
 wire COUNTER_increment;
 wire [15:0] COUNTER_out; 
 
// ----- REGBANK ---- 
 wire [16:0] REGBANK_in;
 wire REGBANK_write;
 wire [15:0] REGBANK_Rx_out;
 wire [15:0] REGBANK_Ry_out;
 wire REGBANK_write_address;
 
// ----- G REG ----
 wire [15:0] G_in;
 wire G_write;
 wire [15:0] G_out;
 wire G_cond_check;

// ----- A REG ----
 wire [16:0] A_in;
 wire A_write;
 wire [15:0] A_out;
 
// ----- ALU ------
 wire [15:0] ALU_A_in;
 wire [16:0] ALU_BUS_in;
 wire [15:0] ALU_out;
 wire [2:0] ALU_barrel_shift;
 wire ALU_add_sub;
 wire ALU_and;
 
// ----- ADDR ------
 wire [16:0] ADDR_in;
 wire ADDR_write;
 wire [15:0] ADDR_out;
 
// ----- DOUT ------
 wire [16:0] DOUT_in;
 wire DOUT_write;
 wire [15:0] DOUT_out;
 
 
// -------------------- MODULES -------------------------- 
 
// ----IR REG ----
 
 ir_reg _IR_(DIN, clock, IR_write, IR_out);

// ---- CONTROLLER ----

 control _FSM_(clock,
				   FSM_instruction_in, 
					FSM_IR_write_signal, 
					FSM_PC_write_signal, 
					FSM_PC_increment_signal, 
					FSM_REGBANK_write_signal,
					FSM_MUX_select,
					FSM_done,
					FSM_ALU_add_sub,
					FSM_ALU_and,
					FSM_ALU_barrel_shift,
					FSM_A_write_signal,
					FSM_G_write_signal,
					FSM_G_cond_check,
					FSM_REGBANK_write_address,
					FSM_ADDR_write_signal,
					FSM_DOUT_write_signal,
					FSM_RAM_write_signal,
					FSM_RAM_fetch_signal);


// ----- MULTIPLEXER ---

 multiplexer _MUX_(MUX_select, MUX_IR_out, MUX_COUNTER_out, MUX_REGBANK_Rx_out, MUX_REGBANK_Ry_out, MUX_G_out, MUX_out, DIN);
  

// ----- COUNTER ---- 
 
 counter _COUNTER_(clock, COUNTER_in, COUNTER_write, COUNTER_increment, COUNTER_out);
 
 
// ----- REGBANK ----
 
 regBank _REGBANK_(clock, REGBANK_in, REGBANK_write, REGBANK_write_address, REGBANK_Rx_out, REGBANK_Ry_out);
 
// ---- G REG ----

 g_reg _G_(clock, G_in, G_write, G_out, G_cond_check);
 
// ---- A REG ----

 a_reg _A_(clock, A_in, A_write, A_out); 
 
// ---- ARITHIMETIC LOGIC UNIT -----

 alu _ALU_(ALU_A_in, ALU_BUS_in, ALU_out, ALU_add_sub, ALU_and, ALU_barrel_shift);

 ADDR _ADDR_(clock, ADDR_in, ADDR_out, ADDR_write);

 DOUT _DOUT_(clock, DOUT_in, DOUT_out, DOUT_write);

 

// ------- MODULES CONNECTIONS --------

// IR Reg and Control

 assign FSM_instruction_in = IR_out;
 assign IR_write = FSM_IR_write_signal;
 
// MUX and IR Reg
 
 assign MUX_IR_out = IR_out;

// MUX and Control

 assign MUX_select = FSM_MUX_select;
 
// MUX and Counter
 
 assign MUX_COUNTER_out = COUNTER_out;
 
// MUX and REGBANK

 assign MUX_REGBANK_Rx_out = REGBANK_Rx_out;
 assign MUX_REGBANK_Ry_out = REGBANK_Ry_out;
 
// MUX and G Reg

 assign MUX_G_out = G_out;
 
// Reg Bank and Control

 assign REGBANK_write = FSM_REGBANK_write_signal;
 assign REGBANK_write_address = FSM_REGBANK_write_address;
 
// Counter and Control

 assign COUNTER_write = FSM_PC_write_signal;
 assign COUNTER_increment = FSM_PC_increment_signal;
 
// ALU and Control

 assign ALU_add_sub = FSM_ALU_add_sub;
 assign ALU_and = FSM_ALU_and;
 assign ALU_barrel_shift = FSM_ALU_barrel_shift;

// ALU and A reg

 assign ALU_A_in = A_out;
 
// ALU and G reg

 assign G_in = ALU_out;

// G Reg and Control

 assign G_write = FSM_G_write_signal;
 assign FSM_G_cond_check = G_cond_check;
 
// A Reg and Control

 assign A_write = FSM_A_write_signal;
 
// ADDR and Control
  
 assign ADDR_write = FSM_ADDR_write_signal;
 
// DOUT and Control

 assign DOUT_write = FSM_DOUT_write_signal;
 
 
// BusWire

 assign Buswires = MUX_out;
 assign COUNTER_in = Buswires;
 assign REGBANK_in = Buswires;
 assign A_in = Buswires;
 assign ALU_BUS_in = Buswires;
 assign Display = Buswires;
 assign ADDR_in = Buswires;
 assign DOUT_in = Buswires;
 
// Outputs

 assign Done = FSM_done;
 assign ROM_address = COUNTER_out;
 assign RAM_write = FSM_RAM_write_signal;
 assign MUX_fetch_signal = FSM_RAM_fetch_signal;
 assign RAM_address = ADDR_out;
 assign RAM_data = DOUT_out;

endmodule
