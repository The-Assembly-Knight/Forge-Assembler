.section .rodata

# Mnemonics tables
.extern TWO_LEN_MNEMONIC
.extern THREE_LEN_MNEMONIC

# Registers tables
.extern TWO_LEN_64_REG
.extern THREE_LEN_64_REG

.extern THREE_LEN_32_REG
.extern FOUR_LEN_32_REG

.extern TWO_LEN_8_REG
.extern THREE_LEN_8_REG
.extern FOUR_LEN_8_REG

# Classification aliases

.set MNEMONIC_TYPE, 1
.set REGISTER_TYPE, 2
.set NONE_TYPE, 3


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

end_reading_file:
  movq $input_buffer, %rsi             # point to input_buffer

  xorq %rax, %rax
  movb (%rsi), %al                     # get current char on the buffer
  
  cmpb $0, %al                         # check if file is empty
  je end_tokenizing

  jmp start_tokenizing

start_tokenizing:
  jmp clean_line_registers

clean_line_registers:
  xorq %r14, %r14                      # will hold the amount of tokens of current line
  jmp clean_token_registers

clean_token_registers:
  xorq %rcx, %rcx                      # will hold the amount of char of the current token
  xorq %rdx, %rdx                      # will hold the amount of byte-matches of the current token

  jmp scan_byte

scan_byte:
  cmpq $0, %rcx                        # if current token size = 0 then there is no token yet
  je token_has_not_started
  jne token_already_started

token_has_not_started:
  cmpb $10, %al                        # if current char is \n check if line had a token
  je check_line                        # exit TEMPORAL

  cmpb $9, %al                         # if current char is \t skip it
  je next_byte

  cmpb $32, %al                        # if current char is a space skip it
  je next_byte

  cmpb $59, %al                        # if current char is the start of a comment (;) skip the rest of the line
  je next_line

  cmpb $0, %al                         # if current char is the EOF end tokenizing
  je end_tokenizing

  jmp add_to_token

token_already_started:
  cmpb $10, %al                        # if current char is new line treat it as a delimiter
  je end_token

  cmpb $9, %al                         # if current char is a \t treat it as a delimiter
  je end_token

  cmpb $32, %al                        # if current char is a space ' ' treat it as a delimiter
  je end_token

  cmpb $59, %al                        # if current char is the start of a comment (;) use it as a delimiter
  je end_token

  cmpb $0, %al                         # if current char is EOF treat it as a delimiter
  je end_token

  jmp add_to_token

next_byte:
  incq %rsi                            # increase the position of the current input_buffer index
  movb (%rsi), %al                     # save the current char in al
  
  jmp scan_byte

next_line:
  incq %rsi
  movb (%rsi), %al

  cmpb $10, %al                        # keep increasing value of the pointer until reached a \n
  je check_line                        # when reached \n check if line had at least a token before the comment start

  jmp next_line

check_line:
  cmpq $0, %r14                        # check if there are not any tokens in the current line
  je next_byte                         # skip new line char
  jne end_instruction                  # send signal to the parser if reached the end of a line with tokens

add_to_token:
  movq $token_buffer, %rdi
  addq %rcx, %rdi                      # add the current amount of char in the token as offset

  movb %al, (%rdi)                     # add the current char to the token_buffer

  incq %rcx                            # increase the amount of char of the current token

  jmp next_byte                        # continue to the next char


end_token:
  incq %r14                            # increase counter of the amount of tokens of the current line
  jmp classify_token 

classify_token:
  xorq %r10, %r10                      # will be used as the ZF of check_token; 0 = no_token_match and 1 = token_match

  cmpq $2, %rcx
  je two_len_token

  cmpq $3, %rcx                        # if token_len is 3 then it is a three_len_token otherwise it is not an instruction
  je three_len_token

  cmpq $4, %rcx
  je four_len_token

  jmp is_none                          # TEMPORAL

