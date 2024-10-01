.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0, 5
    bne a0, t0, exception_31
    
    addi sp sp -60
    sw ra 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    # Read pretrained m0
    
    addi t1, s1, 4
    lw a0, 0(t1)
    addi a1 sp 52
    addi a2 sp 56
    jal read_matrix
    mv s5, a0 #s5 is a pointer to m0
    lw s3, 52(sp) #s3 = rows of m0
    lw s4, 56(sp) #s4 = cols of m0


    # Read pretrained m1
    
    addi t1, s1, 8
    lw a0, 0(t1)
    addi a1 sp 52
    addi a2 sp 56
    jal read_matrix
    mv s8, a0 #s8 is a pointer to m1
    lw s6, 52(sp) #s6 = rows of m1
    lw s7, 56(sp) #s7 = cols of m1
   

    # Read input matrix
    
    addi t1, s1, 12
    lw a0, 0(t1)
    addi a1 sp 52
    addi a2 sp 56
    jal read_matrix
    mv s11, a0 #s11 is a pointer to input
    lw s9, 52(sp) #s9 = rows of input
    lw s10, 56(sp) #s10 = cols of input
    

    # Compute h = matmul(m0, input)
    mul a0, s3, s10
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exception_26
    mv a2, s4
    mv a6, a0
    mv s4, a6 #s4 = address of h
    
    mv a0, s5
    mv a1, s3
    mv a3, s11
    mv a4, s9
    mv a5, s10

    jal matmul
    

    # Compute h = relu(h)
    mv a0, s4
    mul a1, s3, s10
    jal relu


    # Compute o = matmul(m1, h)
    mul a0, s6, s10
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exception_26
    mv a6, a0
    mv s9, a6 #s9 = address of o
    
    mv a0, s8
    mv a1, s6
    mv a2, s7
    
    mv a3, s4
    mv a4, s3
    mv a5, s10

    jal matmul


    # Write output matrix o
    
    mv a1, s1
    addi a1, a1, 16
    lw a0 0(a1)
    mv a1, s9
    mv a2, s3
    mv a3, s10
    jal write_matrix


    # Compute and return argmax(o)
    mv a0, s9
    mul a1, s1, s5
    jal argmax
    mv s1, a0 #s1 - index of the largest element of 0 OR smallest index of the repeated largest element


    # If enabled, print argmax(o) and newline
    bne s2, x0, skip_print
 
    mv a0, s1
    jal print_int
    li a0 '\n'
    jal print_char
    
skip_print:
    
    
    lw s11, 52(sp)
    lw s10, 44(sp)
    lw s9, 40(sp)
    lw s8, 36(sp)
    lw s7, 32(sp)
    lw s6, 28(s0)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra 0(sp)
    addi sp sp 60
    
    mv a0, s1
    
    mv a0, s4
    jal free
    
    mv a0, s9
    jal free
    
    jr ra
    
exception_26:
    li a0, 26
    j exit

exception_31:
    li a0, 31
    j exit