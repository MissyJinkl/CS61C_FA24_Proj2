.globl swap_nibbles

.text
main:
    li a0 0x12345678
    jal ra, swap_nibbles

    addi a1, a0, 0
    addi a0, x0, 34
    ecall # Print result in hex

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

swap_nibbles:
    # YOUR CODE HERE
    li t0 0xF0000000
    and t0 a0 t0
    srli t0 t0 4
    li t1 0x0F000000
    and t1 a0 t1
    slli t1 t1 4
    add a1 t0 t1
    
    li t0 0x00F00000
    and t0 a0 t0
    srli t0 t0 4
    add a1 a1 t0
    li t1 0x000F0000
    and t1 a0 t1
    slli t1 t1 4
    add a1 a1 t1
    
    li t0 0x0000F000
    and t0 a0 t0
    srli t0 t0 4
    add a1 a1 t0
    li t1 0x00000F00
    and t1 a0 t1
    slli t1 t1 4
    add a1 a1 t1
    
    li t0 0x000000F0
    and t0 a0 t0
    srli t0 t0 4
    add a1 a1 t0
    li t1 0x0000000F
    and t1 a0 t1
    slli t1 t1 4
    add a1 a1 t1
    mv a0 a1
    
    ret