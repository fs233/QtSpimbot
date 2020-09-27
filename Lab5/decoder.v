// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;
	wire op_add, op_sub, op_and, op_or, op_nor, op_xor, op_addi, op_andi, op_ori, op_xori, op_beq, op_bne, op_j, op_jr, op_lui, op_slt, op_lw, op_lbu, op_sw, op_sb, op_addm;	

	assign op_add = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
	assign op_sub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
	assign op_and = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
	assign op_or = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
	assign op_nor = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
	assign op_xor = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);
	assign op_addi = (opcode == `OP_ADDI);
	assign op_andi = (opcode == `OP_ANDI);
	assign op_ori = (opcode == `OP_ORI);
	assign op_xori = (opcode == `OP_XORI);
	assign op_beq = (opcode == `OP_BEQ);
	assign op_bne = (opcode == `OP_BNE);
	assign op_j = (opcode == `OP_J);
	assign op_jr = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
	assign op_lui = (opcode == `OP_LUI);
	assign op_slt = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
	assign op_lw = (opcode == `OP_LW);
	assign op_lbu = (opcode == `OP_LBU);
	assign op_sw = (opcode == `OP_SW);
	assign op_sb = (opcode == `OP_SB);
	assign op_addm = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);
	
	assign alu_op[0] =  (op_sub | op_or | op_xor | op_ori | op_xori | op_beq  | op_bne  | op_slt);
    assign alu_op[1] =  (op_add | op_sub| op_nor | op_xor | op_addi | op_xori | op_beq  | op_bne | op_slt | op_lw | op_lbu | op_sw | op_sb | op_addm);
    assign alu_op[2] =  (op_and | op_or | op_nor | op_xor | op_andi | op_ori | op_xori);
	assign rd_src = (op_addi | op_andi | op_ori | op_xori | op_lui | op_lw | op_lbu | op_sw | op_sb);
	assign control_type[0] = (op_beq & zero)|(op_bne & ~zero)|op_jr;
	assign control_type[1] = op_j|op_jr;
	assign mem_read = op_lw | op_lbu | op_addm;
	assign word_we = op_sw;
	assign byte_we = op_sb;
	assign byte_load = op_lbu;
	assign slt = op_slt;
	assign lui = op_lui;
	assign addm = op_addm; 
	assign alu_src2[0] = op_addi | op_lw | op_lbu | op_sw | op_sb |op_addm;
	assign alu_src2[1] = op_andi | op_xori | op_ori| op_addm;
	assign writeenable = !(op_beq | op_bne | op_j | op_jr | op_sw | op_sb | except);
	assign except = ~(op_add | op_sub | op_and | op_or | op_nor | op_xor | op_addi | op_andi | op_ori | op_xori | op_beq | op_bne | op_j | op_jr | op_lui | op_slt | op_lw | op_lbu | op_sw | op_sb | op_addm);




endmodule // mips_decode
