    .global compare
    .global prints, fgets, atoi
    .global sort, merge
    .balign 4

    .text
    .global main

main:
    ldr r0, =output1
    bl prints
    mov r1,#12
    ldr r0, =no1
    mov r2,#0
    cmp r0,r1
    bl fgets
    bl atoi
    mov r6,r0
    mov r7,#0
    ldr r8, =memory1

1:  ldr r0, =output3
    cmp r0,r1
    bl prints
    mov r1,#1024
    mov r0,r8
    mov r2,#0
    cmp r0,r1
    bl fgets
    add r8,r8,#1024
    add r7,r7,#1
    cmp r7,r6
    blt 1b

    cmp r0,r1
    ldr r0, =output6
    bl prints
    mov r1,#4
    mov r2,#0
    ldr r0,=delDup
    cmp r0,r1
    bl fgets
    bl atoi
    mov r4,r5
    mov r5,r0

    cmp r0,r1
    ldr r0, =output5
    bl prints
    mov r1,#4
    mov r2,#0
    ldr r0,=comp
    cmp r0,r1
    bl fgets
    bl atoi
    mov r2,r0

    ldr r0,=memory1
    mov r1,r6
    mov r3,r5

    bl sort

    mov r2,#0
    mov r3,#0
    mov r4,r0

3:  cmp r0,r1
    ldr r0,[r4,r3]
    @ ldr r0,[r0]
    add r3,r3,#1024
    bl prints
    ldr r0,=output4
    cmp r0,r1
    bl prints
    add r2,r2,#1
    cmp r2,r1
    blt 3b


    mov r0, #0x18
    swi 0x123456




    .data

output1: .ascii "Number of strings in the List: "
outputskip: .skip 4
output3: .ascii "Input String\n"
outputskip3: .skip 4
output4: .ascii "\n"
outputskip4: .skip 4
output5: .ascii "Type 0 for Case Insensitive or 1 for case sensitive comparison and press enter: "
outputskip5: .skip 4
output6: .ascii "Type 0 to delete duplicates or 1 to not delete duplicates and press enter: "
outputskip6: .skip 4

memory1: .space 102400
no1: .space 20
comp: .space 10
delDup: .space 10