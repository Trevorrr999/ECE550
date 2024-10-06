module bufif1_32bit (
    input wire [31:0] data_in,  
    input wire enable,           
    output wire [31:0] data_out 
);


    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : tri_state_buffer
            bufif1 (data_out[i], data_in[i], enable);
        end
    endgenerate

endmodule