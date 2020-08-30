module blackbox_test;
	reg z, k, r;
	wire a;
	blackbox b1(a,z,k,r);
	initial begin
		
		$dumpfile("blackbox.vcd");
		$dumpfile(0,blackbox_test);

		z=0; k=0; r=0; #10;
		
		$finish;
	end
	
	
	
		

endmodule // blackbox_test
iverilog -Wall -o blackbox.v blackbox_tb.v

