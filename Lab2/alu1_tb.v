module alu1_test;
    // exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v
	// cycle through all combinations of A, B, C, D every 16 time units
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg carryin = 0;
    always #4 carryin = !carryin;
    
     
    reg [2:0] control = 0;
     
    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        // control is initially 0
        # 8 control = 1; // wait 16 time units (why 16?) and then set it to 1
        # 8 control = 2; // wait 16 time units and then set it to 2
        # 8 control = 3; // wait 16 time units and then set it to 3
		# 8 control = 4;
		# 8 control = 5;
		# 8 control = 6;
		# 8 control = 7;
        # 8 $finish; // wait 16 time units and then end the simulation
    end

    wire out, carryout;
    alu1 a1(out, carryout, A, B, carryin, control);

    // you really should be using gtkwave instead
    /*
    initial begin
        $display("A B carryin s o");
        $monitor("%d %d %d %d %d  (at time %t)", A, B, carryin, control, out, $time);
    end
    */
endmodule //alu1_test
