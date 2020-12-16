.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ STP_PIN, 29
.equ RED_PIN, 21
.equ YEL_PIN, 22
.equ GRE_PIN, 23

.equ R_PIN, 24
.equ G_PIN, 25


.text
.global main
main:
	push {LR}
	bl wiringPiSetup

	mov r0, #STP_PIN
	bl setPinInput

	mov r0, #RED_PIN
	bl setPinOutput

	mov r0, #YEL_PIN
	bl setPinOutput

	mov r0, #GRE_PIN
	bl setPinOutput

	mov r0, #R_PIN
	bl setPinOutput

	mov r0, #G_PIN
	bl setPinOutput
do_while:
	// red on, green off, g on, r off
	mov r0, #RED_PIN
	bl pinOn
	mov r0, #GRE_PIN
	bl pinOff
	mov r0, #YEL_PIN
	bl pinOff
	mov r0, #G_PIN
	bl pinOn
	mov r0, #R_PIN
	bl pinOff
	ldr r0, =#3000
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	// blink g
	mov r0, #G_PIN
	bl pinOff
	ldr r0, =#600
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	mov r0, #G_PIN
	bl pinOn
	ldr r0, =#600
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	mov r0, #G_PIN
	bl pinOff
	ldr r0, =#600
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	mov r0, #G_PIN
	bl pinOn
	ldr r0, =#200
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	// red off, green on, g off, r on
	mov r0, #RED_PIN
	bl pinOff
	mov r0, #GRE_PIN
	bl pinOn
	mov r0, #R_PIN
	bl pinOn
	mov r0, #G_PIN
	bl pinOff
	ldr r0, =#5000
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	// green off, yellow on, r off, g off
	mov r0, #GRE_PIN
	bl pinOff
	mov r0, #YEL_PIN
	bl pinOn
	ldr r0, =#1000
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	mov r0, #YEL_PIN
	bl pinOn
	ldr r0, =#600
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	mov r0, #YEL_PIN
	bl pinOff
	ldr r0, =#600
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	mov r0, #YEL_PIN
	bl pinOn
	ldr r0, =#600
	bl delay
	bl readStopButton
	cmp r0, #1
	beq end

	b do_while
end:
	b do_while

setPinInput:
	push {LR}
	mov r1, #INPUT
	bl pinMode
	pop {PC}

setPinOutput:
	push {LR}
	mov r1, #OUTPUT
	bl pinMode
	pop {PC}

pinOn:
	push {LR}
	mov r1, #HIGH
	bl digitalWrite
	pop {PC}

pinOff:
	push {LR}
	mov r1, #LOW
	bl digitalWrite
	pop {PC}

readStopButton:
	push {LR}
	mov r0, #STP_PIN
	bl digitalRead
	pop {PC}
