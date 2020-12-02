.data
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

REQUEST_PUZZLE          = 0xffff00d0  ## Puzzle
SUBMIT_SOLUTION         = 0xffff00d4  ## Puzzle

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000      
TIMER_ACK               = 0xffff006c 

REQUEST_PUZZLE_INT_MASK = 0x800       ## Puzzle
REQUEST_PUZZLE_ACK      = 0xffff00d8  ## Puzzle

PICKUP                  = 0xffff00f4

minibot_info            = 0x0000ffff    #the addr of the minibot_info
kernel_location         = 0x0008ffff    #addr of the kernel loc 
map                     = 0x000fffff    #addr of the map
# Add any MMIO that you need here (see the Spimbot Documentation)

### Puzzle
GRIDSIZE = 8
has_puzzle:        .word 0                         
puzzle:      .half 0:2000             
heap:        .half 0:2000
#### Puzzle



.text
main:
# Construct interrupt mask
	    li      $t4, 0
        or      $t4, $t4, REQUEST_PUZZLE_INT_MASK # puzzle interrupt bit
        or      $t4, $t4, TIMER_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, BONK_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, 1                       # global enable
	    mtc0    $t4, $12

#Fill in your code here




#spawn adv minibots
        li      $t0, 1
        sw      $t0, 0xffff00dc($zero)
        sw      minibot_info, 0xffff2014         #info at the addr
        lw      $t1, minibot_info($zero)         #minibot count
        li      $t2, 1
        bge     $t1, $t2, control_minibot        #when a minibot exist
        j       #go back to some where 

control_minibot:
        jal	find_the_first_kernel
        move    $t1, $v0                        #num of the tile of the kernal
        li      $t2, 40
        div     $t3, $t1, $t2                   #(b,a) b in t3
        mul     $t4, $t3, $t2
        sub     $t4, $t1, $t4                   # a in t4
        sll     $t1, $t3, 2                     #b shift left 2 bit
        add     $t1, $t1, $t4                   #the dest of the minibot
        sw      $t1, 0xffff00e4($zero)
        sw      $t1, 0xffff00e8($zero)          #set the adv minibot to the addr
        sw      minibot_info, 0xffff2014         #info at the addr
        lw      $t1, minibot_info($zero)         #minibot count
        li      $t2, 3
        bge     $t1, $t2, build_silo            #when >=3 minibots go and build
        j       #continue to collect until we can build a silo


build_silo:
        sw      map, 0xffff00f0($zero)          #map struct at the addr
        li      $t1, 420
        lw      $t2, map($t1)
        li      $t3, 2
        beq     $t2, $t3, silo_exist            #check if there a silo at the position
        li      $t0, 0x00002020
        sw      $t0, 0xffff00e4($zero)
        sw      $t0, 0xffff00e8($zero)           #set the adv minibot to the addr
        sw      $t0, 0xffff2000($zero)           #BUILD SILO
	j	build_silo

silo_exist:
        li      $t0, 1
        sw      $t0, 0xffff00dc($zero)
move_minibot:
        jal	find_the_first_kernel
        move    $t6, $v0
        move    $t1, $v0                        #num of the tile of the kernal
        li      $t2, 40
        div     $t3, $t1, $t2                   #(b,a) b in t3
        mul     $t4, $t3, $t2
        sub     $t4, $t1, $t4                   # a in t4
        sll     $t1, $t3, 2                     #b shift left 2 bit
        add     $t1, $t1, $t4                   #the dest of the minibot
        sw      $t1, 0xffff00e4($zero)
        sw      $t1, 0xffff00e8($zero)          #set the adv minibot to the addr
wait_until_get:
        sw      map, 0xffff00f0($zero)          #map struct at the addr
        lw      $t1, map($t6)                   #situation at the dest
        bne     $t1, $zero, wait_until_get      #haven't get go back
        li      $t0, 0x00002020
        sw      $t0, 0xffff00e4($zero)
        sw      $t0, 0xffff00e8($zero)          #go back to the silo
        j       silo_exist
        







        			






#function to find the first kernal avaliable
find_the_first_kernel:
        sub     $sp, $sp, 8		
	sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      kernel_location, 0xffff200c($zero)
        li      $s0, 0                          #i=0
for_kernals:
        add     $t2, $s0, 4                     #offset of the tile
        lw      $t3, kernal_location($t2)       #kernal count of tile i
        bne     $t3, $zero, return
        add     $s0, $s0, 1     
        j	for_kernels			
return:
        move    $v0, $s0	
	lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        add     $sp, $sp, 8	
        jr	$ra	







        

        






infinite:
        j       infinite              # Don't remove this! If this is removed, then your code will not be graded!!!

.kdata
chunkIH:    .space 8  #TODO: Decrease this
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
        move      $k1, $at              # Save $at
.set at
        la      $k0, chunkIH
        sw      $a0, 0($k0)             # Get some free registers
        sw      $v0, 4($k0)             # by storing them to a global variable

        mfc0    $k0, $13                # Get Cause register
        srl     $a0, $k0, 2
        and     $a0, $a0, 0xf           # ExcCode field
        bne     $a0, 0, non_intrpt

interrupt_dispatch:                     # Interrupt:
        mfc0    $k0, $13                # Get Cause register, again
        beq     $k0, 0, done            # handled all outstanding interrupts

        and     $a0, $k0, BONK_INT_MASK # is there a bonk interrupt?
        bne     $a0, 0, bonk_interrupt

        and     $a0, $k0, TIMER_INT_MASK # is there a timer interrupt?
        bne     $a0, 0, timer_interrupt

        and 	$a0, $k0, REQUEST_PUZZLE_INT_MASK
        bne 	$a0, 0, request_puzzle_interrupt

        li      $v0, PRINT_STRING       # Unhandled interrupt types
        la      $a0, unhandled_str
        syscall
        j       done

bonk_interrupt:
        sw      $0, BONK_ACK
#Fill in your code here
        j       interrupt_dispatch      # see if other interrupts are waiting

request_puzzle_interrupt:
        sw      $0, REQUEST_PUZZLE_ACK
#Fill in your code here
        j	interrupt_dispatch

timer_interrupt:
        sw      $0, TIMER_ACK
#Fill in your code here
        j   interrupt_dispatch
non_intrpt:                             # was some non-interrupt
        li      $v0, PRINT_STRING
        la      $a0, non_intrpt_str
        syscall                         # print out an error message
# fall through to done

done:
        la      $k0, chunkIH
        lw      $a0, 0($k0)             # Restore saved registers
        lw      $v0, 4($k0)

.set noat
        move    $at, $k1                # Restore $at
.set at
        eret
