[bits 16]

NO_OF_KERNEL_SECTORS equ 1

bootloaderMain:
    ; enable A20 line
    call enableA20
    cmp ax, 1
    je .a_A20Enabled
    mov si, .STR_A20_FAILED
    call printStr
.a_A20Enabled:

    ; load kernel code
    mov si, .STR_LOADING_KERNEL
    call printStr

    ; disk IO
    mov ah, 0x02
    mov ch, 0   ; cylinder
    mov dh, 0   ; head
    mov dl, [bootDisk]
    mov cl, 4   ; sector
    mov al, NO_OF_KERNEL_SECTORS
    mov bx, 0x7C00+0x600
    ;mov bx, 0x9000
    int 13h

    ; disk IO status
    jc .diskReadFail
    cmp al, NO_OF_KERNEL_SECTORS
    jne .diskReadCountError
    
    mov si, .STR_LOADED
    call printStr
    
    ; load GDT
    lgdt [gdtDescriptor]

    mov si, .STR_SWITCHING
    call printStr

    ; switch to protected mode
    cli
    mov eax, cr0
    or eax, 0x01
    mov cr0, eax

    ; far jump to reset pipeline
    jmp CODE_SEGMENT:pmInit

    ; The call above transfers control to pmInit,
    ; which further transfers control to the kernel.
    ; It should never return, and thus the following
    ; code should never be reached.

    jmp loop

.diskReadFail:
    mov si, .STR_DISK_FAILED
    call printStr
    jmp loop

.diskReadCountError:
    mov si, .STR_DISK_COUNT_ERR
    call printStr
    jmp loop

    .STR_A20_FAILED:     db "[ERROR] A20 line could not be enabled", 0xA, 0xD, 0
    .STR_LOADING_KERNEL: db "Loading kernel code...", 0xA, 0xD, 0
    .STR_DISK_FAILED:    db "[ERROR] Disk read failed", 0xA, 0xD, 0
    .STR_DISK_COUNT_ERR: db "[ERROR] Disk read count mismatch", 0xA, 0xD, 0
    .STR_LOADED:         db "Kernel loaded successfully", 0xA, 0xD, 0
    .STR_SWITCHING:      db "GDT loaded, switching to protected mode...", 0xA, 0xD, 0

loop:
    jmp $

%include "a20.asm"
%include "gdt.asm"
%include "protectedMode.asm"