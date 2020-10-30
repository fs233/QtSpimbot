module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target, PC_plus4p;
    wire [31:0]  inst, instIF;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum, wr_regnum_MW;
    wire [2:0]   ALUOp, ALUOp_MW;

    wire         RegWrite, RegWrite_MW, BEQ, BEQ_MW, ALUSrc, ALUSrc_MW, MemRead, MemRead_MW, MemWrite, MemWrite_MW, MemToReg, MemToReg_MW, RegDst, RegDst_MW;
    wire         PCSrc, zero, ForwardA, ForwardB, stall;
    wire [31:0]  rd1_data, rd2_data, rd2_data_MW, ForwardB_data, ForwardA_data, B_data, alu_out_data, alu_out_data_MW, load_data, wr_data;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4p, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    register #(30) PipelinedPC(PC_plus4p, PC_plus4, clk, ~stall, reset||PCSrc);
    assign PCSrc = BEQ & zero;

    assign ForwardA = (RegWrite_MW==1) && (rs==wr_regnum_MW) && (rs!=0);
    assign ForwardB = (RegWrite_MW==1) && (rt==wr_regnum_MW) && (rt!=0);
    assign stall = ((rs==wr_regnum_MW)||(rt==wr_regnum_MW)) && MemRead_MW ;
    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(instIF, PC[31:2]);
    register #(32) PipelinedInstr(inst, instIF, clk, ~stall, reset||PCSrc);
    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    register #(3) Pipelined_aluop(ALUOp_MW, ALUOp, clk, /* enable */1'b1, reset||stall);
    register #(1) Pipelined_RegWR(RegWrite_MW, RegWrite, clk, /* enable */1'b1, reset||stall);
    register #(1) Pipelined_beq(BEQ_MW, BEQ, clk, /* enable */1'b1, reset||stall);
    register #(1) Pipelined_ALUSrc(ALUSrc_MW, ALUSrc, clk, /* enable */1'b1, reset||stall);
    register #(1) Pipelined_MemRead(MemRead_MW, MemRead, clk, /* enable */1'b1, reset||stall);
    register #(1) Pipelined_MemWrite(MemWrite_MW, MemWrite, clk, /* enable */1'b1, reset||stall);
    register #(1) Pipelined_MemToReg(MemToReg_MW, MemToReg, clk, /* enable */1'b1, reset||stall);
    register #(1) Pipelined_RegDst(RegDst_MW, RegDst, clk, /* enable */1'b1, reset||stall);
    
    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    register #(5) Pipelined_Regnum(wr_regnum_MW, wr_regnum, clk, /* enable */1'b1, reset||stall);

    mux2v #(32) ForwardA_mux(ForwardA_data, rd1_data, alu_out_data_MW, ForwardA);
    mux2v #(32) ForwardB_mux(ForwardB_data, rd2_data, alu_out_data_MW, ForwardB);

    mux2v #(32) imm_mux(B_data, ForwardB_data, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, ForwardA_data, B_data);

    register #(32) Pipelined_ALU(alu_out_data_MW, alu_out_data, clk, /* enable */1'b1, reset);
    register #(32) Pipelined_rd2(rd2_data_MW, ForwardB_data, clk, /* enable */1'b1, reset);
    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, rd2_data_MW, MemRead_MW, MemWrite_MW, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

endmodule // pipelined_machine
