#include "vga.h"

void print_vga_char(char c, unsigned char format, unsigned int index){
    *(short*)(VRAM_VGA_TEXT_ADDRESS + (index*2)) = (format<<8) | c;
}
void print_vga_c_str(const char* c_str, unsigned char format, unsigned int index){
    while(*c_str){
        print_vga_char(*c_str, format, index);
        c_str++;
        index++;
    }
}

void print_vga_char_at_pos(char c, unsigned char format, unsigned int col, unsigned int row){
    short* const addr = (short*)(VRAM_VGA_TEXT_ADDRESS+((col + (row*VGA_TEXT_COLS))*2));
    *addr = (format<<8) | c;
}

void fill_vga_text(char c, unsigned char format) {
    for(int row = 0; row < VGA_TEXT_ROWS; row++){
        for(int col = 0; col < VGA_TEXT_COLS; col++){
            print_vga_char_at_pos(c, format, col, row);
        }
    }
}
