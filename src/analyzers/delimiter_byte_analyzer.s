.extern string0

.extern FILE_END

.macro GLOBL_FUNC val                  # declare a macro for global functions
  .globl \val
  .type \val, @function
.endm

.macro PRINT string
  push %rdx                            # save the value of rdx in the stack
  
  movq $1, %rax
  movq $1, %rdi
  movq $\string, %rsi
  movq $2, %rdx
  
  syscall

  pop %rdx                             # restore the value of %rdx

.endm

GLOBL_FUNC analyze_delimiter_byte
analyze_delimiter_byte:
  PRINT string0

  cmpq FILE_END(%rip), %rdx            # if curretn char is \0 then the return code will be FILE_END
  je reached_end_of_file

  ret

reached_end_of_file:
  movq FILE_END(%rip), %rax
  ret
