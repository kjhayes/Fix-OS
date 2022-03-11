CC = gcc
ASM = nasm

BINARY_DIR = ./bin

BOOT_DIR = ./boot
BOOT_FLAGS = 

KERNEL_DIR = ./kernel
ASMKERNEL_FLAGS = -f win32
CKERNEL_FLAGS = -c -I./kernel/include -ffreestanding -m32

KERNEL_SOURCES = $(wildcard ${KERNEL_DIR}/*.c ${KERNEL_DIR}/*.s)
KERNEL_OBJ = $(addprefix ${BINARY_DIR}/, $(notdir $(patsubst %.s,%.o,$(patsubst %.c,%.o,${KERNEL_SOURCES}))))

${BINARY_DIR}/image.bin : ${BINARY_DIR}/bootloader.bin ${BINARY_DIR}/kernel.bin
	cat ${BINARY_DIR}/bootloader.bin ${BINARY_DIR}/kernel.bin > ${BINARY_DIR}/image.bin

${BINARY_DIR}/kernel.bin : ${KERNEL_OBJ}
	ld -o${BINARY_DIR}/kernel.tmp -T./link/script.ld $^
	objcopy -O binary ${BINARY_DIR}/kernel.tmp $@
	-rm ${BINARY_DIR}/*.tmp

${BINARY_DIR}/%.o : ${KERNEL_DIR}/%.c
	${CC} ${CKERNEL_FLAGS} $^ -o$@
${BINARY_DIR}/%.o : ${KERNEL_DIR}/%.s
	${ASM} ${ASMKERNEL_FLAGS} $^ -o$@

${BINARY_DIR}/%.bin : ${BOOT_DIR}/%.s
	${ASM} ${BOOT_FLAGS} $^ -o$@

run: ${BINARY_DIR}/image.bin
	qemu-system-x86_64.exe -drive file=${BINARY_DIR}/image.bin,format=raw -monitor stdio

clean:
	-rm ${BINARY_DIR}/*.o
	-rm ${BINARY_DIR}/*.bin
	-rm ${BINARY_DIR}/*.tmp
