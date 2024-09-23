module decoder_32 #(parameter width = 32)(
    input [4:0] ctrl_ALUopcode,
    output [width-1 : 0] decode_ctrl_ALUopcode
);

assign decode_ctrl_ALUopcode[0]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[1]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[2]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[3]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[4]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[5]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[6]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[7]  = ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[8]  = ~ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[9]  = ~ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[10] = ~ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[11] = ~ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[12] = ~ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[13] = ~ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[14] = ~ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[15] = ~ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[16] =  ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[17] =  ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[18] =  ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[19] =  ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[20] =  ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[21] =  ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[22] =  ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[23] =  ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[24] =  ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[25] =  ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[26] =  ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[27] =  ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[28] =  ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[29] =  ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] &  ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[30] =  ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0]; 
assign decode_ctrl_ALUopcode[31] =  ctrl_ALUopcode[4] &  ctrl_ALUopcode[3] &  ctrl_ALUopcode[2] &  ctrl_ALUopcode[1] &  ctrl_ALUopcode[0];
endmodule
