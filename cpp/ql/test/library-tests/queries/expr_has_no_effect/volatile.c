
char c;
volatile char v;

char *pc;
volatile char *pv;

void f(void) {
    c;
    v;

    pc[5];
    pv[5];
    ((volatile char *)pc)[5];

    *pc;
    *pv;
    *((volatile char *)pc);

    *(pc + 5);
    *(pv + 5);
    *((volatile char *)(pc + 5));
    *(((volatile char *)pc) + 5);
}

