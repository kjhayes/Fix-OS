;GDT Info {
;    Source : https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
;    ^^^
;    Resource for this entire OS Design Too
;
;
;    GDT (Global Descriptor Table)
;
;    - Requires a Null Entry at the Beginning
;
;    -LITTLE ENDIAN LIKE ALL OF x86
;    - 8 byte entries
;    First Double Word {
;        Entry Base Address (31:24) 31:24 (32 Fragmented Bits Total)
;        Granularity Bit 23 (0 : Do Nothing, 1 : Left Shift The Limit By 12, to Allow A Maximum 4 GiB Sized Segment)
;        Default Operation Size Bit 22 (0 : 16 bit, 1 : 32 bit)
;        64 bit Segment Flag 21 (Only Allowed in x64 Mode)
;        Free Bit For OS Use 20
;        Segment Limit (19:16) 19:16 (20 Fragmented Bits Total, Defines the Size of the Segment)
;        Present Bit 15 (Used for Paging, 0 : Not-Present, 1 : Present)
;        Privilege Level 14:13 (0 is Highest Privilege)
;        Descriptor Type Bit 12 (0 : System, 1 : Code or Data)
;        Segment Type 11:8 (
;            "
;            - Code: 1 for code, since this is a code segment
;            – Conforming: 0, by not corming it means code in a segment with a lower privilege may not call code in this segment this a key to memory protection
;            – Readable: 1, 1 if readible, 0 if execute-only. Readible allows us to read constants defined in the code.
;            – Accessed: 0 This is often used for debugging and virtual memory techniques, since the CPU sets the bit when it accesses the segment
;            " (From Source Directly)
;        )
;        Base (23:16) 7:0
;    } 
;    Second Double Word {
;        Base (15:0) 31:16
;        Limit (15:0) 15:0
;    }
;}

gdt_start:
gdt_null_entry:
times 8 db 0x00 ; null entry
gdt_code_segment:
dw 0xFFFF ; limit 0:15
dw 0x0000 ; base 0:15
db 0x00    ; base 16:23
db 0b10011010 ; 1 Present 00 Privilege 1 code or data segment 1 code 0 non-conforming 1 readable 0 not-accessed
db 0b11001111 ; 1 Granular 1 32 bit Operations 0 Not x64 0 (Reserved For OS Use) 1111 Limit 19:16
db 0x00    ; base 31:24
gdt_data_segment:
dw 0xFFFF ; limit 0:15
dw 0x0000 ; base 0:15
db 0x00    ; base 16:23
db 0b10010010 ; 1 Present 00 Privilege 1 code or data segment 0 data 0 expand-down? 1 writable 0 not-accessed

 ; [A Monument to my Mistakes] I Accidentally has a single bit flipped, the "data" flag set all of the segments to executable, and it took me wayyyy too long to track that down...

db 0b11001111 ; 1 Granular 1 32 bit Operations 0 Not x64 0 (Reserved For OS Use) 1111 Limit 19:16
db 0x00    ; base 31:24
gdt_end:

gdt_descriptor:
dw gdt_end - gdt_start - 1 ; GDT Size - 1
dd gdt_start ; GDT Address

 ; Constants for setting the segment registers
GDT_CODE equ gdt_code_segment - gdt_start
GDT_DATA equ gdt_data_segment - gdt_start
