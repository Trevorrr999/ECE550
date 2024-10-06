module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
 
   /* YOUR CODE HERE */
   parameter width = 32;
   wire [width-1 :0] decode_ctrl_readRegA, decode_ctrl_readRegB, decode_ctrl_writeReg;
   wire [width-1:0] result [width-1:0];
	wire [width-1:0] Enable;
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
   genvar i,j,k,m;
   generate
	 for(m = 0;m <= width -1 ; m = m + 1)
    begin: gen_Enable
			and u (Enable[m],decode_ctrl_writeReg[m],ctrl_writeEnable);
    end
    for(i = 0;i <= width -1 ; i = i + 1)
    begin: gen_register_32
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
    end
    for (j = 0; j <= width -1 ; j = j + 1)
    begin: gen_bufif1_A
        bufif1_32bit u(
            .data_in(result[j]),
            .data_out(data_readRegA),
            .enable(decode_ctrl_readRegA[j])
        );
    end
        for(k = 0; k <= width -1 ; k = k + 1)
    begin: gen_bufif1_B
        bufif1_32bit u(
            .data_in(result[k]),
            .data_out(data_readRegB),
            .enable(decode_ctrl_readRegB[k])
        );
    end
   endgenerate

endmodule
