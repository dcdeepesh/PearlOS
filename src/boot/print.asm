; AL - byte to print
printChar:
    pusha
    mov ah, 0Eh
    int 10h
    popa
    ret

; DS:SI - pointer to string
printStr:
    pusha
    .nextChar:
        lodsb
        cmp al, 0
        je .return
        call printChar
        jmp .nextChar
    .return:
        popa
        ret

printMem:
    pusha

    

    popa
    ret