.code32
_start:

init_prot_mode:
    # Designate Segments
    movw GDT_DATA, %ax
    movw %ax, %ds 
    movw %ax, %ss
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs

    # Set Stack
    movl $0x90000, %ebp
    movl %ebp, %esp

_prot_loop:
    jmp _prot_loop

.space 512-(.-_start)
