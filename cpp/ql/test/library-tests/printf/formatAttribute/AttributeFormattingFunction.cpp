
typedef void *va_list;

int myPrintf(const char *format, ...) __attribute__((format(printf, 1, 2)));
int mySprintf(char *buffer, const char *format, ...) __attribute__((format(__printf__, 2, 3)));
int myVprintf(const char *format, va_list arg) __attribute__((format(printf, 1, 0)));
