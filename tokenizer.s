.section .rodata

FILE_NAME:
  .asciz "test_file"

THREE_LEN_MNEMONIC: # GOTTA PUT THIS IN ITS OWN FILE
  .ascii "mov"
  .ascii "jmp"
  .asciz ""

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

start_tokenizing:                      # TEMPORAL GOTTA FIND A BETTER NAME FOR IT BECAUSE IT WILL BE USED EVERYTIME A LINE ENDS
  xorq %rcx, %rcx                      # will hold the amount of char of the current token
  xorq %rdx, %rdx                      # will hold the amount of byte-matches of the current token
  xorq %r14, %r14                      # will hold the amount of tokens of current line

  jmp scan_byte

scan_byte:
  cmpq $0, %rcx                        # if current token size = 0 then there is no token yet
  je token_has_not_started
  jne token_already_started

token_has_not_started:
  cmpb $10, %al                        # if current char is \n check if line had a token
  je check_line

  cmpb $32, %al                        # if current char is a space ' ' ignore it
  je next_byte

  cmpb $0, %al                         # if current char is the EOF end tokenizing
  je end_tokenizing

  jmp add_to_token

token_already_started:
  cmpb $10, %al                        # if current char is new line treat it as a delimiter
  je end_token

  cmpb $32, %al                        # if current char is a space ' ' treat it as a delimiter
  je end_token

  cmpb $0, %al                         # if current char is EOF treat it as a delimiter
  je end_token

  jmp add_to_token

next_byte:
  incq %rsi                            # increase the position of the current input_buffer index
  movb (%rsi), %al                     # save the current char in al
  
  jmp scan_byte


check_line:
  cmpq $0, %r14                        # check if there are not any tokens in the current line
  je next_byte
  jne end_instruction

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
  cmpq $3, %rcx
  je three_len_token

  jmp error_reading_from_file          # TEMPORAL

  # GOTTA ADD MORE IFs BUT IF IT ITS LEN IS MORE THAN 4 IS NEITHER A MNEMONIC NOR A REGISTER SO EITHER IMMEDIATE OR MEMORY ACCESS,
  # GOTTA WORK ON THAT BUT FIRST IM DOING A BASIC VERSION.

three_len_token:
  xorq %r13, %r13                       # take %r13 as a ZF of it was clasified or not
  movq $THREE_LEN_MNEMONIC, %r8         # recycle rdi since it'll be reseted back to its original value after the token clasification
  movb (%r8), %r9b

  # Test
  xorq %r10, %r10
  xorq %r11, %r11

check_byte:
  cmpq %rcx, %rdx                      # if the amount of byte-matches is = to the amount of bytes then the tokens match
  je token_match

  cmpb $0, %r9b                        # if reached the end of the list
  je no_token_match

  movq $token_buffer, %rdi
  addq %rdx, %rdi                      # add byte matches as offset

  cmpb %r9b, (%rdi)
  je byte_match
  jne no_byte_match

byte_match:
  incq %rdx                            # increase byte-matches counter

  incq %r8
  movb (%r8), %r9b                     # go to the next byte in the list
  
  jmp check_byte

no_byte_match:
  cmpq %rcx, %rdx                     # move 1 byte in the list until the amount of token_len and token_byte_matches are equal
  je reset_byte_matches

  incq %r8                            # point to next byte in the list
  movb (%r8), %r9b                    # save the value of the current byte in the list

  incq %rdx                           # increase token_byte_matches

  jmp no_byte_match

reset_byte_matches:
  xorq %rdx, %rdx
  jmp check_byte

token_match:
  incq %r11                            # it is just a test, if it works then r11 has to be 1 (it worked btw)
  jmp exit

no_token_match:
  incq %r10                            # it is also another test if it worked then r10 was supposed to be 0 (again, it worked)
  jmp exit

end_instruction:
# IT NEEDS TO TELL THE PARSER THAT THE INSTRUCTION LINE IS READY TO BE SEND TO THE ENCODER
jmp start_tokenizing


end_tokenizing:
# send a signal to the parser telling it that there are not more instructions
  nop

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
