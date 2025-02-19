CC := gcc
AS := nasm
LD := ld

SRC := $(shell find boot kernel -type f \( -name *.c -o -name *.asm \))
OBJ := $(patsubst %, %.o, $(basename $(SRC)))

AFLAGS := -felf32
CFLAGS := -m32 -c -ffreestanding -Wall -Wextra
LFLAGS := -melf_i386 -nostdlib -Tlinker.ld

KERNEL := kernel.elf
TARGET := vroum-x86_64.iso

define GRUB_CFG

set timeout=0
set default=0

menuentry "$(basename $(TARGET))" {
	multiboot2 /boot/$(KERNEL)
	boot
}

endef
export GRUB_CFG

all: $(TARGET) qemu

qemu:
	qemu-system-x86_64 $(TARGET)

clean:
	rm -rf iso $(OBJ) $(KERNEL) $(TARGET)

$(TARGET): $(KERNEL)
	mkdir -p iso/boot/grub
	echo -n "$${GRUB_CFG}" > iso/boot/grub/grub.cfg
	cp $(KERNEL) iso/boot/$(KERNEL)
	grub-mkrescue /usr/lib/grub/i386-pc iso -o $@

$(KERNEL): $(OBJ)
	$(LD) $(LFLAGS) -o $@ $^
%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<
%.o: %.asm
	$(AS) $(AFLAGS) -o $@ $<
