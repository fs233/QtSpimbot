# #define NULL 0

# // Note that the value of op_add is 0 and the value of each item
# // increments as you go down the list
# //
# // In C, an enum is just an int!
# typedef enum {
#     op_add,         
#     op_sub,         
#     op_mul,         
#     op_div,         
#     op_rem,         
#     op_neg,         
#     op_paren,
#     constant
# } node_type_t;

# typedef struct {
#     node_type_t type;
#     bool computed;
#     int value;
#     ast_node* left;
#     ast_node* right;
# } ast_node;

# int value(ast_node* node) {
#     if (node == NULL) { return 0; }
#     if (node->computed) { return node->value; }

#     int left = value(node->left);
#     int right = value(node->right);

#     // This can just implemented with successive if statements (see Appendix)
#     switch (node->type) {
#         case constant:
#             return node->value;
#         case op_add:
#             node->value = left + right;
#             break;
#         case op_sub:
#             node->value = left - right;
#             break;
#         case op_mul:
#             node->value = left * right;
#             break;
#         case op_div:
#             node->value = left / right;
#             break;
#         case op_rem:
#             node->value = left % right;
#             break;
#         case op_neg:
#             node->value = -left;
#             break;
#         case op_paren:
#             node->value = left;
#             break;
#     }
#     node->computed = true;
#     return node->value;
# }
.globl value
value:
	bne $a0, 0, next                   #null check
	li  $v0, 0
	jr  $ra
next:
	lb  $t0, 4($a0)                    #if computed
	beq $t0, 0, cont
	lw  $v0, 8($a0)
	jr  $ra      
cont:
	sub $sp, $sp, 16
	sw  $ra, 0($sp)
	sw  $s0, 4($sp)
	sw  $s1, 8($sp)	
	sw  $s2, 12($sp)
	
	
	move $s0, $a0
	lw  $a0, 12($s0)                   #ptr to the left
	jal value
	move $s1, $v0                      #left
	lw  $a0, 16($s0)                   #ptr to the right
	jal value
	move $s2, $v0                      #right
	
	lw  $t2, 0($s0)                    #node type in t2
			
	li  $t3, 7                         #const
	bne $t2, $t3, addop   
	lw  $v0, 8($s0)
	jr  $ra   
addop:
	li  $t3, 0                          #add
	bne $t2, $t3, subop
	add $t4, $s1, $s2
	sw  $t4, 8($s0)
	j   end
subop:
	li  $t3, 1                          #sub
	bne $t2, $t3, mulop
	sub $t4, $s1, $s2
	sw  $t4, 8($s0)
	j   end
mulop:
	li  $t3, 2                          #mul
	bne $t2, $t3, divop
	mul $t4, $s1, $s2
	sw  $t4, 8($s0)
	j   end
divop:
	li  $t3, 3                          #div
	bne $t2, $t3, remop
	div $t4, $s1, $s2
	sw  $t4, 8($s0)
	j   end
remop:
	li  $t3, 4                          #rem
	bne $t2, $t3, negop
	rem $t4, $s1, $s2
	sw  $t4, 8($s0)
	j   end
negop:
	li  $t3, 5                          #neg
	bne $t2, $t3, paren
	li  $t4, 0
	sub $t4, $t4, $s1
	sw  $t4, 8($s0)  
	j   end
paren:
	li  $t3, 6                          #paren
	bne $t2, $t3, end
	sw  $s1, 8($s0)  
	j   end
end:
	li  $t5, 1                          #computed = true
	sb  $t5, 4($s0) 
    lw  $v0, 8($s0)
     
	
	lw  $ra, 0($sp)
	lw  $s0, 4($sp)
	lw  $s1, 8($sp)	
	lw  $s2, 12($sp)
	                                                                                                                                                                                                                                                    	add $sp, $sp, 16	
	jr  $ra
