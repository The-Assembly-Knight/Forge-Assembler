.file "opener.s"

.extern OPEN_SYSCALL
.extern NO_FLAGS

.extern ERROR
.extern NO_ERROR

.macro GLOBL_FUNC name                 # declare a global function, including its debugging symbols
  .globl \name
  .type \name, @function
.endm

.macro globl_obj name                  # declare a global object, including its debugging symbols
  .globl \name
  .type \name, @object
.endm

.macro RET_CODE code
  movq \code, %rax
.endm

.section .rodata
FILE_NAME:
  .asciz "test_file"

.section .bss

GLOBL_OBJ FILE_DESCRIPTOR
FILE_DESCRIPTOR:
  .quad 0

.section .text

GLOBL_FUNC open_file
open_file:
  movq $OPEN_SYSCALL, %rax
  leaq FILE_NAME(%rip), %rdi
  movq $NO_FLAGS, %rsi

  syscall

  test %rax, %rax
  js no_successfully_opened

  jmp successfully_opened

successfully_opened:
  movq %rax, FILE_DESCRIPTOR(%rip)     # move file descriptor into file_d
  RET_CODE $NO_ERROR                   # return to main.s with a 0 error code
  ret

no_successfully_opened:
  RET_CODE $ERROR                      # return to main.s with a 1 error code
  ret
