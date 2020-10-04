# Performs a selection sort on the data with a comparator
# void selection_sort (int* array, int len) {
#   for (int i = 0; i < len -1; i++) {
#     int min_idx = i;
#
#     for (int j = i+1; j < len; j++) {
#       // Do NOT inline compare! You code will not work without calling compare.
#       if (compare(array[j], array[min_idx])) {
#         min_idx = j;
#       }
#     }
#
#     if (min_idx != i) {
#       int tmp = array[i];
#       array[i] = array[min_idx];
#       array[min_idx] = tmp;
#     }
#   }
# }
.globl selection_sort
selection_sort:
	sub $sp, $sp, 32                     #alloc stack here
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s0, $a0	                     #ptr saved in s0
	move $s2, $a1                        #len
	li 	 $s3, 0                          #i = 0
	sub  $s4, $s2, 1                     #len -1
loop1:
	bge  $s3, $s4, returns	             #i<len-1
	add  $s5, $s3, 0                     #min = i
	add  $s6, $s3, 1                     #j = i+1
	
loop2:                                  
	bge  $s6, $s2, ifmin                 #j<len
	mul  $t1, $s6, 4                     #4*j
	mul  $t2, $s5, 4                     #4*min
	add  $t1, $t1, $s0                   #addr of j th elem
	add  $t2, $t2, $s0                   #addr of min th elem
	lw   $a0, 0($t1)                     #load elem
	lw   $a1, 0($t2)
	jal compare
	move $s1, $v0                        #result in s1                  
	beq  $s1, 0, end2                    #if false go back to loop 
	add  $s5, $s6, 0                     #if true min = j

end2:
	add  $s6, $s6, 1                     # j++
	j    loop2                   
	
ifmin:	
	beq  $s5, $s3, end1                  #if min = i go back to loop1
	mul  $t3, $s3, 4                     #4*i	
	add  $t3, $t3, $s0                   #addr of the ith elem
	lw   $t4, 0($t3)                     #temp = i th element
	mul  $t5, $s5, 4                     #4*min
	add  $t5, $t5, $s0                   #addr of the min th elem
	lw   $t6, 0($t5)                     #load min th elem in t6
	sw   $t6, 0($t3)                     #store the value in i th elem
	sw   $t4, 0($t5)                     #store temp in min th element

end1:
	add $s3, $s3, 1                     #i++
	j loop1

returns:
	lw $ra, 0($sp)                       #deallocate stack
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)   
	add $sp, $sp, 32         
	jr      $ra





# Draws points onto the array
# int draw_gradient(Gradient map[15][15]) {
#   int num_changed = 0;
#   for (int i = 0 ; i < 15 ; ++ i) {
#     for (int j = 0 ; j < 15 ; ++ j) {
#       char orig = map[i][j].repr;
#
#       if (map[i][j].xdir == 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '.';
#       }
#       if (map[i][j].xdir != 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '_';
#       }
#       if (map[i][j].xdir == 0 && map[i][j].ydir != 0) {
#         map[i][j].repr = '|';
#       }
#       if (map[i][j].xdir * map[i][j].ydir > 0) {
#         map[i][j].repr = '/';
#       }
#       if (map[i][j].xdir * map[i][j].ydir < 0) {
#         map[i][j].repr = '\';
#       }

#       if (map[i][j].repr != orig) {
#         num_changed += 1;
#       }
#     }
#   }
#   return num_changed;
# }
.globl draw_gradient
draw_gradient:
	sub $sp, $sp, 28                  #alloc memory 
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s7, 24($sp)

	move $s0, $a0                     #addr of the first elem
	li  $s7, 0                        #num = 0
	li  $s2, -1                       #i = -1
	li  $t0, 15                       #t0 = 15
for1:
	add $s2, $s2, 1                   #i++
	li  $s3, 0                        #j = 0
	bge $s2, $t0, finalreturn         #i<15
for2:
	bge $s3, $t0, for1                #j<15
	mul $t1, $s2, 180	              #15*row*12
	mul $t2, $s3, 12                  #12*col
	add $s4, $t2, $t1                 #offset
	add $s4, $s4, $s0                 #addr of point ij
	lw  $s5, 0($s4)                   #s5 has the orig char
	move $a0, $s4
	jal if1
	jal if2
	jal if3
	jal if4
	jal if5
	jal if6
	add $s3, $s3, 1                   #j++
	j for2
	


if1:       
	sub $sp, $sp, 20                  #alloc memory 
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	move $s0, $a0                     #map[i][j]
	lw   $s1, 4($s0)                  #xdir
	lw   $s2, 8($s0)                  #ydir 
	bne  $s1, 0, return              #return 
	bne  $s2, 0, return
	li   $s3, '.'					  #s3 is the char
	sw   $s3, 0($s0)                  #char store in the place
	j    return

if2:
	sub $sp, $sp, 20                  #alloc memory 
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	move $s0, $a0                     #map[i][j]
	lw   $s1, 4($s0)                  #xdir
	lw   $s2, 8($s0)                  #ydir 
	beq  $s1, 0, return              #return 
	bne  $s2, 0, return
	li   $s3, '_'					  #s3 is the char
	sw   $s3, 0($s0)                  #char store in the place
	j    return
	
if3:
	sub $sp, $sp, 20                  #alloc memory 
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	move $s0, $a0                     #map[i][j]
	lw   $s1, 4($s0)                  #xdir
	lw   $s2, 8($s0)                  #ydir 
	bne  $s1, 0, return              #return 
	beq  $s2, 0, return
	li   $s3, '|'					  #s3 is the char
	sw   $s3, 0($s0)                  #char store in the place
	j    return

if4:
	sub $sp, $sp, 20                  #alloc memory 
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	move $s0, $a0                     #map[i][j]
	lw   $s1, 4($s0)                  #xdir
	lw   $s2, 8($s0)                  #ydir 
	mul  $s2, $s2, $s1                #multiply x and y
	ble  $s2, 0, return              #return 
	li   $s3, '/'					  #s3 is the char
	sw   $s3, 0($s0)                  #char store in the place
	j    return

if5:
	sub $sp, $sp, 20                  #alloc memory 
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	move $s0, $a0                     #map[i][j]
	lw   $s1, 4($s0)                  #xdir
	lw   $s2, 8($s0)                  #ydir 
	mul  $s2, $s2, $s1                #multiply x and y
	bge  $s2, 0, return               #return 
	li   $s3, '\\'					  #s3 is the char
	sw   $s3, 0($s0)                  #char store in the place
	j    return

if6:
	sub $sp, $sp, 12                  #alloc memory 
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	move $s0, $a0                     #map[i][j]
	lw   $s1, 0($s0)                  #repr
	beq  $s5, $s1, return6            #compare return 
	add  $s7, $s7, 1                  #num_changed++
	j    return6

		
return:          
	lw $ra, 0($sp)					 #dealloc memory
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	add $sp, $sp, 20
	jr $ra

return6:
	lw $ra, 0($sp)					  #dealloc memory
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	add $sp, $sp, 12                  
	jr $ra

finalreturn:
	move $v0, $s7
	                   
	lw $ra, 0($sp)					#dealloc memory 
	lw $s0, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s7, 24($sp)
	add $sp, $sp, 28
    jr      $ra
