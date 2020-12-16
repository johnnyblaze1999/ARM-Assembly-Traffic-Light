.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ RED_PIN, 21	// wiringPi 21 // red light
.equ YEL_PIN, 22	// wiringPi 22 // yellow light
.equ GRE_PIN, 23	// wiringPi 23 // green light

.equ STA_PIN, 24	// wiringPi 24 // pedestrian red signal
.equ WAL_PIN, 25	// wiringPi 25 // pedestrian green signal

.equ STP_PIN, 29	// wiringPi 29 // STOP PIN
.equ PAUSE_S, 5		// pause in seconds
.equ BLINK, 1		// blink light

.align 4
.text
.global main
main:
	push {LR}		// int main()
	bl wiringPiSetup	// wiringPiSetup(); // initialize the wiringPi library

	mov r0, #STP_PIN
	bl setPinInput

	mov r0, #RED_PIN
	bl setPinOutput

	mov r0, #YEL_PIN
	bl setPinOutput

	mov r0, #GRE_PIN
	bl setPinOutput

	mov r0, #STA_PIN
	bl setPinOutput

	mov r0, #WAL_PIN
	bl setPinOutput
lp:
	mov r0, #GRE_PIN	// pin going off
	mov r1, #RED_PIN	// pin going on
	mov r2, #PAUSE_S	// pause 5s and wait for input
	//mov r3, #WAL_PIN	// walk
	bl action
	mov r0, #WAL_PIN
	bl pinOn

	cmp r0, #1
	beq end_lp

	mov r0, #RED_PIN
	mov r1, #YEL_PIN
	mov r2, #BLINK
	bl action_blnk

	cmp r0, #1
	beq end_lp

	mov r0, #YEL_PIN
	mov r2, #BLINK
	bl action_blnk

	cmp r0, #1
	beq end_lp

	mov r1, #YEL_PIN
	mov r2, #BLINK
	bl action_blnk

	cmp r0, #1
	beq end_lp

	mov r0, #YEL_PIN
	mov r1, #GRE_PIN
	mov r2, #PAUSE_S
	bl action

	cmp r0, #1
	beq end_lp

	bal lp

end_lp:
	mov r0, #RED_PIN
	bl pinOff

	mov r0, #YEL_PIN
	bl pinOff

	mov r0, #GRE_PIN
	bl pinOff

	mov r0, #0	// return 0;
	pop {PC}

setPinInput:			// set pin as input // gpio mode
	push {LR}
	mov r1, #INPUT
	bl pinMode
	pop {PC}

setPinOutput:			// set pin as output // gpio mode
	push {LR}
	mov r1, #OUTPUT
	bl pinMode
	pop {PC}
pinOn:				// set pin on // gpio write
	push {LR}
	mov r1, #HIGH
	bl digitalWrite
	pop {PC}
pinOff:				// set pin off // gpio write
	push {LR}
	mov r1, #LOW
	bl digitalWrite
	pop {PC}

readStopButton:
	push {LR}
	mov r0, #STP_PIN
	bl digitalRead
	pop {PC}

action:
	push {r4, r5, LR}
	mov r4, r1
	mov r5, r2

	bl pinOff
	mov r0, r4
	bl pinOn

	mov r0, #0
	bl time

	mov r4, r0

action_blnk:
	mov r4, r1
	mov r5, r2

	bl pinOff
	mov r0, r4
	bl pinOn

	mov r0, #0
	bl time

	mov r4, r0

do_whl:
	bl readStopButton
	cmp r0, #HIGH
	beq action_done
	mov r0, #0
	bl time

	sub r0, r0, r4

	cmp r0, r5
	blt do_whl
	mov r0, #0
action_done:
	pop {r4, r5, PC}
