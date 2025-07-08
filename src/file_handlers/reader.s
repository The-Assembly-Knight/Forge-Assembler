.file "reader.s"

.set INPUT_BUFFER_SIZE, 65536

.extern READ_SYSCALL
.extern FILE_DESCRIPTOR

.extern ERROR
.extern NO_ERROR
.extern EMPTY_FILE

.macro GLOBL_FUNC name                 # declare a global function, including its debugging symbols
  .globl \name
  .type \name, @function
.endm

.macro globl_obj name                  # declare a global object, including its debugging symbols
  .globl \name
  .type \name, @object
.endm

.macro RET_CODE code
  movq \code, %rax
.endm

.section .bss

GLOBL_OBJ input_buffer
input_buffer:
  .space INPUT_BUFFER_SIZE             # 65536 = INPUT_BUFFER_SIZE

GLOBL_OBJ readen_bytes
readen_bytes:
  .quad 0

.section .text

GLOBL_FUNC read_from_file
read_from_file:
  movq READ_SYSCALL(%rip), %rax
  movq FILE_DESCRIPTOR(%rip), %rdi
  movq $input_buffer, %rsi
  movq $INPUT_BUFFER_SIZE, %rdx
 
  syscall

  test %rax, %rax
  je file_is_empty
  js file_unsuccessfully_read

  jmp file_successfully_read

file_is_empty:
  RET_CODE EMPTY_FILE(%rip)
  ret

file_unsuccessfully_read:
  RET_CODE ERROR(%rip)
  ret

file_successfully_read:
  movq %rax, readen_bytes(%rip)
  RET_CODE NO_ERROR(%rip)
  ret
