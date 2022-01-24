typedef unsigned long long size_t;
void *memset(void *s, int c, unsigned long n);
void *__builtin_memset(void *s, int c, unsigned long n);
typedef int errno_t;
typedef unsigned int rsize_t;
errno_t memset_s(void *dest, rsize_t destsz, int ch, rsize_t count);
char *strcpy(char *dest, const char *src);

extern void use_pw(char *pw);

#define PW_SIZE 32

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): deleted
int func1(void) { 
	char pw1[PW_SIZE];
	use_pw(pw1);
	memset(pw1, 0, PW_SIZE); // BAD [NOT DETECTED]
	return 0;
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): not deleted
int func1a(void) {  
	char pw1a[PW_SIZE];
	use_pw(pw1a);
	__builtin_memset(pw1a, 0, PW_SIZE); // BAD [NOT DETECTED]
	return 0;
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): deleted
char *func1b(void) {  
	char pw1b[PW_SIZE];
	use_pw(pw1b);
	memset(pw1b, 0, PW_SIZE); // BAD [NOT DETECTED]
	pw1b[0] = pw1b[3] = 'a';
	return 0;
}

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.14 (WINE): not deleted
int func1c(char pw1c[PW_SIZE]) {  
	use_pw(pw1c);
	memset(pw1c, 0, PW_SIZE); // GOOD
	return 0;
}

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.14 (WINE): not deleted
char pw1d[PW_SIZE];
int func1d() {  
	use_pw(pw1d);
	memset(pw1d, 0, PW_SIZE); // GOOD
	return 0;
}
// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): deleted
char *func2(void) {  
	char pw2[PW_SIZE];
	use_pw(pw2);
	memset(pw2, 1, PW_SIZE); // BAD [NOT DETECTED]
	return pw2;
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): partially deleted
int func3(void) { 
	char pw3[PW_SIZE];
	use_pw(pw3);
	memset(pw3, 4, PW_SIZE); // BAD [NOT DETECTED]
	return pw3[2];
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): not deleted
int func4(void) { 
	char pw1a[PW_SIZE];
	use_pw(pw1a);
	__builtin_memset(pw1a + 3, 0, PW_SIZE - 3); // BAD [NOT DETECTED]
	return 0;
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): not deleted
int func6(void) { 
	char pw1a[PW_SIZE];
	use_pw(pw1a);
	__builtin_memset(&pw1a[3], 0, PW_SIZE - 3); // BAD [NOT DETECTED]
	return pw1a[2];
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): not deleted
int func5(void) { 
	char pw1a[PW_SIZE];
	use_pw(pw1a);
	__builtin_memset(pw1a + 3, 0, PW_SIZE - 4); // GOOD
	return pw1a[4];
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): not deleted
int func7(void) { 
	char pw1a[PW_SIZE];
	use_pw(pw1a);
	__builtin_memset(&pw1a[3], 0, PW_SIZE - 5); // BAD [NOT DETECTED]
	return 0;
}

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.14 (WINE): not deleted
int func8(void) { 
	char pw1a[PW_SIZE];
	use_pw(pw1a);
	__builtin_memset(pw1a + pw1a[3], 0, PW_SIZE - 4); // GOOD
	return pw1a[4];
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.14 (WINE): deleted
char *func9(void) {
	char pw1[PW_SIZE];
	use_pw(pw1);
	memset(pw1, 0, PW_SIZE); // BAD [NOT DETECTED]
	return 0;
}
