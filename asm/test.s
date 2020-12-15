.section .data
.section .text
.global main

main:
	mov r1, #0
	mov r2, #0
	mov r3, #0
	mov r4, #0

loop:
prompt:		.asciz	"Enter a positive integer and I'll add it to a running total (negative value entered to stop): "
	ldr r0, =prompt
	cmp r0, #0
	blt end
	add r1, r1, r0
	add r2, r2, #1

	b loop
end:
	mov r3, r1
	cmp r3, #0
	blt output
	sub r3, r3, r2
	add r4, r4, #1
	b end

output:
	sdiv r3, r1, r2
	.asciz	"The sum of the numbers is "
	.asciz r1
	.asciz	"and the average of the numbers is "
	.asciz r4
	.asciz "\n"
	len = . - msg
	bx lr
