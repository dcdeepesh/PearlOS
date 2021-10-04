#include "kernel/kprint.h"

void main() {
    clearScreen();
    putc('X', 0, 0, BG_BLACK | FG_WHITE);
}