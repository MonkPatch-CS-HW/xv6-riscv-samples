#define MSG_LEN 21
#define SPACE 32
#define ZERO 48
#define NINE 57
#define BSN 10
#define BSR 13

.data                                      # Data section

fmt_dbg: .asciz "debug!\n"
fmt_str: .asciz "string: %s, n: %d\n"
fmt_input: .asciz "first: %d, second: %d\n"
fmt_result: .asciz "result: %d\n"
fmt_err_space: .asciz "should be exactly one space between two numbers\n"
fmt_err_char: .asciz "incorrect numbers\n"

buf: .zero 20


.text                                      # Text (code) section
.global main                               # Exportable object (label)

main:
    # load string to buffer
    la a0, buf
    li a1, 20
    call readstdin

    # s0 - start buf
    # s1 - space location
    # s2 - last char
    la s0, buf
    mv s1, zero

    # calculate string length
    la a0, buf
    call strlen

    add s2, s0, a0
    addi s2, s2, -1


    # --- begin loop ---
    # s6 - current pos
    # s7 - current char
    mv s6, s0

    li s11, SPACE
    li s10, ZERO
    li s9, NINE

loop_fmt:
    lb s7, 0(s6)

    beq s7, s11, loop_fmt_space

    blt s7, s10, err_char
    bgt s7, s9, err_char

    j cont

loop_fmt_space:
    bne s1, zero, err_space
    beq s6, s0, err_space
    beq s6, s2, err_space

    # call dbg
    mv s1, s6

cont:
    addi s6, s6, 1
    ble s6, s2, loop_fmt
    # --- end loop ---
    
    # handle space not found
    beq s1, zero, err_space
    
    # now s1 points to second string
    addi s1, s1, 1

    # convert first part of string to number
    mv a0, s0
    li a1, 20
    call atoi
    mv s3, a0

    # convert second part of string to number
    mv a0, s1
    li a1, 20
    call atoi
    mv s4, a0

    add s5, s3, s4

    # print result
    la a0, fmt_result
    mv a1, s5
    call printf

    li a7, 2                  # Exit system call
    li a0, 0                  # Exit status (success)
    ecall


err_space:
    li a7, 16                 # Write syscall number
    li a0, 2                  # stderr fd (2)
    la a1, fmt_err_space      # Error message string address 
    li a2, 48                 # Error message string length
    ecall                     # Syscall

    li a7, 2                  # Exit system call
    li a0, 1                  # Exit status (failure)
    ecall                     # Syscall


err_char:
    li a7, 16                 # Write syscall number
    li a0, 2                  # stderr fd (2)
    la a1, fmt_err_char       # Error message string address 
    li a2, 18                 # Error message string length
    ecall                     # Syscall

    li a7, 2                  # Exit system call
    li a0, 1                  # Exit status (failure)
    ecall                     # Syscall



dbg:
    la a0, fmt_dbg
    mv t0, ra

    call printf

    mv ra, t0
    ret


readstdin:
    # save registers
    addi sp, sp, -32
    sd s0, 0(sp)
    sd s1, 8(sp)
    sd s2, 16(sp)
    sd s3, 24(sp)

    # buf
    mv s0, a0
    # max n
    mv s1, a1
    # counter
    li s2, 0

readstdin_loop:
    bge s2, s1, readstdin_loop_cond

    # read single character
    li a7, 5
    li a2, 1
    mv a1, s0
    li a0, 0
    ecall

    beq a0, zero, readstdin_loop_cond

    lb t0, 0(s0)
    li t1, BSN
    li t2, BSR
    beq t0, t1, readstdin_loop_cond
    beq t0, t2, readstdin_loop_cond

    addi s0, s0, 1
    addi s2, s2, 1
    j readstdin_loop

readstdin_loop_cond:
    sb zero, 0(s0)
    addi s2, s2, 1
    
readstdin_loop_exit:
    mv a0, s2

    # restore registers
    ld s0, 0(sp)
    ld s1, 8(sp)
    ld s2, 16(sp)
    ld s3, 24(sp)
    addi sp, sp, 32

    ret
