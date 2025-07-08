.extern string2

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

GLOBL_FUNC analyze_concatenative_byte
analyze_concatenative_byte:
  PRINT string2
  ret

