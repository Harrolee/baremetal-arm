/* defines for processor modes */
.equ MODE_FIQ, 0X11
.equ MODE_IRG, 0x12
.equ MODE_SVC, 0x13

.section .vector_table, "x"
.global _Reset
_Reset:
    b Reset_Handler
    b . /* 0x4 Undefined Instruction */
    b . /* 0x8 Software Interrup */
    b . /* 0xC  Prefetch Abort */
    b . /* 0x10 Data Abort */
    b . /* 0x14 Reserved */
    b . /* 0x18 IRQ */
    b . /* 0x1C FIQ */

.section .text
Reset_Handler:
	/* FIQ stack */
	
	// write 0x11 to cpsr_c (current program status register) in order to change to fast interrupt mode. msr only affects the condition flags in bits 28-31 of cpsr_c
	msr cpsr_c, MODE_FIQ
	// we will set the address for stack start and end in the linker file
	ldr r1, =_fiq_stack_start
	ldr sp, =_fiq_stack_end
	// load the four bit constant 0xFEFE into r0; must use movw and movt because arm requires it
	movw r0, #0xFEFE
	movt r0, #0XFEFE

// strlt and blt are conditionals. 
// str (store) if the previous instruction gave a less-than status 
// branch if the previous instruction gave a less-than status
fiq_loop:
	// compare the value in register 1 to the value in stack pointer.
	// Recall that above, we set the values of r1 and sp to the stat and end of our stack
	cmp r1, sp
	// if r1 < sp, store the value from register 0 into the address held in register 1.
	// then, increase the address in r1 by 4
	strlt r0, [r1], #4
	// if the value in r1 was less than the value in sp, run this loop again
	blt fiq_loop    
