
extern void somefun0(void);
extern void somefun2(int i, int j);

struct someStruct {
    int i;
    int j;
};

int topLevel1 = 1;
int topLevel2 = 1 + 2;

void (*pfunvv)(void);
int getInt(void);

void misc1(int argi, int argj) {
    int i, j, is[3];
    i = 0;
    i = 1 + 2;
    ++i;
    i += 1;
    if (argi && argj) {
        i = 3;
    } else {
        i = 4;
    }
    if (argi || argj) {
        i = 3;
    } else {
        i = 4;
    }
    if (i && j) {
        i = 3;
    } else {
        i = 4;
    }
    if (i || j) {
        i = 3;
    } else {
        i = 4;
    }
    { }
    ;
    while(i) {
        j++;
    }
    while(i && j) {
        j++;
    }
    while(i || j) {
        j++;
    }
    while(argi) {
        j++;
    }
    do {
        j++;
    } while(i);
    do {
        j++;
    } while(argi);
    for(i = 0; i < 10; i++) {
    }
    for(; i < 10; i++) {
    }
    for(i = 0; ; i++) {
    }
    for(i = 0; i < 10;) {
    }
    for(; ; i++) {
    }
    for(; i < 10;) {
    }
    for(i = 0; ;) {
    }
    for(;;) {
    }
    goto LAB;
    ;
LAB:
    ;
    somefun0();
    somefun2(i, j);
    (somefun2)(i, j);
    i = is[1];
    if (i > 3) ;
    if (!i) ;
    i = j ? 1 : 2;
}

void gnuConditionalOmittedOperand(struct someStruct *sp) {
    int i, j;
    i = j ? : 2;
    i = sp->i ? : i;
}

void misc3(void) {
    int i, j;
    i, j;
    switch (i) {
        case 1: ;
        case 2: break;
        default: ;
    }
    switch (i) {
        case 1: ;
        case 2: break;
        default: break;
    }
    switch (i) {
        case -1: ;
        case 1: ;
        case 2: break;
    }
    switch (i) {
        case 1: break;
        case 2: ;
    }
    switch (i) {
        case 1: ;
        case 2: ;
    }
    int x = i + j;
    int x1 = i + j, x2, x3 = i;
    ({ ; });
    i = sizeof(j);

    struct someStruct s, *sp;
    sp = &s;
    s.i = j;
    sp->i = j;
    j = s.i;
    j = sp->i;

    i = i & j;
    i = i | j;
    i = i ^ j;

    if ((sp->i & j) && (sp->i & j)) ;
    if (i && i && i) ;
    if (i || i || i) ;
}

void funptr(void) {
    int i, j;
    int (*intFun) (int, int);
    i = intFun(i, j);

    pfunvv();
}

void aggInit(void) {
    int x;
    struct someStruct ss[] = {{1, 2}, {3, 4}};
    static struct someStruct sssc[] = {{1, 2}, {3, 4}};
    struct someStruct sInit1 = {
        .i = x + x,
        .j = x - x
    };
    struct someStruct sInit2 = {};
}

void offsetof_test(void) {
    int i, j;
    i = __builtin_offsetof(struct someStruct, j);
}

void vla(void) {
    int i;
    char str1[1 + 2 + 3 + 4];
    char str2[i + 2 + 3 + 4 + 5];

    char buf[80 * getInt()], *ptr = buf;
    char matrix[getInt()][2][getInt()][2], ****ptr2 = matrix;
}

void magicvars(void) {
    const char *pf = __PRETTY_FUNCTION__;
    const char *strfunc = __func__;
    ;
}

void fret(void) {
    return;
}

int freti(int i) {
    return i;
}

void unreachable_end(void) {
    while(1) {
        ;
    }
}

void f_va(const char *fmt, ...) {
    __builtin_va_list args;
    ;
    __builtin_va_start(args,fmt);
    ;
    __builtin_va_end(args);
    ;
}

extern int fmac (void);
#define MAC int fmac (void) { return 5; }
MAC

int global_with_init = 0 + 1;

int extern_local() {
  // The variable declared here has an initializer, but it's not one that gets
  // control flow in this function.
  extern int global_with_init;
  return global_with_init;
}

int assign_designated_init(struct someStruct *sp) {
  *sp = (struct someStruct) {
    .i = 1,
    .j = 2,
  };
}

static int global_int;
void *builtin_addressof_test() {
	int *p = __builtin_addressof(global_int);
	int *p1 = __builtin_addressof(global_int) + 1;
	p1 = __builtin_addressof(global_int) + 1;
	return __builtin_addressof(global_int);
}
