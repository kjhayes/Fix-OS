#define VRAM_ADDRESS 0xb8000
#define VRAM_SIZE 131072

#define VGA_VRAM_ROWS 25
#define VGA_VRAM_COLS 80

#define WHITE_ON_BLACK 0x0F

void print_vga_text_char(char c, unsigned char format, unsigned int col, unsigned int row){
    short* const addr = (short*)(VRAM_ADDRESS+((col + (row*VGA_VRAM_COLS))*2));
    *addr = (format<<8) | c;
}

void fill_vga_text(char c, unsigned char format) {
    for(int row = 0; row < VGA_VRAM_ROWS; row++){
        for(int col = 0; col < VGA_VRAM_COLS; col++){
            print_vga_text_char(c, format, col, row);
        }
    }
}

void kernel_main() {
    fill_vga_text(' ', WHITE_ON_BLACK);
    const char msg[] = "Welcome To Fix OS!";
    for(int i = 0; i<sizeof(msg); i++){
        print_vga_text_char(msg[i], WHITE_ON_BLACK, i+30, 12);
    }
}
