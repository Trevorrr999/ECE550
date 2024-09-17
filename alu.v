module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
   
   // YOUR CODE HERE //
   parameter a = 1'b0;
   localparam b = a*2;
   //use to connect the result to the final result
   wire [31:0] temp_result1,temp_result2;
   //use to judge the overflow
   wire Co,Co_1;

   //use to invert each bit of B
   wire [31:0] inv_B;
   assign inv_B = ~data_operandB;
   //use to connect the data which are used to calcutate
   wire [31:0] data_valid_B;

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

   adder_32_bit unit1(
      .A(data_operandA),
      .B(data_valid_B),
      .Cin(ctrl_ALUopcode[0]),
      .out(data_result),
      .cout(Co),
      .cout_1(Co_1)
   );
   //judge the overflow
   assign overflow =  Co^Co_1 ? 1 : 0;

endmodule


