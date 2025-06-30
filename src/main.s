.file "main.s"

.macro CHECK_EXIT_CODE                 # goal: exit if error code was returned by callee
  cmpq $ERROR, %rax                    # if exit code is an error.
  je error_exit                        # exit the program immediately with a 1 exit code.
.endm

.section .rodata

  .extern open_file
  .extern close_file

  .extern ERROR

  .extern exit_successfully
  .extern exit_unsuccessfully


.section .text

.globl _start

_start:
  call open_file
  CHECK_EXIT_CODE

  call close_file
  CHECK_EXIT_CODE

  jmp exit

exit:
  call exit_successfully

error_exit:
  call exit_unsuccessfully
