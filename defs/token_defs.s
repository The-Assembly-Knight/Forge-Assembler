.file "token_defs.s"

.macro SET_GLOBL_DEF name, val
  .globl \name

  .type \name, @object
 
  \name: 
  .quad \val
.endm

.macro GLOBL_OBJ name                  # declare a global object, including its debugging symbols
  .globl \name
  .type \name, @object
.endm

.section .rodata

GLOBL_OBJ TOKEN_PROPERTIES
TOKEN_PROPERTIES:
  .quad 0                              # address start of token.
  .long 0                              # token length
  .long 0                              # token type
  .long 0                              # line number
  .long 0                              # column number


SET_GLOBL_DEF TOKEN_PROPERTIES_SIZE, .-TOKEN_PROPERTIES

GLOBL_OBJ current_token_length
current_token_length:
  .long 0

.struct
