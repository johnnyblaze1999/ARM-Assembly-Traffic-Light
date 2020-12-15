.global main
.data

print:		.asciz	"Enter a positive integer and I'll add it to a running (negative value)"
scan:		.asciz	"%d"
output:		.asciz	"The sum is %d and count is %d\n"

input:		.word	0
sum:		.word	0
count:		.word	0

.text
main:
	push {LR}
	mov r7, #0
	mov r8, #0
	mov r1, #0

neg_check:
	ldr r0, =print
	bl printf

	ldr r0, =scan
	ldr r1, =input
	bl scanf

	ldr r1, =input
	ldr r1, [r1]
	cmp r1, #0
	blt _set_up

	add r8, r1
	add r7, #1

	ldr r5, =sum
	ldr r4, =count
	str r8, [r5]
	str r7, [r4]

	b neg_check

_set_up:
	ldr r5, =sum
	ldr r4, =count
	ldr r5, [r5]
	ldr r4, [r4]

	mov r0, r5
	mov r1, #0
	mov r2, #1
	mov r3, r4

	b _do_while

_do_while:
	mov r3, r3, lsl #1
	mov r2, r2, lsl #1

	cmp r0, r3
	bgt _do_while

	mov r3, r3, lsr #1
	mov r2, r2, lsr #1
	b _subtract

_subtract:
	cmp r0, r3
	blt _output
	add r1, r2
	sub r0, r3
	b _shift_right

_shift_right:
	cmp r2, #1
	beq _subtract

	cmp r3, r0
	ble _subtract
	mov r2, r2, lsr #1
	mov r3, r3, lsr #1

	b _shift_right
	b _subtract

_output:
	ldr r0, =output
	ldr r2, =sum
	ldr r2, [r2]
	ldr r1, [r1]
	bl printf
	b _exit

_exit:
	mov r0, #0
	pop {PC}
