SECTIONS { 
  .entry 0x1000 : { *(.entry) }
  .text : { *(.text) }
  .data : { *(.data) } 
  .bss :  { *(.bss)  *(COMMON) } 
} 