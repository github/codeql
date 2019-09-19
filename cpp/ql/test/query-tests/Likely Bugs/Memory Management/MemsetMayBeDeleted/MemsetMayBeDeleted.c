typedef unsigned long size_t;
void *memset(void *s, int c, size_t n);
typedef int errno_t;
typedef unsigned int rsize_t;
errno_t memset_s(void *dest, rsize_t destsz, int ch, rsize_t count);
char *strcpy(char *dest, const char *src);

extern void use_pw(char *pw);

#define PW_SIZE 32

int func1(void) {
	char pw[PW_SIZE];
	strcpy(pw, "Password");
	use_pw(pw);
	memset(pw, 0, PW_SIZE); // BAD
	return 0;
}

char *func2(void) {
	char pw[PW_SIZE];
	strcpy(pw, "Password");
	use_pw(pw);
	memset(pw, 1, PW_SIZE); // GOOD
	return pw;
}

int func3(void) {
	char pw[PW_SIZE];
	strcpy(pw, "Password");
	use_pw(pw);
	memset(pw, 4, PW_SIZE); // GOOD
	return pw[2];
}
