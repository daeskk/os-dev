org 0x7c00

bits 16

code_segment equ gdt_code - gdt_start ; 0x8
data_segment equ gdt_data - gdt_start ; 0x10

short_jmp:
    jmp short _load
    nop

times 33 db 0

_load:
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
    mov eax, 1          ; starting sector
    mov ecx, 100
    mov edi, 0x0100000
    call ata_lba_read

    jmp code_segment:0x0100000

ata_lba_read:
    mov ebx, eax
    shr eax, 24
    or eax, 0xe0 ; master drive
    mov dx, 0x1f6
    out dx, al

    mov eax, ecx
    mov dx, 0x1f2
    out dx, al

    mov eax, ebx
    mov dx, 0x1f3
    out dx, al

    mov dx, 0x1f4
    mov eax, ebx
    shr eax, 8
    out dx, al

    mov dx, 0x1f5
    mov eax, ebx
    shr eax, 16
    out dx, al

    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

    ; reading all sectors into mem

.next_sector:
    push ecx

.try_again:
    mov dx, 0x1f7
    in al, dx
    test al, 8
    jz .try_again

    mov ecx, 256
    mov dx, 0x1f0
    rep insw
    pop ecx

    loop .next_sector

    ret

times 510-($-$$) db 0

dw 0xaa55