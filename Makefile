./image.bin : ./bin/bootloader.bin ./bin/kernel.bin
	cat ./bin/bootloader.bin ./bin/kernel.bin > ./image.bin

./bin/kernel.bin : ./bin/kernel_entry.o ./bin/kernel_main.o
	ld -o./bin/kernel.tmp -Ttext 0x1000 ./bin/kernel_entry.o ./bin/kernel_main.o
	objcopy -O binary -j .text  ./bin/kernel.tmp ./bin/kernel.bin

./bin/kernel_main.o : ./kernel/kernel_main.c
	gcc -c -ffreestanding ./kernel/kernel_main.c -o./bin/kernel_main.o

./bin/kernel_entry.o : ./kernel/kernel_entry.s
	nasm ./kernel/kernel_entry.s -f win32 -o ./bin/kernel_entry.o

./bin/bootloader.bin : ./boot/Bootloader.s
	nasm ./boot/Bootloader.s -o./bin/bootloader.bin
