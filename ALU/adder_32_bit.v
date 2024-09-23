module adder_32_bit(A, B, Cin, out, cout,cout_1);
input [31:0] A;
input [31:0] B;
input Cin;
output[31:0] out;
output cout;
output cout_1;
//use to connect the carry singal of each csa adder to the next one
wire [2:0] sel_temp;
//
genvar i;
generate
    for(i = 0; i <= 3 ; i = i + 1)
    begin: unit_adder_8_bit_CSA
        if(i == 0)
        begin
            adder_8_bit_CSA u(
            .A(A[8*i+7: 8*i]),
            .B(B[8*i+7: 8*i]),
            .Cin(Cin),
            .Cout(sel_temp[i]),
            .Sout(out[8*i+7: 8*i]),
            .Cout_1()
            );
        end
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
        else
        begin
            adder_8_bit_CSA u(
            .A(A[8*i+7: 8*i]),
            .B(B[8*i+7: 8*i]),
            .Cin(sel_temp[i-1]),
            .Cout(sel_temp[i]),
            .Sout(out[8*i+7: 8*i]),
            .Cout_1()
            );                    
        end
    end
endgenerate
endmodule
