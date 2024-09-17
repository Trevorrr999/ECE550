# Project: simple alu design
**Name:** Trevor(Yuzhe) Zhang 
**NetID:** yz972
**course:** ECE550D
**date:** 9/16/2024

## Project introduction:
This simple ALU design includes a 32-bit adder which can function as an adder or a subtrctor.Through the control of input ctrl_ALUopcode, the mode can be switched between add or sub.The top design alu.v invokes many submodule units, which contain a 32_bit_adder unit and 32 mux_2_1 units. Specifically, the 32_bit_adder contains 4 adder_8bit_CSA, made up of half_adder, full_adder and mux_2_1.

**Inputs and Outputs declaration**
**Port Name**|**Input/output**|**Description** 
|data_operandA[31:0]|Input| data A operand Input|
|data_operandB[31:0]|Input| data B operand Input|
|ctrl_ALUopcode[4:0]|Input| ALU command code |
|ctrl_shiftmat[4:0]|Input|Shift amount for SLL and SRA operations(NOT involved in this simple design)|
|data_result[31:0]|Output|Operation Result output|
|isNotEqual|Output|Flag - two data are not equal in subtraction(NOT involved in this simple design)|
|isLessThan|Output|Flag - dataA is less than dataB in subtraction(NOT involved in this simple design)|
|overflow|Output|Flag - overflow when add or subtract|

**Note:** ctrl_shiftmat[4:0],isNotEqual,isLessThan are not involved in this this simple design, each of these ports will be fullfilled in the futrue.

More detailed information is listed as follows.

## Contents:
1. full_adder

2. mux_2_1

3. adder_8bit_CSA

4. adder_32_bit

5. alu

### full_adder:
Full adder contains the carry_in for 1-bit add operation. it computes the sum of 3 inputs and generates the result and carry_out to its outputs.

```Verilog code(key part)
assign Sout = A ^ B ^ Cin;
assign Cout = A&B || B&Cin || A&Cin; 
```

### mux_2_1:
mux_2_1 is the design of 2 to 1 multiplexer. it is a basic unit of the 32-bit adder design and alu design. when the sel input is equal to 1, it will select the A input as the output; Otherwise, it will choose the B input as the result.

```Verilog code(key part)
assign out = sel ? A : B; 
```
### adder_8bit_CSA:
The adder_8_bit_CSA module is an 8-bit Carry Select Adder that computes the sum of two 8-bit inputs, A and B, along with a carry input, Cin. It employs two full adder arrays to calculate results for both carry scenarios (Cin = 1 and Cin = 0) and uses multiplexers to select the final sum and carry outputs based on the value of Cin. This design minimizes delay and enhances speed, making it suitable for use in digital circuits like Arithmetic Logic Units (ALUs).

### adder_32_bit:
The adder_32_bit module is a 32-bit adder that employs four 8-bit Carry Select Adder (CSA) instances to compute the sum of two 32-bit inputs, A and B, along with a carry input, Cin. The four 8-bit segments are connected in series, with the carry output of each lower segment serving as the carry input for the next higher segment. This design facilitates efficient carry propagation, minimizing overall delay.

Compared to a standard design, this project also aims to implement overflow detection. To achieve this, this adder_32_bit module incorporate an additional output for the carry-out signal from the second most significant bit, which is specifically reserved for overflow detection in the ALU design.
```Verilog code(key part for reserving the carry out of the first most significant bit and the second)
        else if(i == 3)
        begin
            adder_8_bit_CSA u(
            .A(A[8*i+7: 8*i]),
            .B(B[8*i+7: 8*i]),
            .Cin(sel_temp[i-1]),
            .Cout(cout),
            .Sout(out[8*i+7: 8*i]),
            .Cout_1(cout_1)
            );        
        end
```
### alu:
This simple ALU module performs arithmetic addition and subtraction operations on two 32-bit operands based on control signals. It handles both addition and subtraction, while also detecting overflow conditions.

In this design, the least significant bit of ctrl_ALUopcode(ctrl_ALUopcode[0]) determines which operation the ALU will execute. In addition mode, the ALU directly adds data_operandA and data_operandB. In subtraction mode, the ALU calculates the difference by using the 2's complement of data_operandB, which involves inverting it and adding 1. This requires the use of inv_B (a wire holding the bitwise inversion of data_operandB) and data_valid_B (a wire that holds either the original or inverted version of data_operandB).
```Verilog code(key part for creating inverted data)
   wire [31:0] temp_result1,temp_result2;
   //use to judge the overflow
   wire Co,Co_1;

   //use to invert each bit of B
   wire [31:0] inv_B;
   assign inv_B = ~data_operandB;
   //use to connect the data which are used to calcutate
   wire [31:0] data_valid_B;
```

To select data_valid_B, the design employs a 2-to-1 multiplexer (mux_2_1). The ctrl_ALUopcode[0] is connected to the selection input of the multiplexer. When ctrl_ALUopcode[0] is 0, the original data_operandB is output; when it is 1, the inverted data is used for the calculation.
```Verilog code(key part for creating inverted data)
   //use to choose the data involving the calculation
   genvar i;
   generate
      for(i = 0; i <= 31; i = i + 1)
      begin:uint_inv_B_B
         mux_2_1 u(
            .A(inv_B[i]),
            .B(data_operandB[i]),
            .sel(ctrl_ALUopcode[0]),
            .out(data_valid_B[i])
         );
      end
   endgenerate
```   

Furthermore, ctrl_ALUopcode[0] is also connected to the carry-in (cin) of the 32_bit adder. When ctrl_ALUopcode[0] is 1, the calculation requires the two's complement of data_operandB, which is achieved by adding the inverted data and 1. By connecting ctrl_ALUopcode[0] to the carry-in, this design effectively resolves the requirement for two's complement in subtraction operations.
    
#### the overflow detection:
As mentioned in the adder_32_bit section, this design intentionally reserves the carry-out signal from the second most significant bit (MSB) for overflow detection. The overflow detection mechanism utilizes the carry-out signals from both the first and second MSBs. By employing an XOR gate, the design determines whether an overflow has occurred. If the carry-out signals from these two bits differ, it indicates that an overflow has happened during the arithmetic operation.
```Verilog code(key part)
assign overflow =  Co^Co_1 ? 1 : 0;
```



