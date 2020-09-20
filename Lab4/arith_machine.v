// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC, nextPC;
	wire [4:0] w_addr;
	wire [31:0] A, B_data, B, out;
	wire [31:0] signext, zeroext;
	wire rd_src, writeenable;
	wire [1:0]alu_src2;
	wire [2:0]alu_op;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst,PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (A, B_data, inst[25:21], inst[20:16], w_addr, out, writeenable, clock, reset);

    /* add other modules */
	alu32 plus4 (nextPC, , , , PC, 32'h4, `ALU_ADD);
	mux2v #(5) m1(w_addr, inst[15:11], inst[20:16], rd_src);
	mips_decode d1(rd_src, writeenable, alu_src2, alu_op, except, inst[31:26], inst[5:0]);
	mux3v m2(B, B_data, signext, zeroext, alu_src2 );
	alu32 aout(out, , , , A, B, alu_op);
	assign zeroext[31:16] = 16'b0;
	assign zeroext[15:0] = inst[15:0];
	assign signext[15:0] = inst[15:0]; 
	assign signext[31:16] = {16{inst[15]}};
	
	
endmodule // arith_machine
