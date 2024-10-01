.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp sp -4
    sw ra 0(sp)
    
    mv t0, a0
    mv t1, a1
    mv t2, a2

    li a1, 0
    jal fopen
    blt a0, x0, exception_27
    mv t3, a0 #t3 is the return value of fopen

    mv a1, t1
    li a2, 4
    jal fread
    bne a0, a2, exception_29
    
    mv a0, t3
    mv a1, t2
    li a2, 4
    jal fread
    bne a0, a2, exception_29
    
    lw a0, 0(t1) #num of rows
    lw a1, 0(t2) #num of columns
    mul a0, a0, a1
    slli a0, a0, 2
    mv t5, a0 #t5 is the number of elements * 4
    jal malloc
    bne a0, x0, exception_26
    mv t4, a0 #t4 is the pointer to malloced space
    
    mv a0, t3
    mv a1, t4
    mv a2, t5
    jal fread
    bne a0, a2, exception_29

    mv a0, t3
    jal fclose
    bne a0, x0, exception_28
    
    mv a0, t4

    # Epilogue
    
    sw ra 0(sp)
    addi sp sp 4
    jr ra
    
exception_26:
    li a0, 26
    j exit
    
exception_27:
    li a0, 27
    j exit
    
exception_28:
    li a0, 28
    j exit
    
exception_29: 
    li a0, 29
    j exit