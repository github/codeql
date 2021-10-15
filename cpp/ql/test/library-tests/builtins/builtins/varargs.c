
void f(int args, ...)
{
    __builtin_va_list ap;
    int i, j;

    __builtin_va_start(ap, args);
    for (i = 0; i < args; i++) {
        j = __builtin_va_arg(ap, int);
    }
    __builtin_va_end(ap);
}

