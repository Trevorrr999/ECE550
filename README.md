# Project: full alu design
**Name:** Trevor(Yuzhe) Zhang 
**NetID:** yz972
**course:** ECE550D
**date:** 9/22/2024

## Project introduction:
This ALU design includes essential functionalities, including addition and subtraction, logical left shift, arithmetic right shift, bitwise AND, and bitwise OR.Through the control of input ctrl_ALUopcode, the mode can be switched among these modes. Design also incorporates overflow detection and input data size comparison checks during addition and subtraction operations.The top design full_alu.v invokes many submodule units, which contain a 32_bit_adder unit, 32 mux_2_1 units, and etc.More detailed information is listed as follows.

**Inputs and Outputs declaration**
**Port Name**|**Input/output**|**Description**
| ---------- | -------------- | --------------- | 
|data_operandA[31:0]|Input| data A operand Input|
|data_operandB[31:0]|Input| data B operand Input|
|ctrl_ALUopcode[4:0]|Input| ALU command code |
|ctrl_shiftmat[4:0]|Input|Shift amount for SLL and SRA operations|
|data_result[31:0]|Output|Operation Result output|
|isNotEqual|Output|Flag - two data are not equal in subtraction|
|isLessThan|Output|Flag - dataA is less than dataB in subtraction|
|overflow|Output|Flag - overflow when add or subtract|

## Contents:
1. full_adder

2. mux_2_1

3. adder_8bit_CSA

4. adder_32_bit

5. decoder_32

6. SLL

7. SRA

8. Bitwise_and

9. Bitwise_or

10. overflow detection

11. isNotEqual

12. isLess     

