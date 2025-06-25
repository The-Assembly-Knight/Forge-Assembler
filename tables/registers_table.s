.section .rodata

# 64bit registers
.globl TWO_LEN_64_REG
.globl THREE_LEN_64_REG

# 32bit registers
.globl THREE_LEN_32_REG
.globl FOUR_LEN_32_REG

# 8bit registers
.globl TWO_LEN_8_REG
.globl THREE_LEN_8_REG
.globl FOUR_LEN_8_REG

TWO_LEN_64_REG:
  .ascii "r8"
  .ascii "r9"
  .asciz ""

THREE_LEN_64_REG:
  .ascii "rax"
  .ascii "rcx"
  .ascii "rdx"
  .ascii "rbx"
  .ascii "rsp"
  .ascii "rbp"
  .ascii "rsi"
  .ascii "rdi"
  .ascii "r10"
  .ascii "r11"
  .ascii "r12"
  .ascii "r13"
  .ascii "r14"
  .ascii "r15"
  .asciz ""

THREE_LEN_32_REG:
  .ascii "eax"
  .ascii "ecx"
  .ascii "edx"
  .ascii "ebx"
  .ascii "esp"
  .ascii "ebp"
  .ascii "esi"
  .ascii "edi"
  .ascii "r8d"
  .ascii "r9d"
  .asciz ""

FOUR_LEN_32_REG:
  .ascii "r10d"
  .ascii "r11d"
  .ascii "r12d"
  .ascii "r13d"
  .ascii "r14d"
  .ascii "r15d"
  .asciz ""

TWO_LEN_8_REG:
  .ascii "al" 
  .ascii "cl" 
  .ascii "dl" 
  .ascii "bl"
  .asciz ""

THREE_LEN_8_REG:
  .ascii "spl" 
  .ascii "bpl" 
  .ascii "sil" 
  .ascii "dil" 
  .ascii "r8b" 
  .ascii "r9b" 
  .asciz "" 

FOUR_LEN_8_REG:
  .ascii "r10b"
  .ascii "r11b"
  .ascii "r12b"
  .ascii "r13b"
  .ascii "r14b"
  .ascii "r15b"
  .asciz ""
