[BITS 32]

pmInit:
    ; segments and stack
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    ; Jump to the kernel stub code, which is
    ; assembled to ELF and linked with the kernel.
    ; It does the job of actually calling C main(),
    ; and is used to set a fixed and reliable landing
    ; point into the kernel, unadffected by C/C++ code.
    jmp 0x7C00+0x600    ; = 0x8300