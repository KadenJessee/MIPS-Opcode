# Author: Kaden Jessee
# Date: 22 Mar 2022
# Description: Parse MIPS instructions based on opcode and print message

.globl main, decode_instruction, process_instruction, print_hex_info	# Do not remove this line

# Data for the program goes here
.data
	process: .asciiz "\nNow processing instruction "
	newLine: .asciiz "\n"
	
	opcode_num: .asciiz "\tThe opcode value is: "

	# number of test cases
	CASES: .word 5
	# array of pointers (addresses) to the instructions
	instructions:	.word 0x01095020, 		# add $t2, $t0, $t1
			.word 0x1220002C,  		# beqz $s1, label
			.word 0x3C011001,		# lw $a0, label($s0)
			.word 0x24020004,		# li $v0, 4
			.word 0x08100002		# j label
	
	inst_0:		.asciiz "\tR-Type Instruction\n"
	inst_other:	.asciiz "\tUnsupported Instruction\n"
	inst_2_3:	.asciiz "\tUnconditional Jump\n"
	inst_4_5:	.asciiz "\tConditional Jump\n"

	# Note: You may use a table for the instruction strings
	inst_types: .word inst_0, inst_other, inst_2_3, inst_2_3, inst_4_5, inst_4_5

# Code goes here
# t0 - size of cases
# t1 - holds instructions array
# t2 - loop counter
# t3 - counter for going through array
# a0 - holds values to print (either string or values from instructions)
# s0 - contains message to print
# s1 - contains value from a1 (value to print)

.text
main:
	# Task 1: Loop over the array of instructions 
	lw $t0, CASES		#gets size
	li $t2, 0	#set loop counter
	li $t3, 0	#sets counter for going through array
	la $s3, instructions
loop_array:
	
	# 	Set registers and call: print_hex_info for process string
	beq $t2, $t0, end_main
	
	la $a0, process		#load process statement into a0
	lw $a1, 0($s3)		#load instructions array ($s0) into $a1
	addi $s3, $s3, 4	#increment the pointer to next element --
	jal print_hex_info	#jal the print hex info
	
	addi  $t2, $t2, 1	#increment the loop counter by 1
	# 	Task 2: Set registers and call: decode_instruction
	move $a0, $a1		#get value from toPrint
	jal decode_instruction	#call decode instruction
	
	# 	Set registers and call: print_hex_info for opcode_num string
	la $a0, opcode_num	#move string to parameter
	move $a1, $v0		#move opcode to parameter
	jal print_hex_info	#call printHex
	
	
	j loop_array		# end of loop
		
end_main:
	li $v0, 10		# 10 is the exit program syscall
	syscall			# execute call

## end of ca.asm

###############################################################
# Fetch instruction to correct procedure based on opcode for 
# instruction parsing.
#
# $a0 - input, 32-bit instruction to process
# $v0 - output, instruction opcode (bits 31-26) value (required)
# Uses $s0: for input parameter (required)
# Uses $s1: for opcode value (required)
decode_instruction:
	#Save registers to stack
	subu $sp, $sp, 32	#frame size = 32 (begin allocation)
	sw $ra, 28($sp)		#preserve the return address (required)
	sw $fp, 24($sp)		#preserve the frame pointer (required)
	sw $s0, 20($sp)		#preserve $s0 (if needed)
	sw $s1, 16($sp)		#preserve $s1 (if needed)
	addu $fp, $sp, 32	#move frame pointer to base frame (end allocation)
	
	# Now your function begins here
	move $s0, $a0			#input parameters
	andi $s1, $a0, 0xFC000000	#isolate opcode
	srl $s1, $s1, 26		#right shift 26 positions
	
	
	# Task 3: Set/Values call procedure
	move $a0, $s1
	jal process_instruction
	# Set return value
	move $v0, $s1			#set return reigster
end_decode_instruction:
	# Restore registers from Stack
	lw $ra, 28($sp)		#restore the return address (required)
	lw $fp, 24($sp)		#restore the fram pointer (required)
	lw $s0, 20($sp)		#restore $s0 (if needed)
	sw $s1, 16($sp)		#restore $s1 (if needed)
	addu $sp, $sp, 32	#move frame pointer to base frame (end allocation)
	
	jr $ra

###############################################################
# Process instruction: print instruction type
#
# $a0 - input, 32-bit instruction to process
# Uses $s0: for input parameter (required)
process_instruction:
	# Save registers to Stack
	subu $sp, $sp, 32	#frame size = 32 (begin allocation)
	sw $ra, 28($sp)		#preserve the return address (required)
	sw $fp, 24($sp)		#preserve the frame pointer (required)
	sw $s0, 20($sp)		#preserve $s0 (if needed)
	sw $s1, 16($sp)		#preserve $s1 (if needed)
	addu $fp, $sp, 32	#move frame pointer to base frame (end allocation)

	# Now your function begins here
	move $s0, $a0	#save input parameters
	beqz $s0, r_type
	beq $s0, 2, u_branch	#unconditional branch 2 or 3
	beq $s0, 3, u_branch
	beq $s0, 4, c_branch	#conditional branch 4 or 5
	beq $s0, 5, c_branch
	j unsupported

r_type:
	la $a0, inst_0
	li $v0, 4
	syscall
	j end_process_instruction
	
u_branch:
	la $a0, inst_2_3
	li $v0, 4
	syscall
	j end_process_instruction
	
c_branch:
	la $a0, inst_4_5
	li $v0, 4
	syscall
	j end_process_instruction
	
unsupported:
	la $a0, inst_other
	li $v0, 4
	syscall
	j end_process_instruction
		
end_process_instruction:
	# Restore registers from Stack
	lw $ra, 28($sp)		#restore the return address (required)
	lw $fp, 24($sp)		#restore the fram pointer (required)
	lw $s0, 20($sp)		#restore $s0 (if needed)
	sw $s1, 16($sp)		#restore $s1 (if needed)
	addu $sp, $sp, 32	#move frame pointer to base frame (end allocation)
	
    jr $ra

###############################################################
# Print Message based on opcode type
#
# $a0 - Message to print
# $a1 - Value to print
# Uses $s0: address of string for $a0 (required)
# Uses $s1: value from $a1 (required)
print_hex_info:
	# Save registers to Stack
	subu $sp, $sp, 32 		# frame size = 32, just because...
	sw $ra, 28($sp) 		# preserve the Return Address.
	sw $fp, 24($sp) 		# preserve the Frame Pointer.
	sw $s0, 20($sp) 		# preserve $s0.
	sw $s1, 16($sp) 		# preserve $s1.
	#sw $s2, 12($sp) 		# preserve $s2.
	addu $fp, $sp, 32 		# move Frame Pointer to base of frame.

	# Now your function begins here
	move $s0, $a0
	move $s1, $a1
	
	li $v0, 4				# print message
	move $a0, $s0
	syscall
	
	li $v0, 34				# print address in hex value
	move $a0, $s1
	syscall
	
	li $v0, 4				# print message
	la $a0, newLine
	syscall

end_print_hex_info:
	# Restore registers from Stack
	lw $ra, 28($sp) 		# restore the Return Address.
	lw $fp, 24($sp) 		# restore the Frame Pointer.
	lw $s0, 20($sp) 		# restore $s0.
	lw $s1, 16($sp) 		# restore $s1.
	#lw $s2, 12($sp) 		# restore $s2.
	addu $sp, $sp, 32 		# restore the Stack Pointer.
	
    	jr $ra
