[bits 32]
[extern _kernel_main]
kernel_entry:
    call _kernel_main
    jmp $