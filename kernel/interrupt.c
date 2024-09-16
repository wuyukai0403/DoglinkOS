#include "interrupt.h"
#include "functions.h"

void __c_interrupt_handler(INT_STACK *interrupt_stack)
{
    ((void (*)(INT_STACK *))(interrupt_handlers[interrupt_stack -> code]))(interrupt_stack);
}

void example_handler(INT_STACK *interrupt_stack)
{
    putchar(0, 0, '#');
}

void setup_interrupt()
{
    for (int i = 0; i < 256; i++) IDT[i].S = 0x08, IDT[i].TYPE = 0x0E;
    disable_8259A();
    unsigned char idtr[] = {0xff, 0xf, 0, 0x70, 0, 0, 0, 0, 0, 0};
    asm volatile ("lidt %0"::"m"(idtr));
    asm volatile ("sti");
    register_interrupt_handler(32, example_handler);
}

void disable_8259A()
{
    asm volatile ("outb %b0, %w1"::"a"(0xff),"Nd"(0x21));
    asm volatile ("outb %b0, %w1"::"a"(0xff),"Nd"(0xA1));
}

void register_interrupt_handler(unsigned char n, void *handler)
{
    unsigned long long real_addr = (unsigned long long)handler;
    interrupt_handlers[n] = real_addr;
    small_routines[n * 8] = 0x6a;
    small_routines[n * 8 + 1] = n;
    small_routines[n * 8 + 2] = 0xe9;
    unsigned long long p = (unsigned long long)(small_routines + n * 8 + 3);
    *((int*)p) = (int)((unsigned long long)__asm_interrupt_handler - (p + 4));
    unsigned long long addr = small_routines + n * 8;
    IDT[n].A0 = addr & 0xffff;
    IDT[n].A1 = (addr >> 16) & 0xffff;
    IDT[n].A2 = (addr >> 32);
    IDT[n].P = 1;
}
