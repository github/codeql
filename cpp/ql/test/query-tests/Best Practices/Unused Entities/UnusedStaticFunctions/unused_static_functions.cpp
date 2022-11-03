
// f1 is reachable via fs
static void f1(void) { }

struct funstr {
    void (*someFun)(void);
};

class myClass {
public:
    static const funstr fs[];
};

const funstr myClass::fs[] = {
    { f1 },
};

// f2 is unreachable
static void f2(void) { }

// f3 is reachable via f4/pf3
static void f3(void) { }

// f4 is reachable due to not being static
void f4(void) {
    static void (*pf3)(void);

    pf3 = f3;
}

// f5 and f6 are mutually recursive unreachable static functions
static void f6(void);
static void f5(void) { f6(); }
static void f6(void) { f5(); }

