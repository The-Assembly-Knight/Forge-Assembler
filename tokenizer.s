.section .rodata

FILE_NAME:
  .asciz "test_file"

.section .bss

input_buffer:
  .skip 65536

token_buffer:
  .skip 32

.section .text
.globl _start

_start:

open_file:
  movq $2, %rax                        # open syscall
  movq $FILE_NAME, %rdi                # open file with the name FILE_NAME
  movq $0, %rsi

  syscall

  movq %rax, %r15                      # save file descriptor

reading_file:
  movq $0, %rax                        # read syscall
  movq %r15, %rdi                      # reading from file descriptor
  movq $input_buffer, %rsi             # using input_buffer as the buffer
  movq $65536, %rdx                    # reading 65536 bytes from the file

  syscall

  test %rax, %rax
  js error_reading_from_file
  je exit

error_reading_from_file:
  movq $60, %rax                       # exit syscall
  movq $1, %rdi                        # set exit code to 1

  syscall

exit:
  movq $60, %rax                       # exit syscall
  movq $0, %rdi                        # set exit code to 0

  syscall
