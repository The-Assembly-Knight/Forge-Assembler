.file "main.s"

.extern open_file
.extern close_file
.extern read_from_file

.extern NO_ERROR
.extern ERROR
.extern EMPTY_FILE

.extern exit_successfully
.extern exit_unsuccessfully

.extern next_byte

.extern END_OF_TOKEN
.extern NOT_END_OF_TOKEN

.macro CHECK_EXIT_CODE label adequate_exit_code
  cmpq \adequate_exit_code, %rax                 # if return code isnt the adequate onen, redirect it to label
  jne \label
.endm

.section .rodata
.section .text

.globl _start

_start:
  call open_file
  CHECK_EXIT_CODE error_exit NO_ERROR(%rip)
 
  call read_from_file
  CHECK_EXIT_CODE error_reading_from_file NO_ERROR(%rip)

  call next_byte
  CHECK_EXIT_CODE error_reading_from_file NOT_END_OF_TOKEN

  call close_file
  CHECK_EXIT_CODE error_exit NO_ERROR(%rip)


  jmp exit

error_reading_from_file:
  cmpq EMPTY_FILE(%rip), %rax
  je exit

  jmp error_exit


exit:
  call exit_successfully

error_exit:
  call exit_unsuccessfully
