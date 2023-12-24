#include "functions.h"

void putchar(int x, int y, char ch)
{
    *(char *)(0xb8000 + x * 160 + y * 2) = ch;
}
