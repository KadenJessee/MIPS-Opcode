
#
# Test difference_of_squares with some examples
#
# s0 - num of tests left to run
# s1 - address of input word
# s2 - address of expected output word
# s3 - input word
# s4 - output word
#
# difference_of_squares must:
# - be named difference_of_squares and declared as global
# - read input integer from a0
# - follow the convention of using the t0-9 registers for temporary storage
# - (if it wants to use s0-7 then it is responsible for pushing existing values to the stack then popping them back off before returning)
# - write integer result to v0

.data

n: .word 4                             # number of test cases
ins:	.word 0x01095020, 		# add $t2, $t0, $t1
	.word 0x1220002C,  		# beqz $s1, label
	.word 0x3C011001,		# lw $a0, label($s0)
	.word 0x24020004,		# li $v0, 4
	.word 0x08100002		# j label
outs: .word  0x00, 0x04, 0x0F, 0x09, 0x02  # expected result

failmsg: .asciiz "failed for test input: "
expectedmsg: .asciiz ". expected "
tobemsg: .asciiz " to be "
okmsg: .asciiz "all tests passed"

.text

runner:
        lw      $s0, n
        la      $s1, ins
        la      $s2, outs
        li      $t5, 0

run_test:
        lw      $s3, 0($s1)             # read input from memory
        move    $a0, $s3                # move it to a0
        jal     decode_instruction   # call subroutine under test
        move    $v1, $v0                # move return value in v0 to v1 because we need v0 for syscall

        lw      $s4, 0($s2)             # read expected output from memory
        bne     $v1, $s4, exit_fail     # if expected doesn't match actual, jump to fail
        j after_ok                      # test is good

after_fail:
        addi $t5, $t5, 1                # increment error

after_ok:
        addi    $s1, $s1, 4             # move to next word in input
        addi    $s2, $s2, 4             # move to next word in output
        sub     $s0, $s0, 1             # decrement num of tests left to run
        bgt     $s0, $zero, run_test    # if more than zero tests to run, jump to run_test
bnez    $t5, done
exit_ok:
        la      $a0, okmsg              # put address of okmsg into a0
        li      $v0, 4                  # 4 is print string
        syscall

        li      $v0, 10                 # 10 is exit with zero status (clean exit)
        syscall

exit_fail:
        la      $a0, failmsg            # put address of failmsg into a0
        li      $v0, 4                  # 4 is print string
        syscall

        move    $a0, $s3                # set arg of syscall to input that failed the test
        li      $v0, 34                 # 34 is print int in hex
        syscall

        la      $a0, expectedmsg
        li      $v0, 4
        syscall

        move    $a0, $v1                # print actual that failed on
        li      $v0, 34
        syscall

        la      $a0, tobemsg
        li      $v0, 4
        syscall

        move    $a0, $s4                # print expected value that failed on
        li      $v0, 34
        syscall

        j after_fail                    # run next test

done:
        li      $a0, 1                  # set exit code to 1
        li      $v0, 17                 # terminate with the exit code in $a0
        syscall

# # Include your implementation here if you wish to run this from the MARS GUI.
# .include "impl.mips"
