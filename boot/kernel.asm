jmp start

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

start:
mov ax, 0800h
mov ds, ax

mov si, message1
call printstr

lgdt [gdtr32]

in al, 0x92
or al, 2
out 0x92, al

cli

mov eax, cr0
or eax, 1
mov cr0, eax

jmp 0x0008:inprotectmode + 8000h

bits 32
inprotectmode:
mov ax, 10h
mov ds, ax
mov dword [0xb8000 + 3 * 160 + 0], 0x0c53
mov dword [0xb8000 + 3 * 160 + 2], 0x0c74
mov dword [0xb8000 + 3 * 160 + 4], 0x0c65
mov dword [0xb8000 + 3 * 160 + 6], 0x0c70
mov dword [0xb8000 + 3 * 160 + 8], 0x0c34
mov dword [0xb8000 + 3 * 160 + 10], 0x0c3a
mov dword [0xb8000 + 3 * 160 + 12], 0x0c20
mov dword [0xb8000 + 3 * 160 + 14], 0x0c69
mov dword [0xb8000 + 3 * 160 + 16], 0x0c6e
mov dword [0xb8000 + 3 * 160 + 18], 0x0c20
mov dword [0xb8000 + 3 * 160 + 20], 0x0c70
mov dword [0xb8000 + 3 * 160 + 22], 0x0c72
mov dword [0xb8000 + 3 * 160 + 24], 0x0c6f
mov dword [0xb8000 + 3 * 160 + 26], 0x0c74
mov dword [0xb8000 + 3 * 160 + 28], 0x0c65
mov dword [0xb8000 + 3 * 160 + 30], 0x0c63
mov dword [0xb8000 + 3 * 160 + 32], 0x0c74
mov dword [0xb8000 + 3 * 160 + 34], 0x0c20
mov dword [0xb8000 + 3 * 160 + 36], 0x0c6d
mov dword [0xb8000 + 3 * 160 + 38], 0x0c6f
mov dword [0xb8000 + 3 * 160 + 40], 0x0c64
mov dword [0xb8000 + 3 * 160 + 42], 0x0c65

mov eax, cr4
or eax, 1 << 5
mov cr4, eax

xor ecx, ecx
fill_p2:
mov eax, 200000h
mul ecx
add eax, 129
mov dword [p2_table_0 + 0x8000 + 8 * ecx], eax
inc ecx
cmp ecx, 2048
jne fill_p2

mov eax, p4_table + 0x8000
mov cr3, eax

mov ecx, 0xc0000080
rdmsr
or eax, 1 << 8
wrmsr

mov eax, cr0
or eax, 1 << 31
mov cr0, eax

lgdt [gdtr64 + 0x8000]

jmp 0x0008:inlongmode + 0x8000

bits 64

inlongmode:
mov rax, 0x2f592f412f4b2f4f
mov qword [0xb8000], rax

jmp entry64

over:
hlt
jmp $

message1:
db 'Step3: in kernelA', 0x0d, 0x0a, 0
gdt32:
dd 0
dd 0
dd 0x0000ffff ; flat code segment
dd 0x00cf9800
dd 0x0000ffff ; flat data segment
dd 0x00cf9200
dd 0          ; don't use
dd 0
gdtr32: dw 31
        dd gdt32 + 8000h
gdt64:
dq 0
dq (1<<43) | (1<<44) | (1<<47) | (1<<53)
gdtr64: dw 15
        dq gdt64 + 8000h
align 4096
p4_table:
dq p3_table + 0x8000 + 3
resq 511
p3_table:
dq p2_table_0 + 0x8000 + 3
dq p2_table_1 + 0x8000 + 3
dq p2_table_2 + 0x8000 + 3
dq p2_table_3 + 0x8000 + 3
resq 508
p2_table_0:
resq 512
p2_table_1:
resq 512
p2_table_2:
resq 512
p2_table_3:
resq 512
entry64:
