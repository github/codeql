#ifndef STD_STUBS_H
#define STD_STUBS_H

int printf(const char *format, ...);

unsigned long strlen(const char *s) {
    return 0;
}

void* memset(void *s, int c, unsigned long n) {
    return 0;
}

#endif /* STD_STUBS_H */