typedef __builtin_va_list va_list;
typedef struct {} FILE;

extern FILE * stdin;
extern FILE * stdout;
extern FILE * stderr;

#define va_start(args, fmt) __builtin_va_start(args,fmt)
#define va_end(args) __builtin_va_end(args);

int vfprintf (FILE *, const char *, va_list);

int a = 1;
int b;
int *c;

int my_printf(const char * fmt, ...)
{
    va_list vl;
    int ret;
    va_start(vl, fmt);
    ret = vfprintf(stdout, fmt, vl);
    ret = vfprintf(stderr, fmt, vl);
    va_end(vl);
    return ret;
}

int f1()
{
    my_printf("%d\n", a + 2);
    my_printf("%d\n", b + 2); // BAD
    return 0;
}

void f2() {
    my_printf("%d\n", b); // GOOD
}

int main()
{
    unsigned size = sizeof(*c); // GOOD
    my_printf("%d\n", b); // BAD
    b = f1();
    f2();
    return 0;
}
