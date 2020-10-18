`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
	wire   [31:0] user_status, decode0, status_register, cause_register, epc_register;
	wire   [29:0] epc_d, epc_q;
	wire          userenable, epcen, exreset, exception_level, epcenable, cs, ss, ns;
	
	register      ruser(user_status, wr_data, clock, userenable, reset);
	decoder32     d0(decode0, regnum, MTC0);
	assign        userenable = decode0[12];
	assign        epcen = decode0[14];
	or            o0(exreset, reset, ERET);
	or            o1(epcenable, epcen, TakenInterrupt);
	dffe          dex(exception_level, 1'h1, clock, TakenInterrupt, exreset);
	mux2v #(30)   mepc(epc_d, wr_data[31:2], next_pc, TakenInterrupt);
	register #(30, 0) repc(epc_q, epc_d, clock, epcenable, reset);
	assign        EPC = epc_q;
	assign        status_register[31:16] = 16'h0;
	assign        status_register[15:8] = user_status[15:8];
	assign        status_register[7:2] = 6'h0;
	assign        status_register[1] = exception_level;
	assign        status_register[0] = user_status[0];
	assign        cause_register[31:16] = 16'h0;
	assign        cause_register[15] = TimerInterrupt;
	assign        cause_register[14:0] = 15'h0;
	assign        epc_register[31:2] = epc_q;
	assign        epc_register[1:0] = 2'b0;
	mux32v        mrd(rd_data, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, status_register, cause_register, epc_register, 32'h0, 32'h0, 
                  32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, regnum);
	and           a0(cs, cause_register[15], status_register[15]);
	not           no(ns, status_register[1]);
	and           a1(ss, ns, status_register[0]);
	and           a2(TakenInterrupt, cs, ss);
	
endmodule
