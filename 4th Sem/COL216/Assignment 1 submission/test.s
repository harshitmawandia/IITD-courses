    .global compare
    .global prints, fgets

    .text
    .global main

main:
    ldr r0,=choice1
    bl prints
    mov r1,#1024
    ldr r0,=m1
    mov r2,#0
    cmp r0,r1
    bl fgets
    cmp r0,r1
    mov r6,r0
    ldr r0,=choice2
    bl prints
    mov r1,#1024
    ldr r0,=m2
    mov r2,#0
    cmp r0,r1
    bl fgets
    mov r7,r0
    ldr r0,=choice
    bl prints
    mov r1,#2
    ldr r0,=m6
    mov r2,#0
    cmp r0,r1
    bl fgets
    bl atoi
    mov r2,r0
    mov r1,r7
    mov r0,r6
    bl compare
    cmp r0,#0
    bne GE
    ldr r0,=output0
    bl prints
    mov r0, #0x18
    swi 0x123456
GE: cmp r0,#1
    bne GT
    ldr r0,=output1
    bl prints
    mov r0, #0x18
    swi 0x123456
GT: ldr r0,=output2
    bl prints
    mov r0, #0x18
    swi 0x123456

    
    .data

m1: .space 1024
m4: .skip 4
output1: .ascii "Equal Strings\n"
outputskip: .skip 4
output0: .ascii "1st String less than 2nd String\n"
outputskip2: .skip 4
output2: .ascii "2nd String less than 1st String\n"
outputskip3: .skip 4
choice: .ascii "Type 0 for Case Insensitive or 1 for case sensitive comparison and press enter: "
outputskip4: .skip 4
choice1: .ascii "String 1: "
outputskip5: .skip 4
choice2: .ascii "String 2: "

m3: .skip 4
m2: .space 1024
m5: .skip 4
m6: .space 4
    