// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC, PCplus4, nextPC;
	wire [4:0] w_addr;
	wire [31:0] A, B_data, B, out, branchoffset, branch, jump, w_data, loadupper, memory, data_out, extbyte, byteload, sltout, sltin, luiout, signext, zeroext, addmout;
	wire rd_src, writeenable, zero, negative, overflow, mem_read, word_we, byte_we, byte_load, slt, lui, addm;
	wire [1:0]alu_src2, control_type;
	wire [2:0]alu_op;
	wire [7:0] byte;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst,PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (A, B_data, inst[25:21], inst[20:16], w_addr, w_data, writeenable, clock, reset);

    /* add other modules */
	mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   inst[31:26], inst[5:0], zero);
	
	data_mem datamem(data_out, out, B_data, word_we, byte_we, clock, reset);



	alu32 plus4 (PCplus4, , , , PC, 32'h4, `ALU_ADD);
	alu32 plusbranch(branch, , , ,PCplus4, branchoffset,`ALU_ADD);
	alu32 aout(out, overflow, zero, negative, A, B, alu_op);
	alu32 aaddm(addmout, , , ,B_data, memory,`ALU_ADD);
	


	mux4v mcrtl(nextPC, PCplus4, branch, jump, A, control_type);
	mux4v m2(B, B_data, signext, zeroext, 32'b0, alu_src2 );
	mux4v #(8) mdatamem(byte, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);
	mux2v #(5) m1(w_addr, inst[15:11], inst[20:16], rd_src);
	mux2v mlui(luiout, memory, loadupper, lui);
	mux2v mbyte(byteload, data_out, extbyte, byte_load);
	mux2v mmemo(memory, sltout, byteload, mem_read);
	mux2v mslt(sltout, out, sltin, slt);
	mux2v mwdata(w_data, luiout, addmout, addm);
	
	

	assign jump[31:28] = PCplus4[31:28];
	assign jump[27:2] = inst[25:0];
	assign jump[1:0] = 2'b0;
	assign loadupper[31:16] = inst[15:0];
	assign loadupper[15:0] = 16'b0;
	assign signext[15:0] = inst[15:0]; 
	assign signext[31:16] = {16{inst[15]}};
	assign zeroext[31:16] = 16'b0;
	assign zeroext[15:0] = inst[15:0];
	assign branchoffset[31:2] = signext[29:0];
	assign branchoffset[1:0] = 2'b0;
	assign extbyte[7:0] = byte;
	assign extbyte[31:8] = 24'b0;
	assign sltin[0] = negative ^ overflow;
	assign sltin[31:1] = 31'b0;






endmodule // full_machine
