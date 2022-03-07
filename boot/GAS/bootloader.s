.org 0x0000
.code16
_start:
    mov $0x7c0, %bx # Setting the Data Segement to base of the Bootloader
    mov %bx, %ds

    # Loading Sectors
    mov $0x0, %bx
    mov $2, %cl # Starting Sector
    mov $1, %al # Number of Sectors To Read     
    call load_sectors

    jmp enter_prot_mode
    
_real_mode_loop:
    jmp _real_mode_loop

# mov 0-terminated 16-bit str address into %bx before call
println_bios:
    movb $0x0e, %ah
_print_loop:
    cmpw $0, (%bx)
    je _end_print
    movb (%bx), %al
    int $0x10
    add $1, %bx
    jmp _print_loop
_end_print:
    movb $'\n', %al
    int $0x10
    movb $'\r', %al
    int $0x10
    ret    

# load %al sectors to es:bx from drive %dl starting with sector %cl
load_sectors:
    pushw %ax
    movb $0x02, %ah # BIOS Read From Disk
    movb $0x0, %ch # cylinder 0
    movb $0x0, %dh # head 0
    int $0x13 # BIOS Interrupt
    
    jc _carry_sectors_error
    
    popw %bx
    cmpb %al, %bl
    jne _num_sectors_error

    ret
_num_sectors_error:
    movw $_num_sectors_read_error_msg, %bx
    call println_bios    
    ret
_carry_sectors_error:
    movw $_carry_sectors_error_msg, %bx
    call println_bios
    ret



/*
GDT Info {
    Source : https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
    ^^^
    Resource for this entire OS Design Too


    GDT (Global Descriptor Table)

    - Requires a Null Entry at the Beginning

    -LITTLE ENDIAN LIKE ALL OF x86
    - 8 byte entries
    First Double Word {
        Entry Base Address (31:24) 31:24 (32 Fragmented Bits Total)
        Granularity Bit 23 (0 : Do Nothing, 1 : Left Shift The Limit By 12, to Allow A Maximum 4 GiB Sized Segment)
        Default Operation Size Bit 22 (0 : 16 bit, 1 : 32 bit)
        64 bit Segment Flag 21 (Only Allowed in x64 Mode)
        Free Bit For OS Use 20
        Segment Limit (19:16) 19:16 (20 Fragmented Bits Total, Defines the Size of the Segment)
        Present Bit 15 (Used for Paging, 0 : Not-Present, 1 : Present)
        Privilege Level 14:13 (0 is Highest Privilege)
        Descriptor Type Bit 12 (0 : System, 1 : Code or Data)
        Segment Type 11:8 (
            "
            - Code: 1 for code, since this is a code segment
            – Conforming: 0, by not corming it means code in a segment with a lower privilege may not call code in this     segment - this a key to memory protection
            – Readable: 1, 1 if readible, 0 if execute-only. Readible allows us to read constants defined in the code.
            – Accessed: 0 This is often used for debugging and virtual memory techniques, since the CPU sets the bit when   it accesses the segment
            " (From Source Directly)
        )
        Base (23:16) 7:0
    } 
    Second Double Word {
        Base (15:0) 31:16
        Limit (15:0) 15:0
    }
}
*/

gdt_start:
gdt_null_entry:
.long 0 # null entry
.long 0
gdt_code_segment:
.short 0xFFFF # limit 0:15
.short 0x0000 # base 0:15
.byte 0x00    # base 16:23
.byte 0b10011010 # 1 Present 00 Privilege 1 code or data segment 1 code 0 non-conforming 1 readible 0 not-accessed
.byte 0b11001111 # 1 Granular 1 32 bit Operations 0 Not x64 0 (Reserved For OS Use) 1111 Limit 19:16
.byte 0x00    # base 31:24
gdt_data_segment:
.short 0xFFFF # limit 0:15
.short 0x0000 # base 0:15
.byte 0x00    # base 16:23
.byte 0b10011010 # 1 Present 00 Privilege 1 code or data segment 0 data 0 expand-down? 1 writable 0 not-accessed
.byte 0b11001111 # 1 Granular 1 32 bit Operations 0 Not x64 0 (Reserved For OS Use) 1111 Limit 19:16
.byte 0x00    # base 31:24
gdt_end:

gdt_descriptor:
.word gdt_end - gdt_start - 1 #GDT Size - 1
.long gdt_start + 0x7c00 #GDT Address

# Constants for setting the segment registers
GDT_CODE = gdt_code_segment - gdt_start
GDT_DATA = gdt_data_segment - gdt_start

enter_prot_mode:
    # Entering 32bit Protected Mode!

    cli # Disable Interrupts For The Time Being
    lgdtl (gdt_descriptor) # Load The GDT

    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0
    
    # Far Jump To Flush Instructions
    jmp $0x08, $0x0

_num_sectors_read_error_msg:
.ascii "An Incorrect Number of Sectors Was Read From The Disk!\0"
_carry_sectors_error_msg:
.ascii "BIOS Set The Carry Flag To Indicate An Error Reading Sectors From The Disk!\0"
_fix_os_str:
.ascii "FIX OS\0"



.space 510-(.-_start)
.word 0xaa55
