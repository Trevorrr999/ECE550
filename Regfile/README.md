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
the DFFE module implements a D flip-flop with enable and clear functionalities. It stores the input data d on the positive edge of the clock clk when the enable signal en is high. If the clear signal clr is activated, it resets the output q to 0. The module initializes q to 0 and ensures that the output reflects the input only when enabled, providing a controlled data storage mechanism in digital circuits.
```Verilog code(key part)
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 1'b0;
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
```

### register_32:
The register_32 module implements a 32-bit register using an array of D flip-flops, where each bit of the 32-bit input data d is stored in a separate flip-flop. Controlled by the clock signal clk, enable signal en, and clear signal clr, the module allows data storage when en is high and resets all bits to 0 when clr is activated. It generates 32 instances of the dffe_ref flip-flop, ensuring synchronized operation, and provides a 32-bit output q that reflects the stored data based on the input conditions.
```Verilog code(key part)
generate
    for(i = 0; i <=width -1; i = i+1)
    begin: gen_sys_clk
        assign clk_sys[i] = clk;
        assign en_sys [i] = en;
        assign clr_sys [i] = clr; 
    end
	 
    for(j = 0; j<= width -1; j = j+1)
    begin: gen_dffe
        dffe_ref u(
            .d(d[j]),
            .clk(clk_sys[j]),
            .q(q[j]),
            .en(en_sys[j]),
            .clr(clr_sys[j])
        );
    end
endgenerate
```

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
The bufif1_32bit module implements a 32-bit tri-state buffer, allowing individual bits of the input data data_in to be selectively passed to the output data_out based on the enable signal. Each bit is processed using a bufif1 gate, which connects the corresponding bit of data_in to data_out when enable is high, effectively enabling the output, and disconnects it (high-impedance state) when enable is low. This module uses a generate loop to create 32 instances of the tri-state buffer, facilitating controlled data flow in digital circuits while conserving space and resources.
```Verilog code(key part)
 generate
        for (i = 0; i < 32; i = i + 1) begin : tri_state_buffer
            bufif1 (data_out[i], data_in[i], enable);
        end
    endgenerate
```

### Regfile:
regfile module implements a 32-entry register file, allowing for read and write operations on 32-bit registers controlled by various input signals. It features a clock input clock, a write enable signal ctrl_writeEnable, and a reset signal ctrl_reset. The module includes control inputs to specify which registers to read from (ctrl_readRegA, ctrl_readRegB) and write to (ctrl_writeReg), along with a 32-bit data input data_writeReg.

The architecture consists of:
Decoders: Three 5-to-32 bit decoders to convert the 5-bit register addresses into 32-bit enable signals for reading and writing operations.
Register Array: An array of 32 registers (register_32), where the first register is initialized to zero, and others can be updated with data_writeReg when enabled.
Tri-State Buffers: Two sets of tri-state buffers (bufif1_32bit) to output the contents of the registers specified by the read control signals, allowing for simultaneous read operations.

#### Decoder:
The module utilizes three decoders to decode the addresses for writing and reading (Reading_regA and Reading_regB). The outputs of these decoders determine which registers to write to or read from. Additionally, these outputs, combined with the enable signal, control the enable logic of the tri-state buffers, effectively managing the address logic in this design. This approach ensures precise and efficient data access within the register file.

```Verilog code(key part)
   decoder_32 uint1 (
    .ctrl_ALUopcode(ctrl_readRegA),
    .decode_ctrl_ALUopcode(decode_ctrl_readRegA)
   );
   decoder_32 uint2 (
    .ctrl_ALUopcode(ctrl_readRegB),
    .decode_ctrl_ALUopcode(decode_ctrl_readRegB)
   );
   decoder_32 uint3 (
    .ctrl_ALUopcode(ctrl_writeReg),
    .decode_ctrl_ALUopcode(decode_ctrl_writeReg)
   );
```

#### Register Array:
This module is constructed using the submodule register_32, instantiated as 32 separate entities. The first register, designated as $0, is always set to store 32'b0, regardless of the data intended for writing. For the other registers, they will read from or write data according to the specified operation instructions, ensuring proper data management and functionality in the register file.
```verilog code
 if(i == 0)
        begin
        register_32 u
        (
            .d(32'b0),
            .clk(clock),
            .clr(ctrl_reset),
            .q(result[i]),
            .en(Enable[i])
        );
        end
        else
        begin
        register_32 u 
        (
            .d(data_writeReg),
            .clk(clock),
            .clr(ctrl_reset),
            .q(result[i]),
            .en(Enable[i])
        );
        end
```

#### Tri-State Buffers:
The tri-state buffer plays a crucial role in optimizing resource usage for the read control logic. It replaces multiplexers, using the enable signal and the decoder's output to determine which output should be activated. When one array of tri-state buffers is enabled, the others remain inactive, effectively controlling which read data is accessed. This design successfully streamlines the process of managing read operations while conserving resources.

