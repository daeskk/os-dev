org 0

bits 16

short_jmp:
    jmp short _start
    nop

times 33 db 0

_start:
    jmp 0x7c0:start

start:
    cli
    
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    
    sti

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, buffer
    int 0x13
    jc  error_msg

    mov si, buffer
    call print

    jmp $

error_msg:
    mov si, error_message
    call print
    jmp $

print:
    mov ah, 0eh
.loop:
    lodsb

    cmp al, 0
    je .done

    call print_char

    jmp .loop

.done:
    ret

print_char:
    int 0x10
    ret

error_message: db 'error loading sector...', 0

times 510-($-$$) db 0

dw 0xaa55

buffer: