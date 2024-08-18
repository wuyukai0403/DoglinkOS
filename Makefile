CFLAGS = --no-standard-includes --no-standard-libraries -Ikernel/include

myos.img: boot/boot.bin kernel.bin
	dd if=/dev/zero of=myos.img bs=1M count=4
	dd if=boot/boot.bin of=myos.img conv=notrunc
	dd if=kernel.bin of=myos.img conv=notrunc bs=512 seek=1

kernel.bin: boot/kernel.bin kernel/kernel.bin
	cat boot/kernel.bin kernel/kernel.bin > kernel.bin

boot/boot.bin: boot/boot.asm
	nasm boot/boot.asm -o boot/boot.bin

boot/kernel.bin: boot/kernel.asm
	nasm boot/kernel.asm -o boot/kernel.bin

kernel/kernel.bin: kernel/kernel.elf
	objcopy -O binary --only-section=.text kernel/kernel.elf kernel/kernel.bin

kernel/kernel.elf: kernel/entry64.o kernel/functions.o kernel/interrupt.o
	ld -nostdlib kernel/entry64.o kernel/functions.o kernel/interrupt.o -e entry64 -o kernel/kernel.elf

kernel/entry64.o: kernel/entry64.c kernel/include/functions.h kernel/include/interrupt.h
	gcc $(CFLAGS) -c kernel/entry64.c -o kernel/entry64.o

kernel/functions.o: kernel/functions.c kernel/include/functions.h
	gcc $(CFLAGS) -c kernel/functions.c -o kernel/functions.o

kernel/interrupt.o: kernel/interrupt.c kernel/include/interrupt.h
	gcc $(CFLAGS) -c kernel/interrupt.c -o kernel/interrupt.o
