module decoder_32 (
    input [4:0] ctrl_ALUopcode,
    output [31 : 0] decode_ctrl_ALUopcode
);

    parameter width = 32;
	 
    wire n0, n1, n2, n3, n4;

    
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
    and (decode_ctrl_ALUopcode[8], n4, ctrl_ALUopcode[3], n2, n1, n0);
    and (decode_ctrl_ALUopcode[9], n4, ctrl_ALUopcode[3], n2, n1, ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[10], n4, ctrl_ALUopcode[3], n2, ctrl_ALUopcode[1], n0);
    and (decode_ctrl_ALUopcode[11], n4, ctrl_ALUopcode[3], n2, ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[12], n4, ctrl_ALUopcode[3], ctrl_ALUopcode[2], n1, n0);
    and (decode_ctrl_ALUopcode[13], n4, ctrl_ALUopcode[3], ctrl_ALUopcode[2], n1, ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[14], n4, ctrl_ALUopcode[3], ctrl_ALUopcode[2], ctrl_ALUopcode[1], n0);
    and (decode_ctrl_ALUopcode[15], n4, ctrl_ALUopcode[3], ctrl_ALUopcode[2], ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[16], ctrl_ALUopcode[4], n3, n2, n1, n0);
    and (decode_ctrl_ALUopcode[17], ctrl_ALUopcode[4], n3, n2, n1, ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[18], ctrl_ALUopcode[4], n3, n2, ctrl_ALUopcode[1], n0);
    and (decode_ctrl_ALUopcode[19], ctrl_ALUopcode[4], n3, n2, ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[20], ctrl_ALUopcode[4], n3, ctrl_ALUopcode[2], n1, n0);
    and (decode_ctrl_ALUopcode[21], ctrl_ALUopcode[4], n3, ctrl_ALUopcode[2], n1, ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[22], ctrl_ALUopcode[4], n3, ctrl_ALUopcode[2], ctrl_ALUopcode[1], n0);
    and (decode_ctrl_ALUopcode[23], ctrl_ALUopcode[4], n3, ctrl_ALUopcode[2], ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[24], ctrl_ALUopcode[4], ctrl_ALUopcode[3], n2, n1, n0);
    and (decode_ctrl_ALUopcode[25], ctrl_ALUopcode[4], ctrl_ALUopcode[3], n2, n1, ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[26], ctrl_ALUopcode[4], ctrl_ALUopcode[3], n2, ctrl_ALUopcode[1], n0);
    and (decode_ctrl_ALUopcode[27], ctrl_ALUopcode[4], ctrl_ALUopcode[3], n2, ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[28], ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], n1, n0);
    and (decode_ctrl_ALUopcode[29], ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], n1, ctrl_ALUopcode[0]);
    and (decode_ctrl_ALUopcode[30], ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], ctrl_ALUopcode[1], n0);
    and (decode_ctrl_ALUopcode[31], ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], ctrl_ALUopcode[1], ctrl_ALUopcode[0]);

endmodule