# Nom du fichier de sortie
OUTPUT_BIN = myos.bin
ISO = myos.iso

# Compilateur et assembleur
AS = i686-elf-as
CC = i686-elf-gcc

# Options de compilation pour le noyau
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra \
         -fno-builtin -fno-exceptions -fno-stack-protector -fno-rtti -nostdlib -nodefaultlibs

# Options de linking
LDFLAGS = -T linker.ld -ffreestanding -O2 -nostdlib

# Cibles
all: $(ISO)

# Assemblage de boot.s en boot.o
boot.o: boot.s
	$(AS) boot.s -o boot.o

# Compilation de kernel.c en kernel.o
kernel.o: kernel.c
	$(CC) -c kernel.c -o kernel.o $(CFLAGS)

# Linker les fichiers objets pour créer le noyau exécutable myos.bin
$(OUTPUT_BIN): boot.o kernel.o
	$(CC) $(LDFLAGS) -o $(OUTPUT_BIN) boot.o kernel.o -lgcc

# Vérification multiboot avec grub-file
multiboot-check: $(OUTPUT_BIN)
	@if grub-file --is-x86-multiboot $(OUTPUT_BIN); then \
	  echo "multiboot confirmed"; \
	else \
	  echo "the file is not multiboot"; \
	  exit 1; \
	fi

# Création de l'ISO avec GRUB
$(ISO): $(OUTPUT_BIN) multiboot-check
	mkdir -p isodir/boot/grub
	cp $(OUTPUT_BIN) isodir/boot/
	echo 'menuentry "myos" {' > isodir/boot/grub/grub.cfg
	echo '  multiboot /boot/$(OUTPUT_BIN)' >> isodir/boot/grub/grub.cfg
	echo '}' >> isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) isodir

# Commande pour lancer QEMU avec l'ISO généré
run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

# Nettoyage des fichiers générés
clean:
	rm -rf *.o $(OUTPUT_BIN) $(ISO) isodir

