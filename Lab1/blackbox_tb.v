module blackbox_test;
  reg z, k, r;
  wire a;
  blackbox b1(a, z, k, r);
  initial begin
		
		  $dumpfile("blackbox.vcd");
		  $dumpfile(0,blackbox_test);

		  z=0; k=0; r=0; # 10;
      z=0; k=0; r=1; # 10;
      z=0; k=1; r=0; # 10;
      z=0; k=1; r=1; # 10;
      z=1; k=0; r=0; # 10;
      z=1; k=0; r=1; # 10;
      z=1; k=1; r=0; # 10;
      z=1; k=1; r=1; # 10;
		
      $finish;
  end
	
  initial
	  $monitor("At time %2t, a = %d z = %d k = %d r = %d",
                 $time, a, z, k, r); 

endmodule // blackbox_test
