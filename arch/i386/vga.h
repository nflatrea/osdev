#ifndef I386_VGA_H_
#define I386_VGA_H_

#define VGA_SCREEN ((uint16_t*)0xb8000)
#define VGA_SCREEN_W 80
#define VGA_SCREEN_H 25

#include "stddef.h"
#include "stdint.h"

typedef enum
{
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
		
} vga_color_t;

static inline uint8_t  	vga_entry_color(vga_color_t fg, vga_color_t bg) { return fg | bg<<4; }
static inline uint16_t 	vga_entry(unsigned char c, uint8_t color) { return c | color<<8; }

#endif
