; AL - byte to print
printHex:
    pusha

    mov bl, al
    and bx, 0x00F0
    shr bl, 4
    push ax
    mov al, [HEX_STR+bx]
    call printChar

    pop ax
    mov bl, al
    and bx, 0x000F
    mov al, [HEX_STR+bx]
    call printChar

    popa
    ret

HEX_STR:
    db '0123456789abcdef'

; AX - address; starting memory address
; CX - counter; number of bytes to dump
dumpHex:
    pusha
    mov si, ax
    mov bl, 0
    .nextByte:
        cmp cx, 0
        je .return
        lodsb
        call printHex
        mov al, ' '
        call printChar
        dec cx
        ; newline
        inc bl
        mov dl, bl
        and dx, 0x000F
        cmp dl, 0
        jne .nextByte
        mov al, 0xA
        call printChar
        mov al, 0xD
        call printChar
        jmp .nextByte
    .return:
        popa
        ret