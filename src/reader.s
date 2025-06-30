.section .rodata

  .extern OPEN_SYSCALL
  .extern CLOSE_SYSCALL
  .extern NO_FLAGS

FILE_NAME:
  .asciz "test_file"

.section .bss

FILE_DESCRIPTOR:
  .quad 0

input_buffer:
  .skip 65536

.section .text

open_file:
  movq $OPEN_SYSCALL, %rax
  movq $FILE_NAME, %rdi
  movq $NO_FLAGS, %rsi

  syscall

  test %rax, %rax
  js error_exit

  movq $FILE_DESCRIPTOR, %rbx          # get a pointer to file_d
  movq %rax, (%rbx)                    # move file descriptor into file_d

  xorq %rbx, %rbx

  jmp close_file

close_file:
  movq $CLOSE_SYSCALL, %rax
  movq $FILE_DESCRIPTOR, %rdi
  syscall

  jmp exit

error_exit:
  movq $EXIT_SYSCALL, %rax
  movq $ERROR, %rdi
  syscall

exit:
  movq $EXIT_SYSCALL, %rax
  movq $NO_ERROR, %rdi
  syscall

