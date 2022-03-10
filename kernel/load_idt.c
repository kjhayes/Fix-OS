#include<stdint.h>

#define IDT_DESCRIPTOR_ADDRESS 0
#define IDT_BASE_ADDRESS 6

extern void set_IDT(void* idt_descriptor);

typedef struct {
    uint16_t offset_1;
    uint16_t selector;
    uint8_t zero; 
    uint8_t type_attr;
    uint16_t offset_2;
} IDT_Entry_32;

typedef struct {
    uint16_t segment;
    uint32_t idt_addr;
} IDT_Descriptor;

static IDT_Descriptor idt_descriptor = {
    0x08,
    kernel_idt
};
static IDT_Entry_32 kernel_idt[256];