.extern classify_token

.globl token_buffer
.globl clean_token_registers

.section .bss

token_buffer:
  .skip 32

.section .text
.globl _start

_start:

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
  je check_line

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

end_instruction:
                                       # TO IMPLEMENT: SEND SIGNAL TO THE PARSER TELLING IT THE LINE IS READY TO BE ANALYZED
  jmp clean_line_registers             # tokenize next line

end_tokenizing:
  jmp close_file

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
