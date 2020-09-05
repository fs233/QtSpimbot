//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 5; B = 2; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
		# 10 A = 3432; B = 68719476735; control = `ALU_AND;
		# 10 A = 0; B = 532; control = `ALU_AND;
		# 10 A = 21; B = 6; control = `ALU_OR;
		# 10 A = 213; B = 68719476735; control = `ALU_OR;
		# 10 A = 21; B = 6; control = `ALU_NOR;
		# 10 A = 4675; B = 4675; control = `ALU_XOR;
		# 10 A = 24453456; B = 24453456; control = `ALU_SUB;
		# 10 A = 6; B = 2147483632; control = `ALU_SUB;
		

		# 10 A = 2147483632; B = 2147483647; control = `ALU_ADD;
		# 10 A = 2147483903 ; B = 2147549183; control = `ALU_ADD;
		# 10 A = 2147483632; B = 3758096383; control = `ALU_SUB;
		
		
		

        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test

















