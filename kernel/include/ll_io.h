#ifndef FIX_OS_KERNEL_LL_IO_H
#define FIX_OS_KERNEL_LL_IO_H

#include "types.h"

static inline BYTE inb(PORT port) {
    BYTE result;
    asm volatile (
        "inb %%dx, %%al" 
        : "=a" (result) 
        : "d" (port)
    );
    return result;
}
static inline void outb(BYTE b, PORT port) {
    asm volatile (
        "outb %%al, %%dx"
        :: "a" (b),
         "d" (port)
    );
}

static inline WORD inw(PORT port) {
    WORD result;
    asm volatile (
        "inw %%dx, %%ax" 
        : "=a" (result) 
        : "d" (port)
    );
    return result;
}
static inline void outw(WORD w, PORT port) {
    asm volatile (
        "outw %%ax, %%dx"
        :: "a" (w),
         "d" (port)
    );
}

static inline LONG inl(PORT port) {
    LONG result;
    asm volatile (
        "inl %%dx, %%eax" 
        : "=a" (result) 
        : "d" (port)
    );
    return result;
}
static inline void outl(LONG l, PORT port) {
    asm volatile (
        "outl %%eax, %%dx"
        :: "a" (l),
         "d" (port)
    );
}

static inline void io_wait() {
    outb(0, 0x80);
}

#endif