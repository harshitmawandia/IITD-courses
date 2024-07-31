    .global compare, deleteDup
    .global prints, fgets, atoi
    .global merge 
    .global sort
    .global division
    .balign 4

    .text
    .global main

sort: 

    stmfd	sp!, {r2-r7,lr}
    
    ldr r4, =point
    str r0, [r4]
    ldr r4, =size
    str r1, [r4]
    ldr r4, =compMode
    str r2, [r4]
    ldr r4, =dupOption
    str r3, [r4]
    mov r5,r1

    mov r1,#0
    ldr r6,=pointer

1:  str r0,[r6]
    add r0,r0,#1024
    add r6,r6,#1024
    add r1,r1,#1
    cmp r1,r5
    blt 1b

    ldr r0,=pointer
    sub r2,r1,#1
    mov r1,#0
    bl mergesort
    ldr r7,=size
    ldr r1,[r7]
    ldr r0,=pointer

    ldr r2,=dupOption
    ldr r4,=compMode
    ldr r4,[r4]
    ldr r2,[r2]
    mov r3,#0
    cmp r2,r3
    beq deleteDup

    ldmfd   sp!, {r2-r7,pc}


mergesort:
    stmfd	sp!, {r0-r8,lr}
    mov r3,r0
    mov r4,r1
    mov r5,r2
    cmp r1,r2
    bge 2f

    add r6,r1,r2
    mov r0,r6
    mov r1,#2
    bl division
    mov r6,r0
    mov r0,r3
    mov r1,r4
    mov r2,r6
    bl mergesort
    mov r0,r3
    add r1,r6,#1
    mov r2,r5
    bl mergesort
    mov r7,#1024
    mul r7,r4,r7
    mov r8,r7
    add r0,r3,r7
    mov r7,#1024
    mul r7,r6,r7
    add r7,r7,#1024
    add r1,r3,r7
    sub r7,r6,r4
    add r7,r7,#1
    mov r2,r7
    sub r3,r5,r6
    ldr r7,=compMode
    ldr r4,[r7]
    mov r5,#1
    bl merge

    mov r2,#0
    mov r7,r8
    cmp r2,r1
    bge 2f

    ldr r3,=pointer

1:  ldr r8,[r0]
    str r8,[r3,r7]
    add r2,r2,#1   
    add r7,r7,#1024
    add r0,r0,#1024
    cmp r2,r1
    blt 1b

    mov r0,r3    

2:  ldmfd   sp!, {r0-r8,pc} 
    

    .data

point: .space 20
size: .space 20
compMode: .space 20
dupOption: .space 20
pointer: .space 102400

