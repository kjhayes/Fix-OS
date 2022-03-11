#ifndef FIX_OS_KERNEL_PIC_H
#define FIX_OS_KERNEL_PIC_H

#include "types.h"
#include "ll_io.h"

#define PIC1        0x20
#define PIC2        0xA0 //Pic 2 sounds nicer than slave pic
#define PIC1_CMD    PIC1
#define PIC1_DATA   PIC1+1
#define PIC2_CMD    PIC2
#define PIC2_DATA   PIC2+1

#define EOI_BYTE    0x20

inline static void pic_send_eoi(BYTE irq){
    if(irq >= 8){
        outb(EOI_BYTE, PIC2_CMD);
    }
    outb(EOI_BYTE, PIC1_CMD);
}

#endif