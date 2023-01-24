module regBank(clock, REGBANK_in, REGBANK_write, REGBANK_write_address, REGBANK_Rx_out, REGBANK_Ry_out);

 input clock;
 input [16:0] REGBANK_in;
 input REGBANK_write;
 input REGBANK_write_address;
 
 output [15:0] REGBANK_Rx_out;
 output [15:0] REGBANK_Ry_out;
 
 // Register Bank
 
 reg [15:0] reg_bank [6:0];
 
 // Internal wires
 
 reg [2:0] Rx_address;
 reg [2:0] Ry_address;
 
 
 
 initial begin
 
 $readmemb("RegInit.txt", reg_bank);
 
 end
 
 
 always @(posedge clock) begin
 
	if(REGBANK_write_address) begin
	   $write("Setting Rx Address");
		Rx_address <= REGBANK_in[11:9];
		if(!REGBANK_in[12:12]) begin
			$write("Setting Ry Address");
			Ry_address <= REGBANK_in[2:0];
		end
	end
 
	if(REGBANK_write) begin
	   $write("Writing data on Rx");
		reg_bank[Rx_address] <= REGBANK_in [15:0];
	end
 
 end

assign REGBANK_Rx_out = reg_bank[Rx_address];
assign REGBANK_Ry_out = reg_bank[Ry_address];

endmodule
