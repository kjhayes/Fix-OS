#ifndef FIX_OS_KERNEL_VGA_H
#define FIX_OS_KERNEL_VGA_H

#define VRAM_VGA_ADDRESS        0xA0000
#define VRAM_VGA_TEXT_ADDRESS   0xB8000
#define VRAM_SIZE               131072

#define VGA_COLS        320
#define VGA_ROWS        200

#define VGA_TEXT_ROWS   25
#define VGA_TEXT_COLS   80

#define WHITE_ON_BLACK  0x0F
#define BLACK_ON_WHITE  0xF0
#define WHITE_ON_RED    0xCF

void print_vga_char(char c, unsigned char format, unsigned int index);
void print_vga_c_str(const char* c_str, unsigned char format, unsigned int index);
void print_vga_char_at_pos(char c, unsigned char format, unsigned int col, unsigned int row);
void fill_vga_text(char c, unsigned char format);

#endif