# Multicycle_Processor

### by Francisco Abreu & Vitor Laguardia

Multicycle processor built during the lab classes of Computer Architecture. The overall design contains the following features:



![project_img1](https://github.com/Francis1408/Mulitcycle_Processor/blob/main/img/Desenho_Projeto_2.png)


PROCESSOR: Module in charge of executing the instructions came from ROM;
ROM: Module that contains 17-bits executable instructions;
RAM: 5-bits length module that saves 16-bits data;
EXTERNAL MUX: Module in charge of controlling the Processor input on each clock cycle;
7 SEGMENTS DISPLAY: Module that converts binary data to decimal format for a Cyclone II FPGA


### The Processor

As internal modules, the processor contains the following ones:



![project_img1](https://github.com/Francis1408/Mulitcycle_Processor/blob/main/img/Desenho_Projeto.png)

IR: Register that saves the current instruction;
FSM: State Machine that controls the instructions steps. For each one, the module triggers certain signals, which will dictate what the others modules must do on that cycle;
COUNTER: Register that saves the following ROM address;
REG BANK: Array of registers for data storage;
ALU: Arithmetic Logic Unit responsible of executing arithmetic operations; 
A: Register that saves one of the ALU inputs;
G: Register that saves the latest ALU result;
ADDR: Register that saves RAM's address, which can be used either for load or store instructions.
DOUT: Register that saves RAM's data, which will be used for a store instruction.


The processor was designed to support the following instructions:


| INSTRUCTION    |     COMMAND            |     TAG   |
|----------------|------------------------|-----------|
|       mv       |  Rx <- OP2 	          |    0000   |
|       mvt      |  Rx <- #D              |    0001   |
|       add      |  Rx <- Rx + OP2        |    0010   |
|       sub      |  Rx <- Rx - OP2        |    0011   |
|       and      |  Rx <- Rx & OP2        |    0100   |
|       lsl      |  Rx <- Rx << OP2       |    0101   |
|       lsr      |  Rx <- Rx >> OP2       |    0110   | 
|       asr      |  Rx <- Rx >>> OP2      |    0111   |
|       ror      |  Rx <- Rx <<>> OP2     |    1000   |
|        b       |  Pc <- label           |    1001   |
|       beq      |  if(G = 0)Pc <- label  |    1010   |
|       bne      |  if(G != 0)Pc <-label  |    1011   |
|       ld       |  Rx <- [Ry]            |    1100   |
|       st       |  [Ry] <- Rx            |    1101   |

 The instructions above require more than one cycle to be completed. Thus, all of them triggers multiple signals, in order to make it work. 
 The following table shows the procedure, cycle by cycle, of each instruction:


 <table>
  <tr>
    <th>Instruction</th>
    <th>T0</th>
    <th>T1</th>
    <th>T2</th>
    <th>T3</th>
    <th>T4</th>
    <th>T5</th>
    <th>T6</th>
  </tr>
  <tr>
    <td>mv</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td>  
    <td>Controller reading</br>Write on Rx</br><b>RegBankWrite</b></br><b>Select Ry</b></td> 
    <td>Show the output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>mvt</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br>Write on Rx</br><b>RegBankWrite</b></br><b>Select Ry</b></td> 
    <td>Show the output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>add</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br>Write on A</br><b>Ain</b></br><b>Select Rx</b></td> 
    <td>Execute operation at ALU</br>Write on G</br><b>Gin</b></br><b>Seleciona Ry</b></br><b>AddSub</b></td>
    <td>Load data from G and write on Rx</br><b>RegBankWrite</b></td>
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>sub</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br>Write on A</br><b>Ain</b></br><b>Select Rx</b></td> 
    <td>Execute operation at ALU</br>Write on G</br><b>Gin</b></br><b>Seleciona Ry</b></br><b>AddSub</b></td>
    <td>Load data from G and write on Rx</br><b>RegBankWrite</b></td>
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>and</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b>
    <td>Wait Cycle</td> 
    <td>Controller reading</br>Write on A</br><b>Ain</b></br><b>Select Rx</b></td> 
    <td>Execute operation at ALU</br>Write on G</br><b>Gin</b></br><b>Seleciona Ry</b></br><b>Alu_and</b></td>
    <td>Load data from G and write on Rx</br><b>RegBankWrite</b></td>
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>ld</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br><b>ADDR_in</b></br><b>Select Ry</b></td> 
    <td>Send address to RAM and read data</td>
    <td>Save value in Rx</br><b>Select_DIN</b></br><b>Ram_fetch</b></br><b>RegBankWrite</b></td>
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
   <tr>
    <td>st</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br>Write on ADDR</br><b>ADDR_in</b></br><b>Select Ry</b></td> 
    <td>Write on DOUT</br><b>DOUT_in</b></td>
    <td>Send data to RAM</br><b>WR_Ram</b></td>
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>b</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br>Write on Counter</br><b>Cont_in</b></td> 
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>beq</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br>Check G</br><b>f(cond) => Cont_in</b></td> 
    <td>Exibe output</br><b>Done</b></td>
  </tr>
  <td>bne</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br>Check G</br><b>f(cond) => Cont_in</b></td> 
    <td>Exibe output</br><b>Done</b></td>
  </tr>
  <tr>
    <td>B_LSL</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br><b>Write on A </b></br><b>Ain</b></br><b>Select Rx</b></td> 
    <td>Execute operation at ALU</br>Write on G</br><b>Barrel_Mux = 00</b></td>
    <td>Load data from G and write on Rx</br><b>RegBankWrite</b></br><b>Done</b></td>
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>B_LSR</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br><b>Write on A </b></br><b>Ain</b></br><b>Select Rx</b></td> 
    <td>Execute operation at ALU</br>Write on G</br><b>Barrel_Mux = 01</b></td>
    <td>Load data from G and write on Rx</br><b>RegBankWrite</b></br><b>Done</b></td>
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
  <tr>
    <td>B_LSR</td>
    <td>Read instruction at ROM</td>
    <td>Load instruction on IR <br/>Define Rx and Ry<br/><b>IRin</b><br/><b>RegBankWrite_Address</b></td>
    <td>Wait Cycle</td> 
    <td>Controller reading</br><b>Write on A </b></br><b>Ain</b></br><b>Select Rx</b></td> 
    <td>Execute operation at ALU</br>Write on G</br><b>Barrel_Mux = 10</b></td>
    <td>Load data from G and write on Rx</br><b>RegBankWrite</b></br><b>Done</b></td>
    <td>Exibe output</br><b>PcIncrement</b></br><b>Done</b></td>
  </tr>
</table>

The codification for each output of the inner Multiplexer is also displayed below:

| DATA OUTPUT                   |     MUX SELECT         |    
|-------------------------------|------------------------|
|       Reg IR data             |       0000	           |     
|       Reg RX data             |       0001             |   
|       Reg RY data             |       0010             |    
|       Counter data            |       0011             |    
|       Reg IR Immediate data   |       0100             |    
|       Reg IR Immediate (Top)  |       0101             |    
|       Reg G data              |       0110             |  
|       DIN data                |       0111             |   
