    .global compare
    .global main
    .balign 4

    .text

compare:    
    cmp r2,#0
    beq S
    mov r5,#0
    ldr r0,[r0]
    ldr r1,[r1]
A:  ldrb r3,[r0,r5]
    ldrb r4,[r1,r5]
    add r5,r5,#1
    cmp r3,r4
    beq C
    bgt B
    mov r0,#0
    mov pc,lr
B:  mov r0,#2
    mov pc,lr
C:  cmp r3,#0x00
    bne A
    mov r0,#1
    mov pc,lr

S:  mov r5,#0
    ldr r0,[r0]
    ldr r1,[r1]
D:  ldrb r3,[r0,r5]
    ldrb r4,[r1,r5]
    add r5,r5,#1
    cmp r3,#0x61
    blt E
    sub r3,r3,#0x20
E:  cmp r4,#0x61
    blt F
    sub r4,r4,#0x20
F:  cmp r3,r4
    beq H
    bgt G
    mov r0,#0
    mov pc,lr
G:  mov r0,#2
    mov pc,lr
H:  cmp r3,#0x00
    bne D
    mov r0,#1
    mov pc,lr
