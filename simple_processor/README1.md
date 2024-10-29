# Simple Processor Design
* Author: Yuzhe(Trevor) Zhang, Siying (Curt) Chen
* NetID: yz972, sc962
* Time: 2024/10/29
* Term: 2024 Fall
## Environment
Quartus Prime 17.0 Lite Edition
## Introduction
This project implements a simple single-cycle 32-bit processor using the given skeleton. 

The project contains:<br>
**1. Program Counter: to indicate the next instruction.<br><br>
2. Instruction Memory(imem): contains program instructions.<br><br>
3. Register File(regfile): 32 32-bit registers which store data to be used in the processor.<br><br>
3. ALU: doing calculations, and transferring data to other parts of the whole processor.<br><br>
4. Data Memory(dmem): data stored outside of the processor, connecting with ALU and regfile.<br><br>
5. Other connecting logic: contains multiplexers, ANG gates, immediate generator etc.**

## Background
Processor is the core component of a computer, responsible for interpreting and executing instructions stored in memory. Our simple processor applies MIPS ISA. For now, this simple processor supports R-type and I-type instructions(add, sub, and, or, all, sra, sw, lw, addi, sw, lw).


## Project Structure
![image](https://github.com/user-attachments/assets/af926bda-5ff6-4ed7-b1fe-800c090fa3e8)

Our processor is based on this schematic diagram, which contains 9 core modules.<br><br>

 * __skeleton__: The basic scaffold for connecting each part of the processor.

|**Paratmeters**|**Type**|**Detail**|
|----|----|----|
|clock|Input|clock signal given|
|reset|Input|reset signal|
|imem_clock|Output|clock period for imem|
|dmem_clock|Output|clock period for dmem|
|processor_clock|Output|clock period for the processor block|
|regfile_clock|Output|clock period for register file|

 ><br>This module provides interfaces to connect to memory blocks.
><br> Inside this module, we implemented:<br>
><br> __1. Clock Generation__:  The main input clock is divided using the clock divider modules(clk_divide_2, clk_divide_4) to produce the clock signals whose periods are divided by 2 and 4. **imem_clock** uses the given clock signal, **dmem_clock** is 1 time faster than the original clock, which means it uses **clk_div2**, and for **processor_clock** and **regfile_clock**, they are both **clk_div4**, which means they are 2 times faster than the orginal clock.<br>
><br> __2.IMEM__: The instruction Memory(imem) is instantiated inside this module. Our **IMEM** contains 4096(2^12) instructions. The inputs are **address_imem**(12bits), and **imem_clock**. A 32-bit data **q_imem** is taken as output, which indicates raw instructions.<br>
><br> __3.DMEM__: The dmem module has 4096 data depth, which is instantiated with **address_dmem**(address to be reached), a clock input **dmem_clock**, a **data** input to indicate the data to be written into the memory, a write enable signal **wren** to indicate whether the dmem accepts writing, and a data output **q_dmem** which implies the data extracted from the **address_dmem**.<br>
><br> __4.Register File__: The register module represents a register file which provides multiple inputs and outputs.<br>
><br> __5.Processor Core__: The processor core connects to other components through control and data logic.

* __dffe(D Flip-Flops with Enable)__: Single d-flip flop with an enable signal, used to form the reg32 module.
  
|**Parameters**|**Type**|**Detail**|
|----|----|----|
|d|Input|Data Input 1|
|clk|Input|Clock signal|
|en|Input|Enable signal|
|clr|Input|Reset signal|
|q|Output|Data output|
  ><br>This module implements a D flip-flop with an enable signal. When the enable signal is high, the D flip-flop stores the input data and holds it until the next clock edge. If the enable signal is low, the D flip-flop keeps its previous state.<br><br>
  
* __register_12__: Single 12-bit register.

|**Paratmeters**|**Type**|**Detail**|
|----|----|----|
|en|Input|Enable signal|
|clk|Input|Clock signal|
|clr|Input|Reset signal|
|d [11:0]|Input|Data input|
|q [11:0]|Output|Data ouput|

 ><br>This module is combined of 12 D flip-flops with enable signals, creating a 12-bit wide register. The internal signals includes: **clk_sys**, **en_sys**, and **clr_sys** we implemented two for-loops, the first assigns the input **clk**, **en** and **clr** signals to every bit of the **clk_sys**, **en_sys**, and **slr_sys** arrays. This ensures each bit uses the same clock. The second loopo instantiates one **dffe** for each bit.<br><br>
 
* __regfile__: Implements a 32-register file with 32-bit wide registers, supporting two read ports and one write port.

|**Paratmeters**|**Type**|**Detail**|
|----|----|----|
|clock|Input|Clock signal|
|ctrl_writeEnable|Input|Write enable signal|
|ctrl_reset|Input|Reset signal|
|ctrl_writeReg|Input|Write signal that specify which reg to write|
|ctrl_readRegA|Input|Read signal that specify which reg to be read to A|
|ctrl_readRegB|Input|Read signal that specify which reg to be read to B|
|data_writeReg|Input|Data to be written|
|data_readRegA|Ouput|Data to be read to A|
|data_readRegB|Ouput|Data to be read to B|

 ><br>Firstly, we use the **ctrl_writeReg**, **ctrl_readRegA**, and **ctrl_readRegB** to access specific registers in the register file. Then, The signals __ctrl_writeReg__ and __ctrl_writeEnable__ control the write operation. If __ctrl_writeEnable__ is high and __ctrl_writeReg__ is not zero, the specified register in __ctrl_writeReg__ is enabled for writing, and the data in __data_writeReg__ is stored in that register.<br><br>
Also, if **ctrl_reset** is asserted, a for loop is used to iterate through all 32 registers, setting each one to zero. This loop assures the entire register file is all-zeros when reset is 1.<br><br>
To read from register file, we use **ctrl_readRegA** and **ctrl_readRegB** as index to fetch the registers. The extracted data are assigned to **data_readRegA** and **data_readRegB**.<br><br>

* __ALU__: Arithmetic Logic Unit, used for calculation and logic processing.

|**Paratmeters**|**Type**|**Detail**|
|----|----|----|
|data_operandA[31:0]|Input|Data Input 1|
|data_operandB[31:0]|Input|Data Input 2|
|ctrl_ALUopcode[4:0]|Input|Operation code|
|ctrl_shiftmat[4:0]|Input|Indicate how many bits to be shifted|
|data_result[31:0]|Output|Data output|
|isNotEqual|Output|Indicate if *data_operandA* is not equal to *data_operandB*|
|isLessThan|Output|Indicate if *data_operandA* is less than *data_operandB*|
|overflow|Output|Overflow detection bit|
  ><br>This module is a 32-bit ALU that performs multiple operations based on control signals. It accepts 2 input operands: **data_operandA** and **data_operandB** and a control opcode **ctrl_ALUopcode** that determines the operation to be implemented. The **ctrl_shiftamt** tells the num of bits to be shifted. The output **data_result** is the calculated result. There are also 3 signals: **isNotEqual**, **isLessThan**, and **overflow** which separately tell whether the two operands are different, or A is less than B, and whether there is an overflow occurs. <br><br>

* __sign_extend__: A module that extends a 17-bit input (immed) to a 32-bit signed output (immed_sx).

|**Paratmeters**|**Type**|**Detail**|
|----|----|----|
|immed [16:0]|Input|Data to be extended|
|immed_sx [31:0]|Output|Sign-extended output|

 ><br>This module copies the sign bit of input data **immed** to the higher 15 bits of the output, and the rest stays the same.<br><br>
* __clk_divide_2__: A module that output the clock signal with half the frequency of input clock.

|**Paratmeters**|**Type**|**Detail**|
|----|----|----|
|clk|Input|Input clock to be divided|
|rst|Input|The reset signal|
|clk_out|Output|The output clock|

 ><br>This module toggles **clk_out** on every positive edge of **clk**, generating the half frequency of input clock.<br><br>
 
 * __clk_divide_4__: A module that output the clock signal with frequency divided by 4 of input clock.

|**Paratmeters**|**Type**|**Detail**|
|----|----|----|
|clk|Input|Input clock to be divided|
|rst|Input|The reset signal|
|clk_out|Output|The output clock|

 ><br>This module uses a 2-bit counter to keep track of cycles and toggles the output clock when the counter reaches 3. The reset functionality allows **clk_out** and the counter to be reset to a known state, making it useful in designs requiring synchronized reset behavior.<br><br>
 
 * __processor__:  A module that generates control signals by decoding instructions to identify different operation types (such as R-type instructions, immediate addition, load, and store).

| **Parameters**       | **Type** | **Detail**                                   |
|----------------------|----------|-----------------------------------------------|
| clock                | Input    | The master clock                             |
| reset                | Input    | A reset signal                               |
| address_imem [11:0]  | Output   | The address of the data to get from imem     |
| q_imem [31:0]        | Input    | The data from imem                           |
| address_dmem [11:0]  | Output   | The address of the data to get or put in dmem|
| data [31:0]          | Output   | The data to write to dmem                    |
| wren                 | Output   | Write enable for dmem                        |
| q_dmem [31:0]        | Input    | The data from dmem                           |
| ctrl_writeEnable     | Output   | Write enable for regfile                     |
| ctrl_writeReg [4:0]  | Output   | Register to write to in regfile              |
| ctrl_readRegA [4:0]  | Output   | Register to read from port A of regfile      |
| ctrl_readRegB [4:0]  | Output   | Register to read from port B of regfile      |
| data_writeReg [31:0] | Output   | Data to write to regfile                     |
| data_readRegA [31:0] | Input    | Data from port A of regfile                  |
| data_readRegB [31:0] | Input    | Data from port B of regfile                  |
 ><br>The processor uses an ALU for arithmetic operations, supports overflow detection, and writes results back to the register file or data memory, with a specific register $30 handling overflow cases. The program counter increments each cycle to execute instructions sequentially.<br><br>





  



  


