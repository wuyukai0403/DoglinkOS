#include "functions.h"
#include "interrupt.h"

void entry64()
{
    putchar(11, 39, 'C');
    putchar(11, 40, 'C');
    putchar(12, 39, 'C');
    putchar(12, 40, 'C');
    setup_interrupt();
    putchar(1, 0, 'S');
    putchar(1, 1, 'u');
    putchar(1, 2, 'c');
    putchar(1, 3, 'c');
    putchar(1, 4, 'e');
    putchar(1, 5, 's');
    putchar(1, 6, 's');
//    asm volatile ("hlt");
    asm volatile ("int $32");
    while (1);
}
