.extern string1
  
.macro GLOBL_FUNC val                  # declare a macro for global functions
  .globl \val
  .type \val, @function
.endm

.macro PRINT string
  movq $1, %rax
  movq $1, %rdi
  movq $\string, %rsi
  movq $2, %rdx
  
  syscall

.endm

GLOBL_FUNC analyze_regular_byte
analyze_regular_byte:
  PRINT string1
  ret
