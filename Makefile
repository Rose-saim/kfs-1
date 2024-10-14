CC = gcc
AS = nasm
LD = ld
CFLAGS = -m32 -nostdlib -nostartfiles -nostdinc -fno-builtin -fno-stack-protector -fno-rtti -nodefaultlibs
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld -o kernel.bin

all: kernel.bin

kernel.bin: kernel.o boot.o
	$(LD) $(LDFLAGS) kernel.o boot.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

boot.o: boot.asm
	$(AS) $(ASFLAGS) boot.asm -o boot.o

clean:
	rm -f *.o kernel.bin

