Kernel_BIOS_Prep:
    ; Set The Video Mode
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    ;

    ; Disable The Cursor
    mov ah, 0x01
    mov ch, 0x3F
    int 0x10
    ; Unnecessary For A Bootloader But It's Ugly and I want BIOS to handle it so I don't have to firgure it out in the kernel.
    
    ret