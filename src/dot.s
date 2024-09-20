.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    bge x0, a2, exception1
    bge x0, a3, exception2
    bge x0, a4, exception2
    li t0, 0 # i = 0
    li t1, 0 # the dot product
    slli t2, a3, 2 # stride of arr0 in byte
    slli t3, a4, 2 # stride of arr1 in byte
    


loop_start:
    bge t0, a2, loop_end
    lw t4, 0(a0)
    lw t5, 0(a1)
    mul t4, t4, t5
    add t1, t1, t4
    
    add a0, a0, t2
    add a1, a1, t3
    addi t0, t0, 1
    j loop_start

loop_end:
    mv a0, t1
    jr ra
    
exception1:
    li a0 36
    j exit
    
exception2:
    li a0 37
    j exit