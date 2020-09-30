# Sets the values of the array to the corresponding values in the request
# void fill_array(unsigned request, int* array) {
#   for (int i = 0; i < 6; ++i) {
#     request >>= 3;
#
#     if (i % 3 == 0) {
#       array[i] = request & 0x0000001f;
#     } else {
#       array[i] = request & 0x000000ff;
#     }
#   }
# }
.globl fill_array
fill_array:
	move $t0, $a0                  #move request
	move $t1, $a1                  #move array ptr
	li   $t2, 0                    #i = 0
	li   $t3, 3                    #load 3
for:
	bge  $t2, 6, return            #i<6
	srl  $t0, $t0, 3               #right shift 
if:
	rem $t8, $t2, $t3              #divide
	bne $t8, 0, else               #if remainder != 0
	mul $t7, $t2, 4				   #i*4
    add $t4, $t1, $t7              #calc offset
	and $t6, $t0, 0x0000001f       #bitwise op
	sw  $t6, 0($t4)                #store the value
	add $t2, $t2, 1                #i++
	j   for                        #back to for
else:
	mul $t7, $t2, 4				   #i*4
    add $t4, $t1, $t7              #calc offset
	and $t6, $t0, 0x000000ff       #bitwise op
	sw  $t6, 0($t4)                #store the value
	add $t2, $t2, 1                #i++
	j   for                        #back to for
return:
	jr  $ra						   #return
