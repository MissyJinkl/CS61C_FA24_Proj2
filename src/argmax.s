.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    li t0, 1
    blt a1, t0, exceptions
    li t1, 0 # i = 0
    li t5, 0 # the index of max argument
    mv t2, a0 # t2 is the pointer
    lw t6, 0(a0) # the max argument

loop_start:
    bge t1, a1, loop_end
    lw t4, 0(t2)
    bge t6, t4, loop_continue
    mv t6, t4
    mv t5, t1
    

loop_continue:
    addi t2, t2, 4
    addi t1, t1, 1
    j loop_start

loop_end:
    # Epilogue
    mv a0, t5
    jr ra
    
exceptions:
    li a0 36
    j exit
