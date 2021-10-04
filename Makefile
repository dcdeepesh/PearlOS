SRC_DIR = src
BUILD_DIR = build
OUT_DIR = out

LD = i686-elf-ld
CC = i686-elf-gcc
CFLAGS = -ffreestanding -Isrc

BOOTLOADER_SOURCES = $(wildcard src/boot/*.asm)
KERNEL_SOURCES = $(wildcard src/kernel/*.c)
C_OBJS = $(patsubst %.c,%.o,$(subst $(SRC_DIR)/,$(BUILD_DIR)/,$(KERNEL_SOURCES)))


# The final output
.PHONY: all
all: .setup $(OUT_DIR)/pearlOS.bin

$(OUT_DIR)/pearlOS.bin: $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/kernel.bin
	cat $^ > $@

# Bootloader
$(BUILD_DIR)/bootloader.bin: $(BOOTLOADER_SOURCES)
	nasm -f bin -o $@ -i $(SRC_DIR)/boot $(SRC_DIR)/boot/bootloader.asm

# Kernel and stub
$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel/kernelStub.o $(C_OBJS)
	$(LD) -Ttext 0x8300 --oformat binary -o $@ $^

$(BUILD_DIR)/kernel/kernelStub.o: $(SRC_DIR)/kernel/kernelStub.asm
	nasm -f elf32 -o $@ $^

# C
$(BUILD_DIR)/%.o:
	$(CC) $(CFLAGS) -c -o $@ $(SRC_DIR)/$*.c

.PHONY: .setup
.setup $(BUILD_DIR)/depend:
	mkdir -p $(BUILD_DIR)/kernel $(OUT_DIR)
	$(CC) $(CFLAGS) -MM $(KERNEL_SOURCES) | \
	sed -E 's#^(.*\.o: *)src/(.*/)?(.*\.c)#build/\2\1src/\2\3#' > $(BUILD_DIR)/depend

include $(BUILD_DIR)/depend

# Miscellaneous
.PHONY: run
run: all
	cmd.exe /c run.bat

.PHONY: clean
clean:
	rm -rf $(OUT_DIR) $(BUILD_DIR)