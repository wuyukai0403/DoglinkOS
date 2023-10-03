myos.img: boot.bin kernel.bin
	dd if=/dev/zero of=myos.img bs=1M count=4
	dd if=boot.bin of=myos.img conv=notrunc
	dd if=kernel.bin of=myos.img conv=notrunc bs=512 seek=1

boot.bin: boot.asm
	nasm boot.asm -o boot.bin

kernel.bin: kernel.asm
	nasm kernel.asm -o kernel.bin
