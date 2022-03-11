#include "vga.h"

void kernel_main() {
    const char* str = "Hello And Welcome To Fix OS!";
    fill_vga_text(' ', WHITE_ON_BLACK);
    print_vga_c_str(str, WHITE_ON_BLACK, 12*VGA_TEXT_COLS + 25);  
}
