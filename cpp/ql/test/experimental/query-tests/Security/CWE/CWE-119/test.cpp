
typedef unsigned long long size_t;
int sprintf(char *s, const char *format, ...);
int snprintf(char *s, size_t n, const char *format, ...);
int scanf(const char *format, ...);
int sscanf(const char *s, const char *format, ...);
char *malloc(size_t size);
char *strncpy(char *dst, const char *src, size_t n);

typedef struct
{
	char *string;
	int size;
} string_t;

string_t *mk_string_t(int size) {
    string_t *str = (string_t *) malloc(sizeof(string_t));
    str->size = size;
    str->string = malloc(size);
    return str;
}

void test1(int size, char *buf) {
    string_t *str = mk_string_t(size);

    strncpy(str->string, buf, str->size);
}

void strncpy_wrapper(string_t *str, char *buf) {
    strncpy(str->string, buf, str->size);
}

void test2(int size, char *buf) {
    string_t *str = mk_string_t(size);
    strncpy_wrapper(str, buf);
}