13. full_alu

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
![image](https://github.com/user-attachments/assets/f57694b4-c0cb-4346-96fc-2479523843c3)

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

### decoder_32:
The 5-32 decoder converts a 5-bit binary input into one of 32 unique outputs, used for selectively activating an output. Its input range is from 00000 to 11111, corresponding to outputs Y0 to Y31, where only one output is high (1) and the others are low (0). In this design, the decoder_32 is used to converts ctrl_ALUopcode 5 bit inputs into 32 outputs, which is used to decide which result should be connect to the output data ports.
```Verilog code(key part)
assign decode_ctrl_ALUopcode[0]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[1]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[2]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0];
…
…
```   

### sll:
This 32-bit logical left shift (SLL) module in Verilog uses a structured approach to perform left shifts based on a 5-bit control signal (ctrl_shiftamt). The design consists of multiple generate for loops, each implementing 1-bit, 2-bit, 4-bit, 8-bit, and 16-bit shifts using 2-to-1 multiplexers, and each stage of shifting builds upon the previous one, ultimately allowing the module to produce the correct shifted output (data_result) based on the specified shift amount.
![image](https://github.com/user-attachments/assets/e423910b-bc8c-4cc0-9714-ebd88fb2bb9b)
```Verilog code(key part)
// 1-bit shift
for(a = 0; a<= width -1; a = a + 1)
begin: unit_1_bit_shift
if(a == 0)
begin
    mux_2_1 u(
        .A(0),
        .B(data_operandA[a]),
        .sel(ctrl_shiftamt[0]),
        .out(temp0[a])
    );
end
else
begin
    mux_2_1 u(
        .A(data_operandA[a-1]),
        .B(data_operandA[a]),
        .sel(ctrl_shiftamt[0]),
        .out(temp0[a])
    );
end
end
// 16-bit shift
for(e = 0;e<= width - 1; e = e + 1)
 begin: unit_16_bit_shift
          if(e <= 15)
          begin
                mux_2_1 u(
                         .A(0),
                         .B(temp3[e]),
                         .sel(ctrl_shiftamt[4]),
                         .out(data_result[e])
                );            
          end
          else
          begin
                mux_2_1 u(
                         .A(temp3[e-16]),
                         .B(temp3[e]),
                         .sel(ctrl_shiftamt[4]),
                         .out(data_result[e])
                );            
          end        
 end
…
```

### sra:
The principle of the 32-bit arithmetic right shift (SRA) module is similar to that of the logical left shift (SLL). The main difference lies in the handling of the sign bit. During a right shift, the sign bit (most significant bit) is copied into the newly shifted-in position to maintain the consistency of the sign for negative numbers. As a result, for negative numbers, the output after shifting will remain negative.
```Verilog code(key part)
for(a = 0; a<= width -1; a = a + 1)
    begin: unit_1_bit_shift
        if(a == 5'd31)
        begin
            mux_2_1 u(
                .A(1),
                .B(data_operandA[a]),
                .sel(ctrl_shiftamt[0]),
                .out(temp0[a])
            );
        end
        else
        begin
            mux_2_1 u(
                .A(data_operandA[a+1]),
                .B(data_operandA[a]),
                .sel(ctrl_shiftamt[0]),
                .out(temp0[a])
            );
        end
    end
```

### Bitwise_and:
The Bitwise AND operation is a fundamental binary operation that compares corresponding bits of two binary numbers, producing a new binary number where each bit is set to 1 only if both input bits are 1; otherwise, it is set to 0. In this design, a generate-for loop utilizes 32 AND gates to implement the Bitwise AND function for the inputs data_operandA and data_operandB.
```Verilog code(key part)
genvar i;
generate 
    for(i = 0; i <= width-1; i = i + 1)
    begin: unit_and
        and uint (
            data_result[i],
            data_operandA[i],
            data_operandB[i]
        );
    end
endgenerate
```

### Bitwise_or:
The Bitwise OR operation is another fundamental binary operation that compares each corresponding bit of two binary numbers and produces a new binary number where each bit is set to 1 if at least one of the input bits is 1; otherwise, it is set to 0.
```Verilog code(key part)
genvar i;
generate 
    for(i = 0; i <= width-1; i = i + 1)
    begin: unit_and
        or uint (
            data_result[i],
            data_operandA[i],
            data_operandB[i]
        );
    end
endgenerate
```

### the overflow detection:
As mentioned in the adder_32_bit section, this design intentionally reserves the carry-out signal from the second most significant bit (MSB) for overflow detection. The overflow detection mechanism utilizes the carry-out signals from both the first and second MSBs. By employing an XOR gate, the design determines whether an overflow has occurred. If the carry-out signals from these two bits differ, it indicates that an overflow has happened during the arithmetic operation.
```Verilog code(key part)
assign overflow =  Co^Co_1 ? 1 : 0;
```
### isNotEqual:
The isNotEqual output port detects whether the two inputs are the same during a subtraction operation. This functionality can be divided into two steps: First, if the operation is not in subtraction mode, it should generate a signal of 0. If it is in subtraction mode, a second check is performed to determine whether data_result is not equal to 0. If data_result is indeed not equal to 0, then isNotEqual should output 1; otherwise, it should output 0.
To determine whether the result is equal to zero, a bitwise OR operation is performed on each bit of the 32-bit data_result. If the outcome of this operation is 1, it indicates that the input should not be zero.
```Verilog code(key part)
//judge IsNotEqual
assign isNotEqual = (decode_ctrl_ALUopcode[1]) ? (|data_result_add_or_sub)? 1 : 0 : 0;
```
### isLess:

The isLessThan output port detects whether the input data_operandA is smaller than data_operandB during a subtraction operation. This process is relatively complex, as illustrated in the following figure.
![image](https://github.com/user-attachments/assets/c9dc5473-466f-449e-a26a-f0a735d95fae)

The first step is to determine whether the ALU is in subtraction mode; if it is not, the isLessThan port should be set to 0. Next, check if the Overflow signal is 1. If it is, evaluate the sign bit of data_result: if the sign bit is 1, it indicates an overflow; otherwise, it indicates an underflow. In the case of an overflow, this means that data_operandA is smaller than data_operandB. If there is no overflow, check the sign bit of data_operandA. If the sign bit is 1, it indicates that data_operandA is smaller than data_operandB.
```Verilog code
assign isLessThan = (decode_ctrl_ALUopcode[1]) ? (overflow ? (data_operandA[31] ? 1 : 0): data_result[31] ? 1 : 0): 0; 
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
    


## Reference:
[1] Carry Select Adder’s Principles and design (no date) www.zhihu.com. Available at: https://zhuanlan.zhihu.com/p/102207162 (Accessed: 16 September 2024). 

