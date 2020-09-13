module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;
	
	wire sGarbage, sStart, sRun,sDoneY, sDoneN, sAddindex;
	wire sGarbage_next = (sGarbage & ~go) | reset;
	wire sStart_next = (sGarbage & go|sStart & go|sDoneY & go|sDoneN & go)&~reset;
	wire sRun_next = (sStart & ~go | sAddindex) & ~reset;
	wire sAddindex_next = (sRun & ~inversion_found & ~end_of_array) & ~reset;
	wire sDoneN_next = (sRun & inversion_found|sDoneN & ~go) & ~reset;
	wire sDoneY_next = (sRun & end_of_array & ~inversion_found | sRun & zero_length_array| sDoneY & ~go) & ~reset;
	
	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);
	dffe fsRun(sRun, sRun_next, clock, 1'b1, 1'b0);
	dffe fsAddindex(sAddindex, sAddindex_next, clock, 1'b1, 1'b0);
	dffe fsDoneN(sDoneN, sDoneN_next, clock, 1'b1, 1'b0);
	dffe fsDoneY(sDoneY, sDoneY_next, clock, 1'b1, 1'b0);
	
	
	  
	assign load_input = sStart;
	assign load_index = sStart | sAddindex;
	assign select_index = sAddindex;
	assign done = sDoneN | sDoneY;
	assign sorted = sDoneY;
endmodule
