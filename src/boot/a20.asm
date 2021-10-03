; returns - AX - whether A20 is enabled (0=false, 1=true)
checkA20:
    push si
    push di
    push ds
    push es

    mov si, .STR_CHECKING
    call printStr
    
    ; [ds:cx]
    mov ax, 0
    mov ds, ax
    mov si, 0
    ; [es:dx] same position with wrap-around
    mov ax, 0xFFFF
    mov es, ax
    mov di, 0x0010

    ; save current values in those positions
    mov al, byte [ds:si]
    push ax
    mov al, byte [es:di]
    push ax

    ; set values
    mov byte [ds:si], 0xAB
    mov byte [es:di], 0xCD
    ; compare to set flag
    cmp byte [ds:si], 0xCD

    ; restore values in those positions
    pop ax
    mov byte [es:di], al
    pop ax
    mov byte [ds:si], al

    ; check status
    mov ax, 0
    je .A20Disabled
    mov ax, 1
    mov si, .STR_ENABLED
    call printStr
    jmp .return

.A20Disabled:
    mov si, .STR_DISABLED
    call printStr

.return:
    pop es
    pop ds
    pop di
    pop si
    ret

    .STR_CHECKING: db "Checking A20 status... ", 0
    .STR_ENABLED: db "enabled", 0xA, 0xD, 0
    .STR_DISABLED: db "disabled", 0xA, 0xD, 0

; returns - AX - A20 status (after) (0=disabled, 1=enabled)
enableA20:
    push si
    call checkA20
    cmp ax, 1
    je .return

    ;; BIOS method

    mov si, .STR_BIOS_TRY
    call printStr

    ; check support
    mov ax, 0x2403
    int 15h
    jc .unsupported
    cmp ah, 0
    jne .unsupported

    ; activate A20 line
    mov ax, 0x2401
    int 15h
    jc .failed
    cmp ah, 0
    je .succeeded

.failed:
    mov si, .STR_FAILED
    call printStr
    jmp .keyboardMethod

.unsupported:
    mov si, .STR_UNSUPPORTED
    call printStr

    ;; Keyboard controller method



.keyboardMethod:
    mov si, .STR_BIOS_TRY
    call printStr

    cli
    ;TODO
    sti

    mov si, .STR_FAILED
    call printStr

    ;; Nothing worked, return
    
    mov ax, 0
    jmp .return

.succeeded:
    mov si, .STR_SUCCEEDED
    call printStr
    mov ax, 1

.return:
    pop si
    ret

    .STR_BIOS_TRY:     db "Trying BIOS method... ", 0
    .STR_KEYBOARD_TRY: db "Trying keyboard controller method... ", 0
    .STR_UNSUPPORTED:  db "unsupported", 0xA, 0xD, 0
    .STR_FAILED:       db "failed", 0xA, 0xD, 0
    .STR_SUCCEEDED:    db "succeeded", 0xA, 0xD, 0