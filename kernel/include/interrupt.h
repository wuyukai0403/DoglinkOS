#ifndef _INTERRUPT_H
#define _INTERRUPT_H

typedef struct
{
    unsigned short A0;
    unsigned short S;
    unsigned char IST:3;
    unsigned char RSV0:5;
    unsigned char TYPE:4;
    unsigned char RSV1:1;
    unsigned char DPL:2;
    unsigned char P:1;
    unsigned short A1;
    unsigned int A2;
    unsigned int RSV2;
}IDT_Entry;

typedef struct
{
    unsigned long long r15;
    unsigned long long r14;
    unsigned long long r13;
    unsigned long long r12;
    unsigned long long r11;
    unsigned long long r10;
    unsigned long long r9;
    unsigned long long r8;
    unsigned long long rdi;
    unsigned long long rsi;
    unsigned long long rbp;
    unsigned long long rdx;
    unsigned long long rcx;
    unsigned long long rbx;
    unsigned long long rax;
    unsigned long long code;
}INT_STACK;

#define IDT ((IDT_Entry*)(0x7000))
#define interrupt_handlers ((unsigned long long*)(0x6800))
#define small_routines ((unsigned char*)(0x6000))

void __asm_interrupt_handler();
void __c_interrupt_handler(INT_STACK *);
void setup_interrupt();
void disable_8259A();
void register_interrupt_handler(unsigned char, void*);

#endif /* _INTERRUPT_H */
