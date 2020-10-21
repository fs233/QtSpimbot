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
		lw      $t3, 0xffff001c($zero)    
		add     $t3, $t3, 24000
loop1:
	    lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next1
		jal     go_right
		j       loop1
		
next1:	
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 56000
loop2:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next2
		jal     go_down
		j       loop2
next2:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 56000
loop3:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next3
		jal     go_right
		j       loop3
next3:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 64000	
loop4:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next4
		jal     go_down
		j       loop4
next4:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 24000
loop5:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next5
		jal     go_right
		j       loop5	
next5:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 8000
loop6:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next6
		jal     go_down
		j       loop6	
next6:
		li      $t0, 1
		sw      $t0, 0xffff00f4($0)
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 32000
loop7:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next7
		jal     go_down
		j       loop7
next7:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 16000
loop8:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next8
		jal     go_right
		j       loop8
next8:	
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 48000
loop9:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next9
		jal     go_down
		j       loop9
next9:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 40000
loop10:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next10
		jal     go_left
		j       loop10
next10:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 24000
loop11:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next11
		jal     go_down
		j       loop11
next11:
		li      $t0, 1
		sw      $t0, 0xffff00f4($0)
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 32000
loop12:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next12
		jal     go_right
		j       loop12
next12:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 24000
loop13:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next13
		jal     go_up
		j       loop13
next13:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 8000
loop14:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next14
		jal     go_right
		j       loop14
next14:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 32000
loop15:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next15
		jal     go_up
		j       loop15
next15:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 96000
loop16:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next16
		jal     go_right
		j       loop16
next16:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 8000
loop17:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next17
		jal     go_down
		j       loop17
next17:
		li      $t0, 1
		sw      $t0, 0xffff00f4($0)
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 16000
loop18:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next18
		jal     go_down
		j       loop18
next18:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 32000
loop19:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next19
		jal     go_right
		j       loop19
next19:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 64000
loop20:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next20
		jal     go_down
		j       loop20
next20:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 32000
loop21:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next21
		jal     go_right
		j       loop21
next21:
		lw      $t3, 0xffff001c($zero)   
		add     $t3, $t3, 8000
loop22:
		lw      $t4, 0xffff001c($zero)
		bge     $t4, $t3, next22
		jal     go_down
		j       loop22
next22:
		li      $t0, 1
		sw      $t0, 0xffff00f4($0)
		j		infinite

go_right:		
		li      $t0, 0
		sw      $t0, 0xffff0014($zero)
		li      $t1, 1
		sw      $t1, 0xffff0018($zero)
		li      $t2, 10
		sw      $t2, 0xffff0010($zero)
		jr      $ra	
go_left:		
		li      $t0, 0
		sw      $t0, 0xffff0014($zero)
		li      $t1, 1
		sw      $t1, 0xffff0018($zero)
		li      $t2, -10
		sw      $t2, 0xffff0010($zero)
		jr      $ra	
go_down:
		li      $t0, 90
		sw      $t0, 0xffff0014($zero)
		li      $t1, 1
		sw      $t1, 0xffff0018($zero)
		li      $t2, 10
		sw      $t2, 0xffff0010($zero)
		jr      $ra
go_up:
		li      $t0, 90
		sw      $t0, 0xffff0014($zero)
		li      $t1, 1
		sw      $t1, 0xffff0018($zero)
		li      $t2, -10
		sw      $t2, 0xffff0010($zero)
		jr      $ra


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
