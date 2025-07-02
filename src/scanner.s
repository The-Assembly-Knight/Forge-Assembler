.extern DELIMITERS_TABLE 

.extern REGULAR_CHAR
.extern DELIMITER
.extern NEW_LINE
.extern COMMENT_START
.extern FILE_END

.extern END_OF_TOKEN
.extern NOT_END_OF_TOKEN

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

  cmpq %rdx, REGULAR_CHAR(%rip)
  je continue_scanning

  jmp stop_scanning

stop_scanning:
  RET_CODE END_OF_TOKEN(%rip)
  ret

continue_scanning:
  RET_CODE NOT_END_OF_TOKEN(%rip)
  ret
