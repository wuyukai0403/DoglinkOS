mov ax, 0800h
mov ds, ax

mov si, message
call printstr

over:
hlt
jmp over

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
 
 message:
 db 'Step3: in kernelA', 0x0d, 0x0a, 0
