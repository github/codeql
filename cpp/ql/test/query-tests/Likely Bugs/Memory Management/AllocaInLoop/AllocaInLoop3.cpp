// semmle-extractor-options: --clang

#ifdef _MSC_VER
#define restrict __restrict
#else
#define restrict __restrict__
#endif

int sprintf(char *restrict s, const char *restrict format, ...);
char * strdup(const char *restrict s);

void *__builtin_alloca(unsigned long sz);
#define alloca __builtin_alloca

// case 1: a GNU c/c++ lambda with an alloca in it
char *foo(int count) {
	char *buf = ({
			char *b = (char *)alloca(32); // GOOD
			sprintf(b, "Value is %d\n", count);
			b;
		});
	return strdup(buf);
}

// case 1: a GNU expression statement with an alloca in it
//         nested inside a do-while(0)
char *bar(int count) {
	char *buf;
	do {
		buf = ({
				char *b = (char *)alloca(32); // GOOD
				sprintf(b, "Value is %d\n", count);
				b;
			});
	} while (0);
	return strdup(buf);
}

// case 2: a GNU expression statement with an alloca in it
//         nested inside an unbounded loop
char *baz(int count) {
	char *buf;
	do {
		buf = ({
				char *b = (char *)alloca(32); // BAD
				sprintf(b, "Value is %d\n", count);
				b;
			});
	} while (count++);
	return strdup(buf);
}
