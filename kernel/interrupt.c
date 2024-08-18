#include "interrupt.h"

unsigned char __attribute__((__section__(".text"))) example_handler[] = {
    0xB8, 0x00, 0x80, 0x0B, 0x00, // MOV EAX, 000B8000
    0x66, 0xC7, 0x00, 0x23, 0x07, // MOV WORD PTR [RAX], 0723
    0x48, 0xCF,                   // IRETQ
};

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
    unsigned long long addr = (unsigned long long)handler;
    IDT[n].A0 = addr & 0xffff;
    IDT[n].A1 = (addr >> 16) & 0xffff;
    IDT[n].A2 = (addr >> 32);
    IDT[n].P = 1;
}
