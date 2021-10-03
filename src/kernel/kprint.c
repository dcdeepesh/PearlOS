const int MEM_BASE = 0xB8000;

void clearScreen() {
    unsigned char *ptr = (unsigned char *) MEM_BASE;
    for (int i = 0; i < 2*80*25; i++)
        ptr[i] = 0;
}