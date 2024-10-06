module register_32 (
    input [31:0] d,
    input clk,
    input en,
    input clr,
    output [31:0] q
);
parameter width = 32;
wire [width-1: 0] clk_sys;
wire [width-1: 0] en_sys;
wire [width-1: 0] clr_sys;
genvar i,j;
generate
    for(i = 0; i <=width -1; i = i+1)
    begin: gen_sys_clk
        assign clk_sys[i] = clk;
        assign en_sys [i] = en;
        assign clr_sys [i] = clr; 
    end
	 
    for(j = 0; j<= width -1; j = j+1)
    begin: gen_dffe
        dffe_ref u(
            .d(d[j]),
            .clk(clk_sys[j]),
            .q(q[j]),
            .en(en_sys[j]),
            .clr(clr_sys[j])
        );
    end
endgenerate

endmodule
