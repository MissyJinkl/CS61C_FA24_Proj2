.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    # Prologue
    addi sp sp -32
    sw ra 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    
    
  
    mv s0, a0
    mv s1, a1
    mv s2, a2 #num of rows
    mv s3, a3 #num of columns

    li a1, 1
    jal fopen
    blt a0, x0, exception_27
    mv s4, a0 #s4 is the return value of fopen

    sw s2, 24(sp)
    addi a1, sp, 24
    li a2, 1
    li a3, 4
    jal fwrite
    li a2, 1
    bne a2, a0, exception_30
    
    mv a0, s4
    sw s3, 28(sp)
    addi a1, sp, 28
    li a2, 1
    li a3, 4
    jal fwrite
    li a2, 1
    bne a2, a0, exception_30
    
    mv a0, s4
    mv a1, s1
    mul a2, s2, s3
    li a3, 4
    jal fwrite
    mul a2, s2, s3
    bne a2, a0, exception_30

    mv a0, s4
    jal fclose
    bne a0, x0, exception_28
    
    # Epilogue
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra 0(sp)
    addi sp sp 32
    jr ra

exception_27:
    li a0, 27
    j exit

exception_28:
    li a0, 28
    j exit

exception_30:
    li a0, 30
    j exit