#define MSG_LEN 21

.data                                      # Data section

num_fmt: .asciz "number: %d\n"
str_fmt: .asciz "number: %s\n"
msg_fmt: .asciz "number 1: %d, number 2: %d\n"
buf: .zero 20
snd_ptr: .dword 0
num_1: .word 0
num_2: .word 0


.text                                      # Text (code) section
.global main                               # Exportable object (label)

main:
    # load string to buffer
    la a0, buf
    li a1, 20
    call gets

    # get position of space
    la a0, buf
    li a1, ' '
    call strchr
    
    # handle error
    beq a0, zero, failure
    
    # get pointer to next character
    addi a0, a0, 1

    # store it at snd_ptr
    la a1, snd_ptr
    sd a0, 0(a1)

    la a0, str_fmt
    ld a1, snd_ptr
    call printf

    # convert first part of string to number
    la a0, buf
    li a1, 20
    call atoi

    la a1, num_1
    sd a0, 0(a1)

    # convert second part of string to number
    la a0, snd_ptr
    ld a0, 0(a0)
    li a1, 20
    call atoi

    la a1, num_2
    sd a0, 0(a1)

    la a0, msg_fmt
    lw a1, num_1
    lw a2, num_2
    call printf

   # mv a1, a0
   # la a0, msg_fmt
   # call printf


    



    # # Write syscall-based Hello, world
    # li a7, 16                 # Write syscall number
    # li a0, 1                  # stdout fd (1)
    # la a1, msg_wrt            # Message string address 
    # li a2, MSG_LEN            # Message string length
    # ecall                     # Syscall
    #
    # # Check for syscall return code    
    # li t0, MSG_LEN            # Should return this
    # bne a0, t0, failure       # If not equal go to failure

    li a7, 2                  # Exit system call
    li a0, 0                  # Exit status (success)
    ecall

failure:

    #li a7, 16                 # Write syscall number
    #li a0, 2                  # stderr fd (2)
    #la a1, msg_err            # Error message string address 
    #li a2, 23                 # Error message string length
    #ecall                     # Syscall

    li a7, 2                  # Exit system call
    li a0, 1                  # Exit status (failure)
    ecall                     # Syscall
