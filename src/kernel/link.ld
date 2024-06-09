ENTRY(_start)
SECTIONS
{
	. = 1M;
	.text : {
		KEEP(*(.multiboot))
		*(.text)
	}
	.data ALIGN(4096) : {*(.data)}
	.rodata ALIGN(4096) : {*(rodata)}
	.bss ALIGN(4096) : {*(.bss)}
} 