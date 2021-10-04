#ifndef __KPRINT_H__
#define __KPRINT_H__

#define BG_BLACK 0x00
#define FG_WHITE 0x07

void putc(char ch, int x, int y, unsigned int attrib);

void clearScreen();

#endif