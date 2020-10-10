# #define MAX_GRIDSIZE 16
# #define MAX_MAXDOTS 15

# /*** begin of the solution to the puzzle ***/

# // encode each domino as an int
# int encode_domino(unsigned char dots1, unsigned char dots2, int max_dots) {
#     return dots1 < dots2 ? dots1 * max_dots + dots2 + 1 : dots2 * max_dots + dots1 + 1;
# }
.globl encode_domino
encode_domino:
	sub  $sp, $sp, 8
	sw   $ra, 0($sp)
	sw   $s0, 4($sp)

	bge  $a0, $a1, other
	mul  $s0, $a0, $a2
	add  $s0, $s0, $a1
	add  $s0, $s0, 1
	move $v0, $s0
	j returnint
other:
	mul  $s0, $a1, $a2
	add  $s0, $s0, $a0
	add  $s0, $s0, 1
	move $v0, $s0
returnint:
	lw   $ra, 0($sp)
	lw   $s0, 4($sp)
	add  $sp, $sp, 8
	jr   $ra


# // main solve function, recurse using backtrack
# // puzzle is the puzzle question struct
# // solution is an array that the function will fill the answer in
# // row, col are the current location
# // dominos_used is a helper array of booleans (represented by a char)
# //   that shows which dominos have been used at this stage of the search
# //   use encode_domino() for indexing
# int solve(dominosa_question* puzzle, 
#           unsigned char* solution,
#           int row,
#           int col) {
#
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int max_dots = puzzle->max_dots;
#     int next_row = ((col == num_cols - 1) ? row + 1 : row);
#     int next_col = (col + 1) % num_cols;
#     unsigned char* dominos_used = puzzle->dominos_used;
#
#     if (row >= num_rows || col >= num_cols) { return 1; }
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
#
#     unsigned char curr_dots = puzzle->board[row * num_cols + col];
#
#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
#
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[(row + 1) * num_cols + col] = 0;
#         }
#     }
#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[row * num_cols + (col + 1)] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[row * num_cols + (col + 1)] = 0;
#         }
#     }
#     return 0;
# }
.globl solve
        # Plan out your registers and their lifetimes ahead of time. You will almost certainly run out of registers if you
        # do not plan how you will use them. If you find yourself reusing too much code, consider using the stack to store
        # some variables like &solution[row * num_cols + col] (caller-saved convention).
solve:
	sub  $sp, $sp, 68
	sw   $ra, 0($sp)
	sw   $s0, 4($sp)
	sw   $s1, 8($sp)
	sw   $s2, 12($sp)
	sw   $s3, 16($sp)
	sw   $s4, 20($sp)
	sw   $s5, 24($sp)
	sw   $s6, 28($sp)
	sw   $s7, 32($sp)
	sw   $t0, 36($sp)
	sw   $t1, 40($sp)
	sw   $t2, 44($sp)
	sw   $t3, 48($sp)
	sw   $t4, 52($sp)
	sw   $t5, 56($sp)
	sw   $t6, 60($sp)
	sw   $t7, 64($sp)


	move $s0, $a0             #ptr to puzzle
	move $s1, $a1			  #ptr to solution
	move $t0, $a2             #row
 	move $t1, $a3             #col
	lw   $s2, 0($s0)		  #numrow       
	lw   $s3, 4($s0)		  #numcol
	lw   $s4, 8($s0)          #maxdot
	sub  $t2, $s3, 1 
	bne  $t1, $t2, else1
	add  $s5, $t0, 1          #nextrow
	j cont1
else1:
	move $s5, $t0			  #another nextrow
cont1:
	add  $s6, $t1, 1
	rem  $s6, $s6, $s3        #nextcol
	
	blt  $t0, $s2, nextone
	li   $v0, 1
	j    realreturn
nextone:
	blt  $t1, $s3, nextif
	li   $v0, 1
	j    realreturn

nextif:
	mul  $t2, $t0, $s3
	add  $t2, $t2, $t1        #offset row*numcol+col
	move $t7, $t2             #t7 has row*numcol+col
	add  $t3, $t2, $s1        #addr of solution..
	lb   $t3, 0($t3)          #solution[..]
	beq  $t3, $zero, cont2
	move $a0, $s0
	move $a1, $s1
	move $a2, $s5
	move $a3, $s6
	jal solve
	j    realreturn

