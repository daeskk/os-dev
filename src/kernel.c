#include "kernel.h"

#include <stdint.h>
#include <stddef.h>

uint16_t *video_memory = 0;
uint16_t terminal_row = 0;
uint16_t terminal_col = 0;

void terminal_initialize() {
    video_memory = (uint16_t *)(0xB8000); // start address
    terminal_row = 0;
    terminal_col = 0;
    for (int j = 0; j < VGA_HEIGHT; j++) {
        for (int i = 0; i < VGA_WIDTH; i++) {
            terminal_putchar(i, j, ' ', 0);
        }
        
    }
}

size_t strlen(const char *str) {
    size_t len = 0;
    
    while(str[len]) len++;
    
    return len;
}



/* 
for future reference, this takes the color hex, i.e 0x0F
with the left shift it becomes 0x0F00. by using the or operator
for the character it gets inserted at the end, i.e 'A' = 0x41
0x0F00 | 0x41 = 0x0F41
*/
uint16_t terminal_make_char(char c, char color) {
    return (color << 8) | c; 
}

void terminal_putchar(int i, int j, char c, char color) {
    video_memory[(j * VGA_WIDTH) + i] = terminal_make_char(c, color);
}

void terminal_writechar(char c, char color) {
    if (c == '\n') {
        terminal_col = 0;
        terminal_row += 1;
        return;    
    }
    terminal_putchar(terminal_col, terminal_row, c, color);
    terminal_col += 1;

    if (terminal_col >= VGA_WIDTH) {
        terminal_col = 0;
        terminal_row += 1;
    }
}

void print(const char *str) {
    size_t str_len = strlen(str);

    for (int i = 0; i < str_len; i++) {
        terminal_writechar(str[i], 15);
    }
}

void print_newline() {
    terminal_col = 0;
    terminal_row += 1;
}                               


void kernel_main() {
    terminal_initialize();
    print("      _      _                  ___  ____  \n");
    print("   __| | ___| |__   __ _ _ __  / _ \\/ ___| \n");
    print("  / _` |/ _ \\ '_ \\ / _` | '_ \\| | | \\___ \\ \n");
    print(" | (_| |  __/ | | | (_| | | | | |_| |___) |\n");
    print("  \\__,_|\\___|_| |_|\\__,_|_| |_|\\___/|____/ \n");
    print("                                           \n");

    print(">");
}