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

#define IDT ((IDT_Entry*)(0x7000))

void setup_interrupt();
void disable_8259A();
void register_interrupt_handler(unsigned char, void*);

#endif /* _INTERRUPT_H */
