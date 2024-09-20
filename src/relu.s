.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    li t0, 1
    blt a1, t0, exceptions
    li t1, 1 # i = 1
    mv t2, a0 # t2 is the pointer

loop_start:
    blt a1, t1, loop_end
    lw t4, 0(t2)
    bge t4, x0, loop_continue
    sw x0, 0(t2)
    j loop_continue
    
loop_continue:
    slli t2, t2, 2
    addi t1, t1, 1
    j loop_start

loop_end:
    jr ra

exceptions:
    li a0 36
    j exit
