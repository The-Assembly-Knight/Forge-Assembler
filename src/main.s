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

# Byte scanned return types
.extern FOUND_DELIMITER_CHAR
.extern FOUND_REGULAR_CHAR
.extern FOUND_CONCATENATIVE_CHAR

.extern analyze_regular_byte
.extern analyze_delimiter_byte
.extern analyze_concatenative_byte

.macro JUMP_TO_IF_EXIT_CODE_IS label exit_code 
  cmpq \exit_code, %rax
  je \label
.endm
 
.macro JUMP_TO_IF_EXIT_CODE_IS_NOT label exit_code 
  cmpq \exit_code, %rax
  jne \label
.endm

.section .text

.globl _start

_start:
  call open_file
  JUMP_TO_IF_EXIT_CODE_IS_NOT error_exit NO_ERROR(%rip)
 
  call read_from_file
  JUMP_TO_IF_EXIT_CODE_IS_NOT error_reading_from_file NO_ERROR(%rip)

tokenizing_loop:
  call next_byte
  JUMP_TO_IF_EXIT_CODE_IS concatenative FOUND_CONCATENATIVE_CHAR(%rip)
  JUMP_TO_IF_EXIT_CODE_IS regular       FOUND_REGULAR_CHAR(%rip)
  JUMP_TO_IF_EXIT_CODE_IS delimiter     FOUND_DELIMITER_CHAR(%rip)

close:
  call close_file
  JUMP_TO_IF_EXIT_CODE_IS_NOT error_exit NO_ERROR(%rip)

  jmp exit

concatenative:
  call analyze_concatenative_byte
  jmp tokenizing_loop

regular:
  call analyze_regular_byte
  jmp tokenizing_loop

delimiter:
  call analyze_delimiter_byte
  JUMP_TO_IF_EXIT_CODE_IS close FILE_END

  jmp tokenizing_loop


error_reading_from_file:
  cmpq EMPTY_FILE(%rip), %rax
  je exit

  jmp error_exit

exit:
  call exit_successfully

error_exit:
  call exit_unsuccessfully
