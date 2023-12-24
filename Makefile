myos.img: boot/boot.bin boot/kernel.bin
	dd if=/dev/zero of=myos.img bs=1M count=4
	dd if=boot/boot.bin of=myos.img conv=notrunc
	dd if=boot/kernel.bin of=myos.img conv=notrunc bs=512 seek=1

boot/boot.bin: boot/boot.asm
	nasm boot/boot.asm -o boot/boot.bin

boot/kernel.bin: kernel.asm
	nasm boot/kernel.asm -o boot/kernel.bin
