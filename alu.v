module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31 : 0] data_operandA, data_operandB;
   input [4 : 0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31 : 0] data_result;
   output isNotEqual, isLessThan, overflow;
   
   // YOUR CODE HERE //
   //use to connect the result to the final result
   wire [31 : 0] temp_result1,temp_result2;
   //use to judge the overflow
   wire Co,Co_1;

   //use to invert each bit of B
   wire [31 : 0] inv_B;
   assign inv_B = ~data_operandB;
   //use to connect the data which are used to calcutate
   wire [31 : 0] data_valid_B;
   //use to hold add or subtract's result
   wire [31 : 0] data_result_add_or_sub;   
   //use to hold bitwise_and's result
   wire [31 : 0] data_result_bitwise_and;
   //use to hold bitwise_and's result
   wire [31 : 0] data_result_bitwise_or;
   //use to hold sll result
   wire [31 : 0] data_result_sll;
   //use to hold sra result
   wire [31 : 0] data_result_sra;
   // use to hold ctrl_ALUopcode's decode result
   wire [31 : 0] decode_ctrl_ALUopcode;
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
//adder and subtractor
   adder_32_bit unit_adder(
      .A(data_operandA),
      .B(data_valid_B),
      .Cin(ctrl_ALUopcode[0]),
      .out(data_result_add_or_sub),
      .cout(Co),
      .cout_1(Co_1)
   );

// bitwise_and
    bitwise_and unit_b_and(
        .data_operandA(data_operandA),
        .data_operandB(data_operandB),
        .data_result(data_result_bitwise_and)
    );
// bitwise_or
    bitwise_or unit_b_or(
        .data_operandA(data_operandA),
        .data_operandB(data_operandB),
        .data_result(data_result_bitwise_or)
    );
// sll
    sll unit_sll(
        .data_operandA(data_operandA),
        .ctrl_shiftamt(ctrl_shiftamt),
        .data_result(data_result_sll)
    );
// sra
    sra unit_sra(
        .data_operandA(data_operandA),
        .ctrl_shiftamt(ctrl_shiftamt),
        .data_result(data_result_sra)
    );

//decoder 
    decoder_32 unit_decoder(
        .ctrl_ALUopcode(ctrl_ALUopcode),
        .decode_ctrl_ALUopcode(decode_ctrl_ALUopcode)
    );

//output result
assign data_result = (decode_ctrl_ALUopcode[0]|decode_ctrl_ALUopcode[1]) ? data_result_add_or_sub: (decode_ctrl_ALUopcode[2] ? data_result_bitwise_and : (decode_ctrl_ALUopcode[3] ? data_result_bitwise_or : (decode_ctrl_ALUopcode[4] ? data_result_sll : (decode_ctrl_ALUopcode[5] ? data_result_sra : 32'b0))));
//judge the overflow
assign overflow =  (decode_ctrl_ALUopcode[0]| decode_ctrl_ALUopcode[1]) ? (Co^Co_1) ? 1 : 0 : 0;
//judge IsNotEqual
assign isNotEqual = (decode_ctrl_ALUopcode[1]) ? (|data_result_add_or_sub)? 1 : 0 : 0;
//judge IsLessThan
assign isLessThan = (decode_ctrl_ALUopcode[1]) ? (overflow ? (data_operandA[31] ? 1 : 0): data_result[31] ? 1 : 0): 0; 
endmodule


