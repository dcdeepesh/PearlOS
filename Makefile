SRC_DIR = src
BUILD_DIR = build
OUT_DIR = out

LD = i686-elf-ld
GCC = i686-elf-gcc

BOOTLOADER_SOURCES = $(wildcard src/boot/*.asm)
KERNEL_SOURCES = $(wildcard src/kernel/*.c)
C_OBJS = $(patsubst %.c,%.o,$(subst $(SRC_DIR)/,$(BUILD_DIR)/,$(KERNEL_SOURCES)))


# The final output
.PHONY: all
all: $(OUT_DIR)/pearlOS.bin

$(OUT_DIR)/pearlOS.bin: $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/kernel.bin
	-mkdir $(OUT_DIR)
	cat $^ > $@

# Bootloader
$(BUILD_DIR)/bootloader.bin: $(BOOTLOADER_SOURCES)
	mkdir -p $(BUILD_DIR)
	nasm -f bin -o $@ -i $(SRC_DIR)/boot $(SRC_DIR)/boot/bootloader.asm

# Kernel
$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel/kernelStub.o $(C_OBJS)
	echo $(C_OBJS)
	$(LD) -Ttext 0x8300 --oformat binary -o $@ $^

$(BUILD_DIR)/kernel/kernelStub.o: $(SRC_DIR)/kernel/kernelStub.asm
	mkdir -p $(@D)
	nasm -f elf32 -o $@ $^

$(BUILD_DIR)/kernel/%.o: $(SRC_DIR)/kernel/%.c
	mkdir -p $(@D)
	$(GCC) -ffreestanding -c -Isrc -o $@ $^


.PHONY: run
run: all
	cmd.exe /c run.bat

.PHONY: clean
clean:
	rm -r out/ build/