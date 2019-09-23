typedef unsigned long size_t;
void *memset(void *s, int c, size_t n);
void *__builtin_memset(void *s, int c, size_t n);
typedef int errno_t;
typedef unsigned int rsize_t;
errno_t memset_s(void *dest, rsize_t destsz, int ch, rsize_t count);
char *strcpy(char *dest, const char *src);

extern void use_pw(char *pw);

#define PW_SIZE 32

int func1(void) {
	char pw1[PW_SIZE];
	strcpy(pw1, "Password");
	use_pw(pw1);
	memset(pw1, 0, PW_SIZE); // BAD
	return 0;
}

int func1a(void) {
	char pw1a[PW_SIZE];
	strcpy(pw1a, "Password");
	use_pw(pw1a);
	__builtin_memset(pw1a, 0, PW_SIZE); // BAD
	return 0;
}

char *func1b(void) {
	char pw1b[PW_SIZE];
	strcpy(pw1b, "Password");
	use_pw(pw1b);
	memset(pw1b, 0, PW_SIZE); // GOOD
	pw1b[0] = pw1b[3] = 'a';
	return 0;
}

int func1c(char pw1c[PW_SIZE]) {
	strcpy(pw1c, "Password");
	use_pw(pw1c);
	memset(pw1c, 0, PW_SIZE); // GOOD
	return 0;
}

char *func2(void) {
	char pw2[PW_SIZE];
	strcpy(pw2, "Password");
	use_pw(pw2);
	memset(pw2, 1, PW_SIZE); // GOOD
	return pw2;
}

int func3(void) {
	char pw3[PW_SIZE];
	strcpy(pw3, "Password");
	use_pw(pw3);
	memset(pw3, 4, PW_SIZE); // GOOD
	return pw3[2];
}
