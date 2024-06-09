CC=gcc
AS=nasm
LD=ld

QEMU=qemu-system-i386

AFLAGS := -felf32
CFLAGS := -m32 -ffreestanding -std=gnu99 -Wall -Wextra
# CFLAGS += -I ./include
LFLAGS= -melf_i386 -nostdlib -T ./link.ld

.PHONY: all

SRC := $(shell find -type f -name *.c)
SRC += $(shell find -type f -name *.asm)
OBJ := $(patsubst %,%.o, $(basename $(SRC)))

ISODIR := ./iso
TARGET := disk.img
KERNEL := kernel.elf_i386

define GRUB_CFG
set timeout = 0
set default = 0

menuentry "OSdev" {
    multiboot2 /boot/$(KERNEL)
    boot
}
endef
export GRUB_CFG

all: $(TARGET) clean qemu

clean:
	rm -rf $(OBJ)
qemu:
	$(QEMU) $(TARGET)

$(TARGET): $(KERNEL)
	mkdir -p $(ISODIR)/boot/grub
	echo "$${GRUB_CFG}" > $(ISODIR)/boot/grub/grub.cfg
	mv $(KERNEL) $(ISODIR)/boot/$(KERNEL)
	grub2-mkrescue $(ISODIR) -o $@

$(KERNEL): $(OBJ)
	$(LD) $(LFLAGS) $^ -o $@

%.o: %.asm
	$(AS) $(AFLAGS) -o $@ $<
%.o: %.c
	$(CC) $(CFLAGS) -c $< $@