.file "scanner.s"

.extern DELIMITERS_TABLE 
.extern REGULAR_CHAR
.extern CONCATENATIVE_CHAR

.extern FOUND_DELIMITER_CHAR
.extern FOUND_REGULAR_CHAR
.extern FOUND_CONCATENATIVE_CHAR

.extern input_buffer

.macro GLOBL_FUNC val                  # declare a macro for global functions
  .globl \val
  .type \val, @function
.endm

.macro RET_CODE code
  movq \code, %rax
.endm

.section .bss

current_offset:
  .quad 0

.section .text

GLOBL_FUNC next_byte
next_byte:
  leaq input_buffer(%rip), %rdx        # get input_buffer
  addq current_offset(%rip), %rdx      # add offset to the input_buffer

  movb (%rdx), %al                     # get current char of the input_buffer

  leaq current_offset(%rip), %rdx      # get current_offset
  incq (%rdx)                          # increase current_offset
  
  jmp scan_byte

scan_byte:
  leaq DELIMITERS_TABLE(%rip), %rdx    # get delimiters_table
  movzbq (%rdx, %rax, 1), %rdx         # get current char type

  cmpq CONCATENATIVE_CHAR(%rip), %rdx
  jge concatenative_char_scanned 

  cmpq REGULAR_CHAR(%rip), %rdx        # if it is a regular char (or a character that comes after a regular char) cont
  jge regular_char_scanned

  jnge delimiter_char_scanned

concatenative_char_scanned:
  RET_CODE FOUND_CONCATENATIVE_CHAR(%rip)
  ret

regular_char_scanned:
  RET_CODE FOUND_REGULAR_CHAR(%rip)
  ret

delimiter_char_scanned:
  RET_CODE FOUND_DELIMITER_CHAR(%rip)
  ret
