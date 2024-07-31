    .global division

division:
    stmfd	sp!, {r2,lr}
    mov r2,#0
1:  cmp r0,r1
    blt 2f
    sub r0,r0,r1
    add r2,r2,#1
    bl  1b
2:  mov r1,r0
    mov r0,r2
    ldmfd	sp!, {r2,pc}    
    