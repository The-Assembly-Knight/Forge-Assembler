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

.extern FILE_END
.extern END_OF_TOKEN
.extern NOT_END_OF_TOKEN

.extern string1
.extern string0

.macro PRINT string
  movq $1, %rax
  movq $1, %rdi
  movq $\string, %rsi
  movq $2, %rdx
  
  syscall

.endm

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

tokenizing_loop:
  call next_byte
  CHECK_EXIT_CODE check_if_end NOT_END_OF_TOKEN
  
  jmp print1

close:
  call close_file
  CHECK_EXIT_CODE error_exit NO_ERROR(%rip)

  jmp exit


check_if_end:
  cmpq FILE_END(%rip), %rdx
  je close
  jne print0

print0:
  PRINT string0
  jmp tokenizing_loop

print1:
  PRINT string1
  jmp tokenizing_loop

error_reading_from_file:
  cmpq EMPTY_FILE(%rip), %rax
  je exit

  jmp error_exit

exit:
  call exit_successfully

error_exit:
  call exit_unsuccessfully
