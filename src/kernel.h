#ifndef __KERNEL_H__
#define __KERNEL_H__

#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 20

void kernel_main();
uint16_t terminal_make_char(char c, char color);
void terminal_putchar(int i, int j, char c, char color);

#endif