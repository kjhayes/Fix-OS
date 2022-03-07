 ; print c_str pointed to by bx 
BIOS_Println:
    mov ah, 0x0e
_BIOS_Println_Loop:
    cmp byte[bx], 0
    je _BIOS_Println_End
    mov al, [bx]
    int 0x10
    add bx, 1
    jmp _BIOS_Println_Loop
_BIOS_Println_End:
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10
    ret