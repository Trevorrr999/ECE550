# Project: Regfile
**Name:** Trevor(Yuzhe) Zhang 
**NetID:** yz972
**course:** ECE550D
**date:** 10/6/2024

## Project introduction:
This Verilog code implements a 32x32 bit register file, designed for storing and manipulating data in hardware. 
Below is a summary of the main structure and functionality of the code.
**Inputs and Outputs declaration**
**Port Name**|**Input/output**|**Description**
| ---------- | -------------- | --------------- | 
|clock|Input| Clock signal|
|ctrl_writeEnable|Input| Write enable signal|
|ctrl_reset|Input| Reset signal that clears the registers |
|ctrl_writeReg|Input|Specifies the address of the register to write to|
|data_writeReg|Input|The data to be written to the register (32 bits)|
|ctrl_readRegA|Input|Specify the addresses of the registers to read from|
|ctrl_readRegB|Input|Specify the addresses of the registers to read from|
|data_readRegA|Outtput|Data read from the registers (32 bits)|
|data_readRegB|Output|Data read from the registers (32 bits)|
## Contents:

1. dffe

2. register_32

3. decoder_32

4. bufif1_32

5. Regfile

### dffe:

### register_32:

### decoder_32:
The 5-32 decoder converts a 5-bit binary input into one of 32 unique outputs, used for selectively activating an output. Its input range is from 00000 to 11111, corresponding to outputs Y0 to Y31, where only one output is high (1) and the others are low (0). In this design, the decoder_32 is used to converts ctrl_ALUopcode 5 bit inputs into 32 outputs, which is used to decide which result should be connect to the output data ports.
```Verilog code(key part)
    not (n0, ctrl_ALUopcode[0]);
    not (n1, ctrl_ALUopcode[1]);
    not (n2, ctrl_ALUopcode[2]);
    not (n3, ctrl_ALUopcode[3]);
    not (n4, ctrl_ALUopcode[4]);

    
    and (decode_ctrl_ALUopcode[0], n4, n3, n2, n1, n0);
    and (decode_ctrl_ALUopcode[1], n4, n3, n2, n1, ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[2], n4, n3, n2, ctrl_ALUopcode[1], n0);
    and (decode_ctrl_ALUopcode[3], n4, n3, n2, ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[4], n4, n3, ctrl_ALUopcode[2], n1, n0);
    and (decode_ctrl_ALUopcode[5], n4, n3, ctrl_ALUopcode[2], n1, ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[6], n4, n3, ctrl_ALUopcode[2], ctrl_ALUopcode[1], n0);
    and (decode_ctrl_ALUopcode[7], n4, n3, ctrl_ALUopcode[2], ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
…
…
```   
### bufif1_32:

### Regfile:


