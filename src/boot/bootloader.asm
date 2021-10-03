[ORG 0x7C00]
[BITS 16]

NO_OF_MAIN_BOOTLOADER_SECTORS equ 2

start:
    ; temporary segments and stack
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov ax, 0x7C00
    mov bp, ax
    mov sp, bp
    mov byte [bootDisk], dl

    mov si, .STR_START
    call printStr
    
    ;; load main bootloader
    
    mov si, .STR_LOADING
    call printStr

    ; disk IO
    mov ah, 0x02
    mov ch, 0   ; cylinder
    mov dh, 0   ; head
    mov dl, byte [bootDisk]
    mov cl, 2   ; sector
    mov al, NO_OF_MAIN_BOOTLOADER_SECTORS
    mov bx, 0x7C00+0x200
    int 13h

    ; disk IO status
    jc .diskReadFail
    cmp al, NO_OF_MAIN_BOOTLOADER_SECTORS
    jne .diskReadCountError
    
    mov si, .STR_LOADED
    call printStr

    ; switch to the main bootloader
    call bootloaderMain

.diskReadFail:
    mov si, .STR_DISK_FAILED
    call printStr
    jmp loop

.diskReadCountError:
    mov si, .STR_DISK_COUNT_ERR
    call printStr
    jmp loop

    .STR_START:          db "=== Booting OS ===", 0xA, 0xD, 0
    .STR_LOADING:        db "Loading main bootloader...", 0xA, 0xD, 0
    .STR_DISK_FAILED:    db "[ERROR] Disk read failed", 0xA, 0xD, 0
    .STR_DISK_COUNT_ERR: db "[ERROR] Disk read count mismatch", 0xA, 0xD, 0
    .STR_LOADED:         db "Main bootloader loaded successfully", 0xA, 0xD, 0

%include "print.asm"

bootDisk: db 0

times 510-($-$$) db 0
dw 0xAA55

%include "bootloaderMain.asm"

; align to sector, totalling 3 sectors before kernel code
times 1536-($-$$) db 0