module registerinter(q, d, clk, enable, reset);

   parameter
            width = 32,
            reset_value = 32'hffffffff;

   output [(width-1):0] q;
   reg [(width-1):0]    q;
   input [(width-1):0]  d;
   input                clk, enable, reset;

   always@(posedge clk)
     if (reset == 1'b1)
       q <= reset_value;
     else if (enable == 1'b1)
       q <= d;

endmodule // register

module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here
	wire    	  TimerRead, TimerWrite, eq1, eq2, eq3, Acknowledge, reseti;
	wire   [31:0] qi, qc, dc;

	assign         eq1 = address==32'hffff001c;
	assign         eq2 = address==32'hffff006c;
	assign 		   eq3 = qc==qi;
	or             o0(TimerAddress, eq1, eq2);
	or             o1(reseti, Acknowledge, reset);
	and            a0(Acknowledge, MemWrite, eq2);
	and            a1(TimerRead, eq1, MemRead);
	and            a2(TimerWrite, MemWrite, eq1);
	
	register       rc(qc, dc, clock, 1'h1, reset);	
	registerinter  ri(qi, data, clock, TimerWrite, reset);
	tristate       t0(cycle, qc, TimerRead);
	alu32          a0(dc, , , `ALU_ADD, qc, 32'h1);  
	dffe           d0(TimerInterrupt, 1'h1, clock, eq3, reseti);
	
	
	

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
