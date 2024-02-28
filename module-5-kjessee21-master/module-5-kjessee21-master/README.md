# Module 5 Challenge Activity: MIPS Procedures

- [Module 5 Challenge Activity: MIPS Procedures](#module-5-challenge-activity-mips-procedures)
	- [Learning Activities](#learning-activities)
	- [Purpose](#purpose)
	- [Skills and Knowledge](#skills-and-knowledge)
	- [Task 1: Loop over array of values](#task-1-loop-over-array-of-values)
		- [Sample Output Task 1](#sample-output-task-1)
	- [Task 2: Parse MIPS Instruction](#task-2-parse-mips-instruction)
		- [Task 2: Procedure Algorithm Logic](#task-2-procedure-algorithm-logic)
		- [Test it in main](#test-it-in-main)
		- [Sample Output Task 2](#sample-output-task-2)
	- [Task 3: Process MIPS Instruction](#task-3-process-mips-instruction)
		- [Task 3: Procedure Algorithm Logic](#task-3-procedure-algorithm-logic)
		- [Test Process MIPS Instruction](#test-process-mips-instruction)
		- [Sample Output Task 3](#sample-output-task-3)
	- [Submission Checklist](#submission-checklist)
	- [Other Resources](#other-resources)
  
## Learning Activities

The learning activities related to this assignment are in the `la` folder of this project. If you need to review the concepts, follow the [LA description](la/README.md)

## Purpose

The purpose of this assignment is to help you understand how to use procedures(functions) in MIPS that call other procedures. For that, we are going to parse some mips instructions and do some analysis with them.

Follow the directions closely. In several places you could solve the problem multiple ways but your grade will be based on using the required approach. For example, It is possible to solve the problem without managing the stack or using a nested procedure call but you will not acheive mastery using that approach. 

## Skills and Knowledge

The goal of this lab is to practice the following skills:

1. Working with tables
2. Save registers to the **stack**
3. Nested Procedures
4. Working with multiple files

## Task 1: Loop over array of values

Your first task is to loop over the array of `words` representing `MIPS Instructions`. As you loop over the items, display their value using a message.  

Begin working in the file template (`ca.asm`) provided in the `ca` folder. To make your output messages more readable, use the `print_hex_info` provided in the template.  This procedure takes two input parameters, the first is the string to print, and the second the value.

```mips
# Data for the program goes here
.data
 process: .asciiz "\nNow processing instruction "
 newLine: .asciiz "\n"

 # number of test cases
 CASES: .word 5
 # array of pointers (addresses) to the instructions
 instructions: .word 0x01095020,   # add $t2, $t0, $t1
     .word 0x1220002C,    # beqz $s1, label
     .word 0x3C011001,  # lw $a0, label($s0)
     .word 0x24020004,  # li $v0, 4
     .word 0x08100002  # j label
# Code goes here
.text
main:
 # Task 1: Loop over the array of instructions

loop_array:
 #  Set registers and call: print_hex_info

 j loop_array  # end of loop
  

end_main:
 li $v0, 10  # 10 is the exit program syscall
 syscall   # execute call

## end of ca.asm
```

### Sample Output Task 1

![task1](images/task1.png)

## Task 2: Parse MIPS Instruction

Your next task is to create a procedure called `decode_instruction`. This procedure will take the `MIPS Instruction` from [Task 1](#task-1-loop-over-array-of-values) as input parameter. Your procedure should parse the `opcode` from the input parameter and return it to the caller for display.

The procedure should have the following signature:

```mips
###############################################################
# Fetch instruction to correct procedure based on opcode for
# instruction parsing.
#
# $a0 - input, 32-bit instruction to process
# $v0 - output, instruction opcode (bits 31-26) value (required)
# Uses $s0: for input parameter (required)
# Uses $s1: for opcode value (required)
decode_instruction:
 # Save registers to Stack
 # ...

 # Your function "real" code begins here
 # ...

 # Isolate opcode (bits 31-26) 1111 1100 0000 0000 0000 0000 0000 0000

 # Task 3 (later): Set/Values call process_instruction_procedure

 # Set return value

end_decode_instruction:
 # Restore registers from Stack
 # ...

 jr $ra
```

Note that this procedure will eventually call other procedures. For this reason, make sure you allocate some space in the `stack` and save all the required registers. You may follow the [Procedure Template](./HOWTO#Procedure-Template).

### Task 2: Procedure Algorithm Logic

The instruction's opcode comes in the 6 most significant bits of the address (31-26).

1. Save input parameters `$a0 and $a1` into `$s0, and $s1`.
2. Isolate opcode (bits 31-26) 1111 1100 0000 0000 0000 0000 0000 0000
3. Right shift 26 positions the opcode.
4. Set return register `$v0` with value.

### Test it in main

Inside your loop, call the `decode_instruction` procedure and once again, call the `print_hex_info` procedure to display the opcode value.

```mips
# Data for the program goes here
.data
 # ...
 opcode_num: .asciiz "\tThe opcode value is: "

# Code goes here
.text
main:
 # ...
loop_array:
 #  Set registers and call: print_hex_info for process string

 # Task 2:
 #  Set registers and call: decode_instruction

 #  Set registers and call: print_hex_info for opcode_num string

 # ...
 j loop_array  # end of loop

end_main:
  li $v0, 10  # exit program syscall
  syscall

## end of ca.asm
```

### Sample Output Task 2

![task2-1](images/task2_1.png)

## Task 3: Process MIPS Instruction

Your next task is to create another procedure called `process_instruction`. This procedure will take the `MIPS Instruction opcode` from [Task 2](#task-2-parse-mips-instruction) as input parameter. Your procedure should display the corresponding instruction type string based on the input.

 For this assignment, you are only required to support `branches` and `R-type` instructions. Any other value for the opcode should display `Unsupported Instruction`. Your code should support the following choices:

| Opcode | Instruction Type        |
|--------|-------------------------|
| 0      | R-Type Instruction      |
| 2 or 3 | Unconditional Branch    |
| 4 or 5 | Conditional Branch      |
| other  | Unsupported Instruction |

### Task 3: Procedure Algorithm Logic

The instruction's opcode comes in the 6 most significant bits of the address (31-26).

1. Save input parameters `$a0 to $s0`.
2. Based on the opcode value print the corresponding string message.

Note: You may use a "switch" statement to process all choices.

```mips
# Data for the program goes here
.data
 # ...
 inst_0:  .asciiz "\tR-Type Instruction\n"
 inst_other: .asciiz "\tUnsupported Instruction\n"
 inst_2_3: .asciiz "\tUnconditional Jump\n"
 inst_4_5: .asciiz "\tConditional Jump\n"
 # ...
###############################################################
# Process instruction: print instruction type
#
# $a0 - input, 32-bit instruction to process
# Uses $s0: for input parameter (required)
process_instruction:
 # Save registers to Stack
 # ...

 # Your function code begins here
 
  
end_process_instruction:
 # Restore registers from Stack
 # ...
 
    jr $ra
```

### Test Process MIPS Instruction

To test this procedure, go back to the `decode_procedure`. In there and before you return the value, call the `process_instruction` with the `opcode` as input parameter.

```mips
 # Inside the decode_instruction procedure
 #
 # ...
 # Isolate opcode (bits 31-26) 1111 1100 0000 0000 0000 0000 0000 0000

 # Task 3: Set/Values CALL process_instruction_procedure

 # Set return value
```

### Sample Output Task 3

![task3](images/task3.png)

## Submission Checklist

- [ ] Save and `commit` my code in github desktop
- [ ] `Push` the code to github.com
- [ ] Uploaded video of code walk-through  in `Canvas`
- [ ] Add your github repo as a comment to your assignment in `Canvas`.

## Other Resources

For more information on MIPS go to [How to page](HOWTO.md)
