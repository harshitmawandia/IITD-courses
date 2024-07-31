    .global compare,deleteDup
    .global prints, fgets, atoi
    .global merge 
    .balign 4

    .text
    .global main

merge:
    stmfd	sp!, {r2-r10,lr}
    ldr r6,=size1
    str r3,[r6]
    ldr r6,=size2
    str r4,[r6]
    ldr r6,=duptype
    str r5,[r6]
    ldr r6,=compType
    str r2,[r6]
    mov r7,#0
    mov r8,#0
    mov r9,r0
    mov r10,r1
    ldr r6,=mergedList

1:  bl compare
    cmp r0,#0
    beq 0f
    cmp r0,#1
    beq 0f
    cmp r0,#2
    beq 2f

0:  ldr r2, [r9]
    str r2, [r6]
    add r9,r9,#1024
    add r6,r6,#1024
    add r7,r7,#1
    mov r0,r9
    mov r1,r10
    ldr r4,=size1
    ldr r3,[r4]
    cmp r7,r3
    blt 1b
    beq 3f

2:  ldr r2, [r10]
    str r2, [r6]
    add r10,r10,#1024
    add r6,r6,#1024
    add r8,r8,#1
    mov r0,r9
    mov r1,r10
    ldr r3,=size2
    ldr r4,[r3]
    cmp r8,r4
    blt 1b
    beq 4f

3:  ldr r2, [r10]
    str r2, [r6]
    add r10,r10,#1024
    add r6,r6,#1024
    add r8,r8,#1
    ldr r3,=size2
    ldr r4,[r3]
    cmp r8,r4
    blt 3b

    ldr r0,=duptype
    ldr r0,[r0]
    cmp r0,#0
    beq deleteDup
    ldr r0,=mergedList
    ldr r3,=size1
    ldr r1,[r3]
    ldr r3,=size2
    ldr r2,[r3]
    add r1,r1,r2
    ldmfd	sp!, {r2-r10,pc}
    
4:  ldr r2, [r9]
    str r2, [r6]
    add r9,r9,#1024
    add r6,r6,#1024
    add r7,r7,#1
    ldr r4,=size1
    ldr r3,[r4]
    cmp r7,r3
    blt 4b

    ldr r0,=duptype
    ldr r0,[r0]
    cmp r0,#0
    beq deleteDup
    ldr r0,=mergedList
    ldr r6, =size1
    ldr r1,[r6]
    ldr r6, =size2
    ldr r2,[r6]
    add r1,r1,r2
    ldmfd	sp!, {r2-r10,pc}

deleteDup:
    stmfd	sp!, {r2-r10,lr}
    ldr r7, =duplicateList
    mov r9,r1
    mov r8,#1
    add r10,r0,#1024
    mov r1,r10
    mov r2,r4
    str r0,[r7]
    mov r6,#1

6:  mov r3,r0
    bl compare
    cmp r0,#1 
    mov r0,r3
    beq 5f
    mov r0,r10
    add r7,r7,#1024
    str r0,[r7]
    add r6,r6,#1
5:  add r10,r10,#1024
    mov r1,r10
    add r8,r8,#1
    cmp r8,r9
    blt 6b
    
    ldr r0, =duplicateList
    mov r1,r6
    ldmfd	sp!, {r2-r10,pc}



    .data

mergedList: .space 204800
duplicateList: .space 204800
skipSpace:  .skip 4

size1: .space 100
size2: .space 100
compType: .space 100
duptype: .space 100