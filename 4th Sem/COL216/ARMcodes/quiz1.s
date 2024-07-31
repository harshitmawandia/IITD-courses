MaxFreq:	
	mov r2, #1			// index for frequency array
	mov r3, #0			// constant 0 to initialize the frequency array
Loop0:
	str r3, [r1, r2, LSL #2]	// initialization
	add r2, r2, #1			// next index
	cmp r2, #127
	blt Loop0
Loop1:						
	ldrb r2, [r0], #1			// load byte from string
	ands r2, r2, #0x7f		// ignore parity bit
	beq MaxMov				// check for null
	ldr r3, [r1, r2, LSL #2]
	add r3, r3, #1			// update frequency
	str r3, [r1, r2, LSL #2]
	b Loop1

MaxMov:
    mov r0,r1
    mov r1,#127
    bl Max
    bl Done

Max:
    stmfd	sp!, {r1-r4,lr}
    mov r2, #1
    mov r3, #0
Loop3:
    ldr r4, [r0, r2, LSL #2]
    cmp r4,r3
    movgt r3,r4
    add r2, r2, #1			// next index
	cmp r2, r1
	blt Loop3
    mov r0,r3
    ldmfd   sp!, {r1-r4,pc}


Done:
    mov r0,r5
    mov pc, lr			// return
	.end