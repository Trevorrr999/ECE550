module full_adder(
    input A,
    input B,
    input Cin,
    output Cout,
    output Sout
);
    assign Sout = A ^ B ^ Cin;
    assign Cout = A&B || B&Cin || A&Cin; 
endmodule
