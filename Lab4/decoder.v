// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    output       rd_src, writeenable, except;
    output [1:0] alu_src2;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;
	assign except=!((opcode==`OP_OTHER0 &(funct==`OP0_ADD|funct==`OP0_AND|funct==`OP0_SUB|funct==`OP0_XOR|funct==`OP0_NOR|funct==`OP0_OR))|opcode==`OP_ANDI|opcode==`OP_ADDI|opcode==`OP_ORI|opcode==`OP_XORI);
	assign rd_src = !(opcode==`OP_OTHER0);
	assign alu_src2[0] = opcode==`OP_ADDI;
	assign alu_src2[1] = !((opcode ==`OP_OTHER0 | opcode ==`OP_ADDI));
	assign alu_op[0] = (opcode ==`OP_OTHER0 &(funct==`OP0_OR|funct==`OP0_XOR|funct==`OP0_SUB))|opcode==`OP_ORI|opcode==`OP_XORI;
	assign alu_op[1] = ! ((opcode ==`OP_OTHER0 &(funct==`OP0_AND|funct==`OP0_OR))|opcode==`OP_ANDI|opcode==`OP_ORI);
	assign alu_op[2] = ! ((opcode ==`OP_OTHER0 &(funct==`OP0_ADD|funct==`OP0_SUB))|opcode==`OP_ADDI);
	
	assign writeenable = !except;
endmodule // mips_decode
