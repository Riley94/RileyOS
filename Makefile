# $@ = target file
# $< = first dependency
# $^ = all dependencies

# detect all .o files based on their .c source
C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c)
HEADERS = $(wildcard kernel/*.h  drivers/*.h cpu/*.h)
OBJ_FILES = ${C_SOURCES:.c=.o}
ASM_OBJ = cpu/interrupt.o
BUILD_DIR = build
KERNEL_BIN = $(BUILD_DIR)/kernel/kernel.bin

# unless already defined, define
CC ?= x86_64-elf-gcc
LD ?= x86_64-elf-ld

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Notice how dependencies are built as needed
$(KERNEL_BIN): boot/kernel_entry.o ${OBJ_FILES} $(ASM_OBJ)
	$(LD) -m elf_i386 -o $@ -Ttext 0x1000 $(BUILD_DIR)/boot/kernel_entry.o $(addprefix $(BUILD_DIR)/,$(OBJ_FILES)) $(BUILD_DIR)/$(ASM_OBJ) --oformat binary

os-image.bin: boot/boot.bin $(KERNEL_BIN)
	cat $(BUILD_DIR)/$^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

# view byte representation of bin
echo: os-image.bin
	xxd $<

# only for debug
kernel.elf: boot/kernel_entry.o ${OBJ_FILES}
	$(LD) -m elf_i386 -o $@ -Ttext 0x1000 $^

debug: os-image.bin kernel.elf
	qemu-system-i386 -s -S -fda os-image.bin -d guest_errors,int &
	i386-elf-gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# build object files from C files/headers
%.o: %.c ${HEADERS}
	$(CC) -g -m32 -ffreestanding -fno-pie -fno-stack-protector -c $< -o $(BUILD_DIR)/$@ # -g for debugging

# build object files from asm
%.o: %.asm
	nasm $< -f elf -o $(BUILD_DIR)/$@

# make binary of asm
%.bin: %.asm
	nasm $< -f bin -o $(BUILD_DIR)/$@

# disassemble
%.dis: %.bin
	ndisasm -b 32 $< > $@

clean:
	$(RM) build/kernel/*.o
	$(RM) build/boot/*.o build/boot/*.bin
	$(RM) build/drivers/*.o
	$(RM) build/cpu/*.o
