.file "exit.s"

.extern EXIT_SYSCALL
.extern ERROR
.extern NO_ERROR

.macro GLOBL_FUNC val                  # declare a macro for global functions
  .globl \val
  .type \val, @function
.endm

.macro EXIT_SYS val                # declare a macro for all exit variants
  movq EXIT_SYSCALL(%rip), %rax
  movq \val, %rdi
  syscall
.endm


.section .text

GLOBL_FUNC exit_successfully
exit_successfully:
  EXIT_SYS NO_ERROR(%rip)

GLOBL_FUNC exit_unsuccessfully
exit_unsuccessfully:
  EXIT_SYS ERROR(%rip)
