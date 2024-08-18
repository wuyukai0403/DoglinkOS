#include "interrupt.h"

void setup_interrupt()
{
    for (int i = 0; i < 256; i++) IDT[i].S = 0x08, IDT[i].TYPE = 0x0E;
    disable_8259A();
    unsigned char idtr[] = {0xff, 0xf, 0, 0x70, 0, 0, 0, 0, 0, 0};
    asm volatile ("lidt %0"::"m"(idtr));
    asm volatile ("sti");
}

void disable_8259A()
{
    asm volatile ("outb %b0, %w1"::"a"(0xff),"Nd"(0x21));
    asm volatile ("outb %b0, %w1"::"a"(0xff),"Nd"(0xA1));
}

void register_interrupt_handler(unsigned char n, void (*handler)(void))
{
    unsigned long long addr = (unsigned long long)handler;
    IDT[n].A0 = addr & 0xffff;
    IDT[n].A1 = (addr >> 16) & 0xffff;
    IDT[n].A2 = (addr >> 32);
    IDT[n].P = 1;
}

void example_handler()
{
    putchar(4, 23, 'I');
    asm ("iretq");
}
