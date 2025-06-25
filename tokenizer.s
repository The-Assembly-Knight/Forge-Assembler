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
  xorq %r11, %r11                      # TEST
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
  cmpq $3, %rcx                        # if token_len is 3 then it is a three_len_token otherwise it is not an instruction
  leaq THREE_LEN_MNEMONIC(%rip), %r8
  movb (%r8), %r9b
  je three_len_token

  jmp not_an_instruction


three_len_token:
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

  jmp three_len_token

no_byte_match:
  incq %rdx                            # increase byte-matches to count the amount of bytes left until the end of current list item
  
  incq %r8
  movb (%r8), %r9b

  cmpq %rcx, %rdx
  je reset_byte_matches

  jmp no_byte_match

reset_byte_matches:
  xorq %rdx, %rdx
  jmp three_len_token


token_match:
  incq %r12                            # increase the amount of instruction tokens for testing purposes
  jmp clean_token_registers

no_token_match:
  incq %r13                            # increase the amount of non_instruction tokens for testing purposes
  jmp clean_token_registers


end_tokenizing:
  jmp close_file


not_an_instruction:
  jmp no_token_match

end_instruction:
  incq %r10                            # USE r10 TEMPORALLY FOR DEBUGGING PURPOSES (CHECK THE AMOUNT OF TIMES IT WAS THE END OF AN INSTRUCTION)

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
