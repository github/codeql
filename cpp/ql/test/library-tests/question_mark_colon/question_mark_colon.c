
char *f(void);

void g(void) {
    char *s;
    s = f() ? : "str"; // the 'then' part is implictly the value of the condition (GNU C extension)
    s = f() ? "a" : "b";
}
