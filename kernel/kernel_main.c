#define VRAM_VGA_ADDRESS        0xA0000
#define VRAM_VGA_TEXT_ADDRESS   0xB8000
#define VRAM_SIZE               131072

#define VGA_COLS        320
#define VGA_ROWS        200

#define VGA_TEXT_ROWS   25
#define VGA_TEXT_COLS   80

#define WHITE_ON_BLACK 0x0F
#define BLACK_ON_WHITE 0xF0
#define WHITE_ON_RED   0xCF

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

void kernel_main() {
    const char* str = "Hello And Welcome To Fix OS!";
    fill_vga_text(' ', WHITE_ON_BLACK);
    print_vga_c_str(str, WHITE_ON_BLACK, 0);  
}
