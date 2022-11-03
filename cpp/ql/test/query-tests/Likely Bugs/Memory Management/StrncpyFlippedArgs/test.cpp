
typedef unsigned int size_t;
typedef unsigned int errno_t;

char *strncpy(char *__restrict destination, const char *__restrict source, size_t num);
wchar_t *wcsncpy(wchar_t *__restrict destination, const wchar_t *__restrict source, size_t num);
errno_t strcpy_s(char *strDestination, size_t numberOfElements, const char *strSource);

size_t strlen(const char *str);
size_t wcslen(const wchar_t *str);

void test1()
{
	char buf1[10];
	char buf2[20];
	const char *str = "01234567890123456789";

	strncpy(buf1, str, sizeof(buf1));
	strncpy(buf1, str, strlen(str)); // BAD
	strncpy(buf1, str, strlen(str) + 1); // BAD
	strncpy(buf1, buf2, sizeof(buf2)); // BAD
}

void test2()
{
	wchar_t buf1[10];
	wchar_t buf2[20];
	const wchar_t *str = L"01234567890123456789";

	wcsncpy(buf1, str, sizeof(buf1)); // (bad, but not a strncpyflippedargs bug)
	wcsncpy(buf1, str, sizeof(buf1) / sizeof(wchar_t));
	wcsncpy(buf1, str, wcslen(str)); // BAD
	wcsncpy(buf1, str, wcslen(str) + 1); // BAD
	wcsncpy(buf1, buf2, sizeof(buf2)); // BAD
	wcsncpy(buf1, buf2, sizeof(buf2) / sizeof(wchar_t)); // BAD [NOT DETECTED]
}

void test3()
{
	char buf1[10];
	char buf2[20];
	const char *str = "01234567890123456789";

	strcpy_s(buf1, sizeof(buf1), str);
	strcpy_s(buf1, strlen(str), str); // BAD
	strcpy_s(buf1, strlen(str) + 1, str); // BAD
	strcpy_s(buf1, sizeof(buf2), buf2); // BAD
}

struct S {
  char x[10];
  char* y;
  char z[20];
};

void test4(S *a, S *b)
{
  strncpy(a->x, b->x, sizeof(a->x)); // GOOD
  strncpy(a->x, b->x, sizeof(b->x)); // GOOD (sizes match, so it's ok)
  strncpy(a->x, b->z, sizeof(b->z)); // BAD

  strncpy(a->y, b->y, strlen(a->y) + 1); // GOOD
  strncpy(a->y, b->y, strlen(b->y) + 1); // BAD
}

void test5(char *buf)
{
	strncpy(buf, buf, strlen(buf)); // GOOD (though an illegal use of strncpy)
}

struct T {
  S *s;
};

void test6(T *a, T *b)
{
  strncpy(a->s->x, b->s->x, sizeof(a->s->x)); // GOOD
  strncpy(a->s->x, b->s->x, sizeof(b->s->x)); // GOOD (sizes match, so it's ok)
  strncpy(a->s->x, b->s->x, sizeof(b->s->z)); // BAD

  strncpy(a->s->y, b->s->y, strlen(a->s->y) + 1); // GOOD
  strncpy(a->s->y, b->s->y, strlen(b->s->y) + 1); // BAD
}

void test7(char* x, char* y) {
  // We cannot tell if this call is good or bad. But there's a good chance
  // that it will be a false positive if we report it.
  strncpy(x, y, 32);
}

void test8(char x[], char y[]) {
  // We cannot tell if this call is good or bad. But there's a good chance
  // that it will be a false positive if we report it.
  strncpy(x, y, 32);
}
