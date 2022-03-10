[org 0x7c00]
[bits 16]

KERNEL_LOAD_ADDR equ 0x1000
NUM_EX_SECTORS_TO_LOAD equ 17

_start:

    mov [BOOT_DRIVE], dl

    mov bx, str_FixOs
    call BIOS_Println

    call Kernel_BIOS_Prep

    mov bx, 0x0000
    mov es, bx
    mov bx, KERNEL_LOAD_ADDR
    mov al, NUM_EX_SECTORS_TO_LOAD
    mov cl, 2 ; Start on Second Sector (1st After Bootloader)
    mov dl, [BOOT_DRIVE]
    call BIOS_Load_Sectors

    jmp Enter_Protected_Mode


%include "boot/BIOS_Println.s"
%include "boot/GDT.s"
%include "boot/BIOS_Load_Sectors.s"
%include "boot/Enter_Protected_Mode.s"
%include "boot/Kernel_BIOS_Prep.s"

str_FixOs:
dw "Fix OS!"

BOOT_DRIVE:
db 0x00

times 510 -( $ - $$ ) db 0
dw 0xaa55