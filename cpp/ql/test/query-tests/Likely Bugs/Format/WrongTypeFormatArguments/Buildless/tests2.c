#define va_list void*
#define va_start(x, y) x = 0;
#define va_arg(x, y) ((y)x)
#define va_end(x)

int vprintf(const char * format, va_list args);

int my_printf(void * p,const char * format, ...) {
    va_list args;
    va_start(args, format);
    int result = vprintf(format, args);
    va_end(args);
    return result;
}
