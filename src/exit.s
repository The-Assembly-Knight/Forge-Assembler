.file "exit.s"

.macro GLOBL_FUNC val                  # declare a macro for global functions
  .globl \val
  .type \val, @function
.endm

.macro EXIT_SYSCALL val                # declare a macro for all exit variants
  movq $EXIT_SYSCALL, %rax
  movq $\val, %rdi
  syscall
.endm

.section .rodata

  .extern EXIT_SYSCALL
  .extern ERROR
  .extern NO_ERROR

.section .text

GLOBL_FUNC exit_successfully
exit_successfully:
  EXIT_SYSCALL NO_ERROR

GLOBL_FUNC exit_unsuccessfully
exit_unsuccessfully:
  EXIT_SYSCALL ERROR
