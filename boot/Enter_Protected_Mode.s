[bits 16]

Enter_Protected_Mode:
     ; Entering 32bit Protected Mode!

    cli ; Disable Interrupts For The Time Being
    lgdt [gdt_descriptor] ; Load The GDT

    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
     ; Far Jump To Flush Instructions
    jmp GDT_CODE:Init_Protected_Mode

[bits 32]

Init_Protected_Mode:
    
    mov ax, GDT_DATA
    mov ds, word ax 
    mov ss, word ax
    mov es, word ax
    mov fs, word ax
    mov gs, word ax

     ; Set Stack
    mov ebp, 0x90000
    mov esp, ebp

    jmp KERNEL_LOAD_ADDR

