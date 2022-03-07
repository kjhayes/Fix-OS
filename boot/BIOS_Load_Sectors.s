 ; load %al sectors to es:bx from drive %dl starting with sector %cl
BIOS_Load_Sectors:
    push ax
    mov ah, 2 ; BIOS Read From Disk
    mov ch, 0 ; cylinder 0
    mov dh, 0 ; head 0
    int 0x13 ; BIOS Interrupt
    
    jc _carry_sectors_error
    
    pop bx
    cmp al, bl
    jne _num_sectors_error

    ret
_num_sectors_error:
    mov bx, _BIOS_SECTORS_READ_ERROR
    call BIOS_Println    
    ret
_carry_sectors_error:
    mov bx, _BIOS_SECTORS_CARRY_ERROR 
    call BIOS_Println
    ret

_BIOS_SECTORS_READ_ERROR:
dw "Error: BIOS Read an Incorrect Number Of Sectors From The Disk!"
_BIOS_SECTORS_CARRY_ERROR:
dw "Error: BIOS Carry Flag Set When Reading Sectors From The Disk!"