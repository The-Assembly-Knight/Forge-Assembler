.file "closer.s"

.extern CLOSE_SYSCALL

.extern ERROR
.extern NO_ERROR

.extern FILE_DESCRIPTOR

.macro GLOBL_FUNC name                 # declare a global function, including its debugging symbols
  .globl \name
  .type \name, @function
.endm

.macro RET_CODE code
  movq \code, %rax
.endm

.section .text

GLOBL_FUNC close_file
close_file:
  movq CLOSE_SYSCALL(%rip), %rax
  movq FILE_DESCRIPTOR(%rip), %rdi     # pass file descriptor value to close said fd
  syscall

  test %rax, %rax
  js no_successfully_closed

  jmp successfully_closed

successfully_closed:
  RET_CODE NO_ERROR(%rip)              # return to main.s with a 0 error code
  ret

no_successfully_closed:
  RET_CODE ERROR(%rip)                 # return to main.s with a 1 error code
  ret
