#include "kernel/kprint.h"

#define MEM_BASE 0xB8000

unsigned char *const MEM_BASE_PTR = (unsigned char *) MEM_BASE;

static int cursorPosition = 0;

void clearScreen() {
    unsigned char *ptr = MEM_BASE_PTR;
    for (int i = 0; i < 2*80*25; i++)
        ptr[i] = 0;
}

void putc(char ch, int x, int y, unsigned int attrib) {
    if (x >= 25 || y >= 80)
        return;

    int pos = y*80 + x;
    MEM_BASE_PTR[pos] = ch;
    MEM_BASE_PTR[pos+1] = (unsigned char) attrib;
}