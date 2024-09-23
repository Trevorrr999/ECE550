module mux_2_1(
    input A,
    input B,
    input sel,
    output out
);
    assign out = sel ? A : B; 
endmodule
