module MultiCore_Processor(clock, done, Display_data_HEX0, Display_data_HEX1, Data_bit);

 input clock;
 
 output [6:0] Display_data_HEX0;
 output [6:0] Display_data_HEX1;
 output done;
 output [15:0] Data_bit;

// --------------- MODULES INPUTS AND OUTPUTS ---------------- 
 
// ------ PROCESSOR ------

 wire [16:0] PROC_Display;
 wire PROC_done;
 wire [15:0] PROC_ROM_out;
 wire [16:0] PROC_DIN;
 wire [15:0] PROC_RAM_address;
 wire [15:0] PROC_RAM_data;
 wire PROC_RAM_write;
 wire PROC_MUX_fetch_signal;

// ------ ROM -------

 wire [5:0] ROM_address;
 wire [16:0] ROM_output; 
 

// ------ RAM --------
 
 wire [4:0] RAM_address;
 wire [15:0] RAM_output;
 wire [15:0] RAM_input;
 wire RAM_write;

// ------ EMUX -------
 wire [16:0] EMUX_ROM_output;
 wire [15:0] EMUX_RAM_output;
 wire EMUX_signal;
 wire [16:0] EMUX_out; 
 
 
// ------ DISPLAY ------- 
 wire [16:0] DISP_PROC_in;
 wire [6:0] DISP_out_HEX0;
 wire [6:0] DISP_out_HEX1;
 wire DISP_PROC_done; 
 

 
// -------------------- MODULES --------------------------  

// ---- PROCESSOR ----
 
 processor _PROC_(clock, PROC_DIN, PROC_Display, PROC_done, PROC_ROM_out, PROC_RAM_address, PROC_RAM_data, PROC_RAM_write, PROC_MUX_fetch_signal);
 
 // ----7 SEGMENTS ----

 seven_segments_display _DISP_(DISP_PROC_in, DISP_out_HEX0, DISP_out_HEX1, DISP_PROC_done);
 
 // ---- ROM  ----
 
 ROM _ROM_(ROM_address,clock, ROM_output);
 
 // ---- RAM ----
  
 RAM _RAM_(RAM_address, clock, RAM_input, RAM_write, RAM_output);
 
 // ----EXTERNAL MUX ----
 
 external_mux _EMUX_(EMUX_signal, EMUX_RAM_output, EMUX_ROM_output, EMUX_out);
 
 
 // ------- MODULES CONNECTIONS --------
 
 assign DISP_PROC_in = PROC_Display;
 assign DISP_PROC_done = PROC_done;
 assign Display_data_HEX0 = DISP_out_HEX0;
 assign Display_data_HEX1 = DISP_out_HEX1;
 assign ROM_address = PROC_ROM_out [5:0];
 assign RAM_address = PROC_RAM_address [4:0];
 assign RAM_write = PROC_RAM_write;
 assign RAM_input = PROC_RAM_data;
 assign EMUX_signal = PROC_MUX_fetch_signal;
 assign EMUX_RAM_output = RAM_output;
 assign EMUX_ROM_output = ROM_output;
 assign PROC_DIN = EMUX_out;
 assign done = PROC_done;
 assign Data_bit = PROC_Display [15:0];

endmodule
