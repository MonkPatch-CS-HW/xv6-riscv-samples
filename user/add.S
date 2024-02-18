#define MSG_LEN 21

.data                                      # Data section

num_fmt: .asciz "number: %d\n"
str_fmt: .asciz "number: %s\n"
msg_fmt: .asciz "number 1: %d, number 2: %d\n"
buf: .zero 20


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
    
    # get pointer to next character and store it at s2
    addi a0, a0, 1
    mv s2, a0

    # # debug printf
    # la a0, str_fmt
    # ld a1, snd_ptr
    # call printf

    # convert first part of string to number
    la a0, buf
    li a1, 20
    call atoi
    mv s3, a0

    # convert second part of string to number
    mv a0, s2
    li a1, 20
    call atoi
    mv s4, a0

    la a0, msg_fmt
    mv a1, s3
    mv a2, s4
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
