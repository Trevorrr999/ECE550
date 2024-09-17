module adder_8_bit_CSA(
    input [7:0] A,
    input [7:0] B,
    output [7:0] Sout,
    input Cin,
    output Cout,
    output Cout_1
);
    wire [7:0] temp_1, temp_0;
    wire [7:0] c_temp1, c_temp0;
    genvar i,j,k;
    generate
        for(i = 0; i<= 7; i = i + 1)
        begin: unit_full_adder_1
           if(i == 0)
           begin
            full_adder u(
                .A(A[i]),
                .B(B[i]),
                .Cin(1),
                .Sout(temp_1[i]),
                .Cout(c_temp1[i])
            );                   
           end
           else
           begin
            full_adder u(
                .A(A[i]),
                .B(B[i]),
                .Cin(c_temp1[i-1]),
                .Sout(temp_1[i]),
                .Cout(c_temp1[i])
            );                      
           end
        end
        for(j = 0; j<= 7; j = j + 1)
        begin: unit_full_adder_0
           if(j == 0)
           begin
            full_adder u(
                .A(A[j]),
                .B(B[j]),
                .Cin(0),
                .Sout(temp_0[j]),
                .Cout(c_temp0[j])
            );                   
           end
           else
           begin
            full_adder u(
                .A(A[j]),
                .B(B[j]),
                .Cin(c_temp0[j-1]),
                .Sout(temp_0[j]),
                .Cout(c_temp0[j])
            );                      
           end   
        end
        for(k = 0; k<= 7; k = k + 1)
        begin: unit_mux_2_1
            mux_2_1 u(
                .A(temp_1[k]),
                .B(temp_0[k]),
                .sel(Cin),
                .out(Sout[k])
            );        
        end
    endgenerate
    mux_2_1 u_cout(
        .sel(Cin),
        .A(c_temp1[7]),
        .B(c_temp0[7]),
        .out(Cout)
    );
    assign Cout_1 = Cin ? c_temp1[6] : c_temp0[6];
endmodule