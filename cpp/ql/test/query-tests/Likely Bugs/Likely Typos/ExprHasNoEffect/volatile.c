
char c;
volatile char v;

char *pc;
volatile char *pv;

void f(void) {
    c; // $ Alert // BAD
    v; // (accesses to volatile variables are considered impure)

    pc[5]; // $ Alert // BAD
    pv[5];
    ((volatile char *)pc)[5];

    *pc; // $ Alert // BAD
    *pv;
    *((volatile char *)pc);

    *(pc + 5); // $ Alert // BAD
    *(pv + 5);
    *((volatile char *)(pc + 5));
    *(((volatile char *)pc) + 5);
}
