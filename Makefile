CC := gcc
AS := nasm
LD := ld

ARCH := i386
ARCH_DIR := arch/$(ARCH)

include $(ARCH_DIR)/make.config

CFLAGS := $(ARCH_CFLAGS) -Wall -Wextra -ffreestanding
AFLAGS := $(ARCH_AFLAGS)
LFLAGS := $(ARCH_LFLAGS) -nostdlib -T$(ARCH_DIR)/linker.ld

SRC := $(ARCH_SRC) $(shell find kernel -type f \( -name *.c -o -name *.asm \) )
OBJ := $(patsubst %, %.o, $(basename $(SRC)))
INC := -Ikernel/include

TARGET  := noname-$(shell date +"%Y.%m.%d")-$(ARCH).iso
KERNEL  := kernel.elf

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
	$(ARCH_QEMU) $(TARGET)

clean:
	rm -rf $(OBJ) $(KERNEL) $(TARGET)

$(TARGET): $(KERNEL)
	mkdir -p ./iso/boot/grub
	echo -n "$${GRUB_CFG}" > ./iso/boot/grub/grub.cfg
	mv $(KERNEL) ./iso/boot/$(KERNEL)
	grub-mkrescue iso -o $(TARGET)

$(KERNEL): $(OBJ)
	$(LD) $(LFLAGS) -o $@ $^
%.o: %.c
	$(CC) -c $(CFLAGS) $(INC) -o $@ $<
%.o: %.asm
	$(AS) $(AFLAGS) -o $@ $<
