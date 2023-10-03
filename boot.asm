mov ax, 07c0h
mov ds, ax

mov byte [01fdh], dl

mov si, message1
call printstr

mov si, message2
call printstr
mov si, kernel_disk_addr_pkt
mov dl, byte [01fdh]
mov ah, 42h
int 13h

jmp 0800h:0000h

printstr:
      mov al, byte [si]
      cmp al, 0
      je end
      mov ah, 0eh
      int 10h
      inc si
      jmp printstr
      end:
      ret

message1:
db 'Step1: in MBR', 0x0d, 0x0a, 0
message2:
db 'Step2: reading kernel', 0x0d, 0x0a, 0
kernel_disk_addr_pkt:
db 16
db 0
dw 15
dd 08000000h
dq 1

times 510-($-$$) db 0
dw 0xaa55
