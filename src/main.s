.file "main.s"


.extern open_file
.extern close_file
.extern read_from_file

.extern NO_ERROR
.extern ERROR
.extern EMPTY_FILE

.extern exit_successfully
.extern exit_unsuccessfully

.macro CHECK_EXIT_CODE label
  cmpq $NO_ERROR, %rax                 # if return code isnt NO_ERROR, redirect it to label (where the error is gonna be treated)
  jne \label
.endm

.section .rodata
.section .text

.globl _start

_start:
  call open_file
  CHECK_EXIT_CODE error_exit
 
  call read_from_file
  CHECK_EXIT_CODE error_reading_from_file 

  call close_file
  CHECK_EXIT_CODE error_exit



  jmp exit

error_reading_from_file:
  cmpq $EMPTY_FILE, %rax
  je exit

  jmp error_exit


exit:
  call exit_successfully

error_exit:
  call exit_unsuccessfully
