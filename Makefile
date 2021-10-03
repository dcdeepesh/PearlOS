SRC_DIR = src
BUILD_DIR = build
OUT_DIR = out

BOOTLOADER_SOURCES = $(wildcard src/boot/*.asm)

.PHONY: all
all: $(OUT_DIR)/pearlOS.bin

$(OUT_DIR)/pearlOS.bin: $(BUILD_DIR)/bootloader.bin #build/kernel.bin
	-mkdir $(OUT_DIR)
	cat $^ > $@

$(BUILD_DIR)/bootloader.bin: $(BOOTLOADER_SOURCES)
	-mkdir $(BUILD_DIR)
	nasm -f bin -o $@ -i $(SRC_DIR)/boot $(SRC_DIR)/boot/bootloader.asm

#build/kernel.bin:

.PHONY: clean
clean:
	rm -r out/ build/