mov ax, 07c0h
mov ds, ax

printstr:
      mov al, message
      cmp al, 0
      je over
      mov ah, 0eh
      int 10h
      inc si
      jmp printstr

over:
hlt
jmp over

message:
db 'Step1: in MBR', 0

times 510-($-$$) db 0
dw 0xaa55
