gdtBegin:

gdtNull:
    dq 0
gdtCode:
    dw 0xFFFF
    dw 0
    db 0
    db 10011010b    ; access byte
    db 0xCF         ; flags and limit
    db 0
gdtData:
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b    ; access byte
    db 0xCF         ; flags and limit
    db 0

gdtEnd:

gdtDescriptor:
    dw gdtEnd - gdtBegin - 1    ; size
    dd gdtBegin                 ; offset

CODE_SEGMENT equ gdtCode - gdtBegin
DATA_SEGMENT equ gdtData - gdtBegin