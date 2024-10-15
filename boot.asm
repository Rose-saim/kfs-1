section .multiboot_header
align 8
header_start:
    dd 0xe85250d6                ; magic number (multiboot 2)
    dd 0                         ; architecture 0 (protected mode i386)
    dd header_end - header_start  ; header length
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start)) ; checksum

    ; required end tag
    dw 0    ; type
    dw 0    ; flags
    dd 8    ; size of the end tag (must be 8 bytes)
header_end:

section .bss
align 16
stack_bottom: resb 16384         ; reserve 16 KiB for the stack
stack_space:  resb 8192          ; reserve 8KB for the stack
stack_top:

section .text
extern kernel_main               ; import the C function from the kernel

global _start
_start:
    mov esp, stack_top           ; set the stack pointer
    call kernel_main             ; call the C kernel entry function
    cli                          ; disable interrupts

.hang:
    hlt                          ; halt the CPU
    jmp .hang                    ; infinite loop to halt
