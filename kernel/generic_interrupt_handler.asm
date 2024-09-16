global __asm_interrupt_handler
;extern __c_interrupt_handler
__asm_interrupt_handler:
;push rax
;push rbx
;push rcx
;push rdx
;call __c_interrupt_handler
mov eax, 0xb8000
mov word [eax], 0x0723
add rsp, 8
iretq
