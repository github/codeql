extern int externInt; // used as a source of non-determinism

void receiveInt(int);
void receiveIntPtr(int *p);
void receiveConstIntPtr(const int *p);

// Pointers and references to functions
void (*functionPointer)(int *p);
extern void (&functionReference)(int *p);
void (&referenceToreceiveIntPtr)(int *p) = receiveIntPtr;

struct IntPointer {
    int *p;
};

IntPointer globalIntPtr;
IntPointer *globalIntPtrPtr = &globalIntPtr;

static void readPointer1(int *ip) {
    int *p = ip;
    receiveInt(*p);
}

static void readPointer2(int *ip) {
    int *p = ip + 1;
    p--;
    receiveInt(*p);
}

static void readPPP(int ***ppp) {
    receiveInt(***ppp);
}

static void readPointer3(int *ip) {
    int *p = ip;
    int **pp = &p;
    readPPP(&pp);
}

void readPointer4(int *ip) {
    readPointer3(ip);
}

void readPointer5(int *ip) {
    receiveInt(ip[0]);
}

void readVarArgsByCount(int argCount, ...) {
    __builtin_va_list ap;

    __builtin_va_start(ap, argCount);
    for (int i = 0; i < argCount; i++) {
        int *p = __builtin_va_arg(ap, int*);
        receiveIntPtr(p);
    }
    __builtin_va_end(ap);
}

static void readRef1(int &i) {
    int *p = &i + 1;
    p--;
    receiveInt(*p);
}

static void readRef2(int &i) {
    if (externInt) {
        i = 0;
    }
    receiveInt(i);
}

static void readRef3(int &i) {
    readRef2(i);
}

static void leakPointer1(int *ip) {
    globalIntPtrPtr->p = ip;
}

static void readPointerConditional(int *ip) {
    if (externInt) {
        receiveInt(*ip);
    }
}

static void ignorePointer1(int *ip) {
}

// recursive
static void ignorePointer2(int *ip) {
    if (externInt > 0) {
        externInt--;
        ignorePointer1(ip);
        ignorePointer2(ip);
    }
}

static void writePointer1(int *ip) {
    *ip = 1;
}

static void writePointer2(int *ip) {
    ip[0] = 1;
}

static void writePointer3(int *ip) {
    *ip = 1;
    receiveInt(*ip);
}

static void writeRef3(int &i) {
    i = 1;
    receiveInt(i);
}

static void writePointer4(int *ip) {
    ip[0] = 1;
    ip++;
    ip--;
    receiveInt(*ip);
}

struct C {
    virtual void f(int &i) {
        // This function does not access i, but overrides might.
    }
};

struct NestedStruct {
    struct {
        struct {
            double d;
            int i;
        } level2;
    } level1;
};

void readNS1(NestedStruct *ns) {
    readPointer1(&ns->level1.level2.i);
}

void readNS2(NestedStruct *ns) {
    receiveInt(ns->level1.level2.i);
}

void writeNS1(NestedStruct *ns) {
    ns->level1.level2.i = 0;
}

void writeNS2(NestedStruct &ns) {
    ns.level1.level2.i = 0;
}

void caller(C *object) {
    int i;
    readPointer1(&i);
    readPointer2(&i);
    readPointer3(&i);
    readPointer4(&i);
    readPointer5(&i);
    readVarArgsByCount(0, &i); // does not actually read
    readVarArgsByCount(1, &i);
    readRef1(i);
    readRef2(i);
    readRef3(i);
    leakPointer1(&i);
    readPointerConditional(&i);
    ignorePointer1(&i);
    ignorePointer2(&i);
    writePointer1(&i);
    writePointer2(&i);
    writePointer3(&i);
    writePointer4(&i);
    writeRef3(i);
    object->f(i);
    functionPointer(&i);
    functionReference(&i);
    referenceToreceiveIntPtr(&i);

    NestedStruct ns;
    readNS1(&ns);
    readNS2(&ns);
    writeNS1(&ns);
    writeNS2(ns);

    receiveInt(*globalIntPtrPtr->p);
    functionPointer = receiveIntPtr;
}
