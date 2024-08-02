org 0x7c00

bits 16

code_segment equ gdt_code - gdt_start ; 0x8
data_segment equ gdt_data - gdt_start ; 0x10

short_jmp:
    jmp short _start
    nop

times 33 db 0

_start:
    jmp 0:start

start:
    cli
    
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    
    sti

.load_protected_mode:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or  eax, 0x1
    mov cr0, eax
    jmp code_segment:load32

gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

; 0ffset 0x8
gdt_code: ; cs point here
    dw 0xffff
    dw 0
    db 0
    db 0x9a
    db 11001111b
    db 0

; offset 0x10
gdt_data: ; ds, ss, es, fs, gs
    dw 0xffff
    dw 0
    db 0
    db 0x92
    db 11001111b
    db 0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start-1 
    dd gdt_start

[bits 32]

load32:
    mov ax, data_segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    jmp $

times 510-($-$$) db 0

dw 0xaa55

buffer: