# Mnemonics tables
.extern TWO_LEN_MNEMONIC
.globl classify_token

.extern THREE_LEN_MNEMONIC

# Registers tables
.extern TWO_LEN_64_REG
.extern THREE_LEN_64_REG

.extern THREE_LEN_32_REG
.extern FOUR_LEN_32_REG

.extern TWO_LEN_8_REG
.extern THREE_LEN_8_REG
.extern FOUR_LEN_8_REG

# Numbers tables

.extern DEC_NUMBERS
.extern HEX_NUMBERS


# Classification aliases

.set MNEMONIC_TYPE, 1

.set REG_64_BIT, 3
.set REG_32_BIT, 2
.set REG_8_BIT, 4

.set NONE_TYPE, 5

classify_token:
  xorq %r10, %r10                      # will be used as the ZF of check_token; 0 = no_token_match and 1 = token_match

  cmpq $2, %rcx
  je two_len_token

  cmpq $3, %rcx                        # if token_len is 3 then it is a three_len_token otherwise it is not an instruction
  je three_len_token

  cmpq $4, %rcx
  je four_len_token

  jmp is_none

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
  movq $MNEMONIC_TYPE, %r10            # recycle r10 to use it as the token_type buffer
                                       # TO IMPLEMENT: CALL THE PARSER TO LET IT KNOW A TOKEN WAS JUST FINISHED
  jmp add_type_and_continue_tokenizing

is_a_64_register:
  movq $REG_64_BIT, %r10               # reuse r10 as the token_type buffer. GOTTA CHANGE THIS FOR SPECIFIC REGISTER SIZE
                                       # TO IMPLEMENT: CALL THE PARSER TO LET IT KNOW A TOKEN WAS JUST FINISHED
  jmp add_type_and_continue_tokenizing

is_a_32_register:
  movq $REG_32_BIT, %r10
  jmp add_type_and_continue_tokenizing

is_an_8_register:
  movq $REG_8_BIT, %r10
  jmp add_type_and_continue_tokenizing

add_type_and_continue_tokenizing:
  incq %r13
  jmp clean_token_registers


is_none:
  incq %r12                            # increase the no-type token counter 
  jmp clean_token_registers




