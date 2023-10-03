myos.img: boot.bin
	dd if=/dev/zero of=myos.img bs=1M count=4
	dd if=boot.bin of=myos.img conv=notrunc

boot.bin: boot.asm
	nasm boot.asm -o boot.bin
