bits 32

section .text

global start
extern kmain

start:
	cli
	mov ebp, stack_top
	mov esp, ebp
	call kmain
	hlt
	jmp $

section .bss
align 4096

stack_bottom: resb 4096*4
stack_top:
