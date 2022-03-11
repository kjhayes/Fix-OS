#ifndef FIX_OS_KERNEL_IDT_H
#define FIX_OS_KERNEL_IDT_H

#include "types.h"

struct __attribute__((packed)) IDTEntry 
{
    WORD offset_low;        
    WORD selector;        
    BYTE unused;            
    BYTE attr;
    WORD offset_high;             
};



static inline void lidt(void* ptr, WORD size)
{   struct {
        WORD size;
        void* ptr;
    } __attribute__((packed)) descriptor = { size, ptr };
 
    asm (
        "lidt %%0" 
        :: "m"(descriptor)
    );
}

#endif