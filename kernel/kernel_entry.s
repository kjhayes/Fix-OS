[bits 32]
[extern _kernel_main]
section .entry
kernel_entry:
    call _kernel_main
    jmp $