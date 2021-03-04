MEMORY
{
	ROM (rx) : ORIGIN = 0x60000000, LENGTH = 1M
	RAM (rwx) : ORIGIN = 0x70000000, LENGTH = 32M
}

SECTIONS
{
	.text : {
		startup.o (.vector_table)
		*(.text)
		*(.rodata)
	} > ROM
	_text_end = .;
	.data : AT(ADDR(.text) + SIZEOF(.text))
	{
		_data_start = .;
		*(.data)
		. = ALIGN(8);
		_data_end = .;
	} > RAM
	.bss : {
		_bss_start = .;
		*(.bss)
        . = ALIGN(8);
        _bss_end = .;
	} > RAM
}
