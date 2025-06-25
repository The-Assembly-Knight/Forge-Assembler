.section .rodata

.globl TWO_LEN_MNEMONIC
.globl THREE_LEN_MNEMONIC

TWO_LEN_MNEMONIC:
  .ascii "or"
  .asciz ""

THREE_LEN_MNEMONIC: # GOTTA PUT THIS IN ITS OWN FILE
  .ascii "mov"
  .ascii "jmp"
  .asciz ""

