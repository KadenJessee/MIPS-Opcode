- [About MIPS](#about-mips)
- [Software Requirements](#software-requirements)
- [Extra Resources](#extra-resources)
- [Procedure Template](#procedure-template)
  - [Procedure example](#procedure-example)

## About MIPS

MIPS is a reduced instruction set computer (RISC) instruction set architecture, currently used mostly in video game consoles and routers. It is also a popular architecture in introductory courses and textbooks on computer architecture, due to its simplicity relative to x86 and ARM. Here we use the 32-bit instruction set; a 64-bit instruction set also exists.

## Software Requirements

For this class, we use the popular MIPS simulator [MARS](http://courses.missouristate.edu/KenVollmar/mars/). Download the MARS jar archive from the MARS website and place it somewhere easily accessible. Also install the Java SDK if you do not have it already.
MIPS is a simple assembly language. If you have done some assembly language programming before, you may be able to get started with just [a reference card](http://www.cburch.com/cs/330/reading/mips-ref.pdf).

## Extra Resources

* [MIPS Green Sheet](https://inst.eecs.berkeley.edu/~cs61c/resources/MIPS_Green_Sheet.pdf)
* [cburch reference card](http://www.cburch.com/cs/330/reading/mips-ref.pdf)
* [MIPS syntax vim plugin](https://github.com/harenome/vim-mipssyntax)

## Procedure Template

Use this template for a any nested procedure.

```mips
###############################################################
# Description of procedure
#
# $a0 - input, first parameter (if needed)
# $a1 - input, second parameter (if needed)
# $v0 - output, sum of input parameters (if needed)
procedure_label:
 # Save registers to Stack
 subu $sp, $sp, 32   # frame size = 32, just because...
 sw $ra, 28($sp)   # preserve the Return Address.
 sw $fp, 24($sp)   # preserve the Frame Pointer.
 #sw $s0, 20($sp)   # preserve $s0 (if needed).
 #sw $s1, 16($sp)   # preserve $s1 (if needed).
 #sw $s2, 12($sp)   # preserve $s2 (if needed).
 addu $fp, $sp, 32   # move Frame Pointer to base of frame.
 
    #
 # Your code goes here
    #
 
 # Set return value (if needed)
 

end_procedure_label
 # Restore registers from Stack
 lw $ra, 28($sp)   # restore the Return Address.
 lw $fp, 24($sp)   # restore the Frame Pointer.
 #lw $s0, 20($sp)   # restore $s0.
 #lw $s1, 16($sp)   # restore $s1.
 #lw $s2, 12($sp)   # restore $s2.
 addu $sp, $sp, 32   # restore the Stack Pointer.
 
 jr $ra

###############################################################
```

Remember, if your procedure calls another procedure, you need to save/restore the values of some registers in the `stack`. Also, if you are modifying the `$s0, $s1, $s2, or $s3` registers, they also need to be saved and restored from the stack.  

### Procedure example

For example if your procedure has the following characteristics:

- Called `sum_two`
- Takes two input parameters: `$a0, and $a1`
- Uses `$s0 and $s1` inside the procedure
- Returns the result in `$v0`

```mips
###############################################################
# Returns the sum of the two input numbers
#
# $a0 - input, first parameter
# $a1 - input, second parameter
# $v0 - output, sum of input parameters
# Uses $s0: for input parameter (use inside procedure)
# Uses $s1: for input parameter (use inside procedure)
sum_two:
 # Save registers to Stack
 subu $sp, $sp, 32   # frame size = 32, just because...
 sw $ra, 28($sp)   # preserve the Return Address.
 sw $fp, 24($sp)   # preserve the Frame Pointer.
 sw $s0, 20($sp)   # preserve $s0 (if needed).
 sw $s1, 16($sp)   # preserve $s1 (if needed).
 #sw $s2, 12($sp)   # preserve $s2 (if needed).
 addu $fp, $sp, 32   # move Frame Pointer to base of frame.
 
 # Now your function begins here
 move $s0, $a0   # get n1 from caller
 move $s1, $a1   # get n2 from caller
 # Perform calculation
 and $t0, $s0, $s1
 
 # Set return value
 move $v0, $t0
 
end_sum_two:
 # Restore registers from Stack
 lw $ra, 28($sp)   # restore the Return Address.
 lw $fp, 24($sp)   # restore the Frame Pointer.
 lw $s0, 20($sp)   # restore $s0.
 lw $s1, 16($sp)   # restore $s1.
 #lw $s2, 12($sp)   # restore $s2.
 addu $sp, $sp, 32   # restore the Stack Pointer.
 
 jr $ra

###############################################################
```

---

- [About MIPS](#about-mips)
- [Software Requirements](#software-requirements)
- [Extra Resources](#extra-resources)
- [Procedure Template](#procedure-template)
  - [Procedure example](#procedure-example)