cont2:
	add  $t3, $s0, 12         #addr of the first elem of board[]
	add  $t3, $t3, $t7        #addr of board[..]
	lb   $s7, 0($t3)          #curr dot in s7
	
	
	sub  $t2, $s2, 1          	
	bge  $t0, $t2, nextbig
	add  $t2, $t0, 1          #row+1
	mul  $t2, $t2, $s3        #(row+1)*numcol
	add  $t2, $t2, $t1        #offset calc
	move $t6, $t2             #t6 has (row+1)*numcol+col
	add  $t3, $t2, $s1        #addr of solution[]
	lb   $t3, 0($t3)          #solution[]
	bne  $t3, $zero, nextbig
	
	add  $t4, $s0, 12         #addr of the first elem of board[]
	add  $t4, $t4, $t6        #addr of board[..]
	lb   $t4, 0($t4)	      #board[]
	move $a0, $s7
	move $a1, $t4
	move $a2, $s4
	jal  encode_domino
	move $t5, $v0             #domino_code
	
	add  $t2, $s0, 268        #addr of dominos_used[0]
	add  $t2, $t2, $t5        #addr of domino[code]
	lb   $t4, 0($t2)          #domino[code]
	bne  $t4, $zero, nextbig
	li   $t3, 1
	sb   $t3, 0($t2)          #domino[code] = 1
	add  $t4, $t7, $s1        #addr of solution[row*numcol+col]
	sb   $t5, 0($t4)          #sol[] = code
	add  $t3, $t6, $s1        #addr of solution[(row+1)*numcol+col]
	sb   $t5, 0($t3)          #sol[..] = code
	move $a0, $s0
	move $a1, $s1
	move $a2, $s5
	move $a3, $s6
	jal  solve
	move $t2, $v0
	beq  $t2, $zero, cont3
	li   $v0, 1
	j    realreturn

cont3:
	add  $t2, $s0, 268        #addr of dominos_used[0]
	add  $t2, $t2, $t5        #addr of domino[code]
	sb   $zero, 0($t2)        #domino[code] = 0
	add  $t4, $t7, $s1        #addr of solution[row*numcol+col]
	sb   $zero, 0($t4)        #solution[row*numcol+col] = 0
	add  $t4, $t6, $s1        #addr of solution[(row+1)*numcol+col]
	sb   $zero, 0($t4)        #solution[(row+1)*numcol+col] = 0
	j    nextbig

nextbig:
	sub  $t2, $s3, 1          	
	bge  $t1, $t2, return
	mul  $t2, $t0, $s3        #row*numcol
	add  $t2, $t2, 1
	add  $t2, $t2, $t1        #offset calc
	move $t6, $t2             #t6 has row*numcol+col+1
	add  $t3, $t2, $s1        #addr of solution[]
	lb   $t3, 0($t3)          #solution[]
	bne  $t3, $zero, return
	
	add  $t4, $s0, 12         #addr of the first elem of board[]
	add  $t4, $t4, $t6        #addr of board[row*numcol+col+1]
	lb   $t4, 0($t4)	      #board[row*numcol+col+1]
	move $a0, $s7
	move $a1, $t4
	move $a2, $s4
	jal  encode_domino
	move $t5, $v0             #domino_code
	
	add  $t2, $s0, 268        #addr of dominos_used[0]
	add  $t2, $t2, $t5        #addr of domino[code]
	lb   $t4, 0($t2)          #domino[code]
	bne  $t4, $zero, return
	li   $t3, 1
	sb   $t3, 0($t2)          #domino[code] = 1
	add  $t4, $t7, $s1        #addr of solution[row*numcol+col]
	sb   $t5, 0($t4)          #sol[] = code
	add  $t3, $t6, $s1        #addr of solution[row*numcol+col+1]
	sb   $t5, 0($t3)          #sol[..] = code
	move $a0, $s0
	move $a1, $s1
	move $a2, $s5
	move $a3, $s6
	jal  solve
	move $t2, $v0
	beq  $t2, $zero, cont4
	li   $v0, 1
	j    realreturn

cont4:
	add  $t2, $s0, 268        #addr of dominos_used[0]
	add  $t2, $t2, $t5        #addr of domino[code]
	sb   $zero, 0($t2)        #domino[code] = 0
	add  $t4, $t7, $s1        #addr of solution[row*numcol+col]
	sb   $zero, 0($t4)        #solution[row*numcol+col] = 0
	add  $t4, $t6, $s1        #addr of solution[(row)*numcol+col+1]
	sb   $zero, 0($t4)        #solution[(row+1)*numcol+col] = 0
return:
	li   $v0, 0
realreturn:
	lw   $ra, 0($sp)
	lw   $s0, 4($sp)
	lw   $s1, 8($sp)
	lw   $s2, 12($sp)
	lw   $s3, 16($sp)
	lw   $s4, 20($sp)
	lw   $s5, 24($sp)
	lw   $s6, 28($sp)
	lw   $s7, 32($sp)
	lw   $t0, 36($sp)
	lw   $t1, 40($sp)
	lw   $t2, 44($sp)
	lw   $t3, 48($sp)
	lw   $t4, 52($sp)
	lw   $t5, 56($sp)
	lw   $t6, 60($sp)
	lw   $t7, 64($sp)
	add  $sp, $sp, 68
	jr   $ra
	
	
	
	
	          

