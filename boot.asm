section .multiboot_header
header_start:
    dd 0xe85250d6                ; magic number (multiboot 2)
    dd 0                         ; architecture 0 (protected mode i386)
    dd header_end - header_start ; header length
    ; checksum
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; insert optional multiboot tags here
    ; required end tag
    dw 0    ; type
    dw 0    ; flags
    dw 8    ; size
header_end:

section .bss
stack_bottom: resb 16384; 16 KiB
stack_space: resb 8192 ; 8KB for stack
stack_top:

section .text
global _start
_start:
    mov esp, stack_top
    extern kernel_main
    call kernel_main
    cli
.hang:
    hlt
    jmp .hang
