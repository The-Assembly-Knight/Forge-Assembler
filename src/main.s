.section .rodata

  .extern open_file

.section .text

.globl _start

_start:
  call open_file
  call exit