two_len_token:
  movq $TWO_LEN_MNEMONIC, %r8          # check if it is a mnemonic
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10                        # if is a mnemonic classify it as so
  je is_a_mnemonic

  movq $TWO_LEN_64_REG, %r8            # check if it is a 64 bit register
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10
  je is_a_64_register

  movq $TWO_LEN_8_REG, %r8             # check if it is an 8bit register
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10
  je is_an_8_register

  jmp is_none

three_len_token:
  movq $THREE_LEN_MNEMONIC, %r8        # check if it is a mnemonic
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10
  je is_a_mnemonic

  movq $THREE_LEN_64_REG, %r8          # check if it is a 64 bit register
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10
  je is_a_64_register

  movq $THREE_LEN_32_REG, %r8          # check if it is a 32 bit register
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10
  je is_a_32_register

  movq $THREE_LEN_8_REG, %r8           # check if it is an 8 bit register
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10
  je is_an_8_register

  jmp is_none

four_len_token:
  movq $FOUR_LEN_32_REG, %r8           # check if it is a 32 bit register
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10
  je is_a_32_register

  movq $FOUR_LEN_8_REG, %r8            # check if it is an 8 bit register
  movb (%r8), %r9b

  call check_token
  cmpq $1, %r10
  je is_an_8_register

  jmp is_none

check_token:
  movq $token_buffer, %rdi
  addq %rdx, %rdi

  cmpb $0, %r9b
  je no_token_match

  cmpb (%rdi), %r9b
  je byte_match

  jmp no_byte_match

byte_match:
  incq %rdx                            # increase byte-matches count

  incq %r8                             # go to the next byte in the list
  movb (%r8), %r9b                     # and save it in r9b

  cmpq %rcx, %rdx
  je token_match

  jmp check_token

no_byte_match:
  incq %rdx                            # increase byte-matches to count the amount of bytes left until the end of current list item
  
  incq %r8
  movb (%r8), %r9b

  cmpq %rcx, %rdx
  je reset_byte_matches

  jmp no_byte_match

reset_byte_matches:
  xorq %rdx, %rdx
  jmp check_token


token_match:
  movq $1, %r10                        # set token_match flag to true
  ret

no_token_match:
  movq $0, %r10                        # set token_match flag to false
  ret

is_a_mnemonic:
  incq %r13                            # increase the type-token counter

  movq $MNEMONIC_TYPE, %r10            # recycle r10 to use it as the token_type buffer
                                       # TO IMPLEMENT: CALL THE PARSER TO LET IT KNOW A TOKEN WAS JUST FINISHED
  jmp clean_token_registers

  # TO IMPLEMENT: GOTTA CREATE A SIMPLER WAY TO assign REGISTER TYPE TO REGISTERS

is_a_64_register:
  incq %r13                            # increase the type-token token counter

  movq $REGISTER_TYPE, %r10            # reuse r10 as the token_type buffer. GOTTA CHANGE THIS FOR SPECIFIC REGISTER SIZE
                                       # TO IMPLEMENT: CALL THE PARSER TO LET IT KNOW A TOKEN WAS JUST FINISHED
  jmp clean_token_registers

is_a_32_register:
  incq %r13

  movq $REGISTER_TYPE, %r10            # GOTTA CHANGE THIS FOR SPECIFIC REGISTER SIZE

  jmp clean_token_registers

is_an_8_register:
  incq %r13

  movq $REGISTER_TYPE, %r10            # GOTTA CHANGE THIS FOR SPECIFIC REGISTER SIZE

  jmp clean_token_registers

is_none:
  incq %r12                            # increase the no-type token counter
  
  jmp clean_token_registers

end_tokenizing:
  jmp close_file


end_instruction:
                                       # TO IMPLEMENT: SEND SIGNAL TO THE PARSER TELLING IT THE LINE IS READY TO BE ANALYZED
  jmp clean_line_registers             # tokenize next line


close_file:
  movq $3, %rax                        # close syscall
  movq %r15, %rdi                      # provide file descriptor

  syscall

  jmp exit

error_reading_from_file:
  movq $60, %rax                       # exit syscall
  movq $1, %rdi                        # set exit code to 1

  syscall

exit:
  movq $60, %rax                       # exit syscall
  movq $0, %rdi                        # set exit code to 0

  syscall
