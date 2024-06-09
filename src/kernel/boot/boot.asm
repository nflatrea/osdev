
; multiboot2 bootloader (GRUB2)
; https://www.gnu.org/software/grub/manual/multiboot2/multiboot.html

MB_MAGIC		equ 0xe85250d6
MB_ARCH			equ 0
MB_LENGTH		equ (multiboot_header_end-multiboot_header_start)
MB_CHECKSUM equ -(MB_MAGIC+MB_ARCH+MB_LENGTH)

multiboot_header_start:

	dd MB_MAGIC
	dd MB_ARCH
	dd MB_LENGTH
	dd MB_CHECKSUM

	dw 0
	dw 0
	dd 8

multiboot_header_end:

section .text

global _start
extern kmain

_start:
	cli
	call kmain
	jmp $
	hlt


section .bss
align 4096

stack_bottom: resb 4096*4
stack_top: