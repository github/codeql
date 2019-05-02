
typedef enum {
	MYONETHOUSAND = 1000
} myenum;

typedef int MYINT;

void f(char *s, int i, unsigned char *us, const char *cs, signed char *ss, char c, MYINT mi, unsigned long long ull) {
    const char cc = 'x';

    printf("%s: %d\n", s, i);      // ok
    printf("%s: %f\n", s, i);      // not ok (int -> float)
    printf("%s", us);              // ok
    printf("%s", cs);              // ok
    printf("%s", ss);              // ok

    printf("%p", cs);              // ok
    printf("%p", i);               // not ok (int -> void *)
    printf("%p", &f);              // ok

    printf("%*s", i, cs);          // ok
    printf("%*s", mi, cs);         // ok
    printf("%*s", c, cs);          // ok
    printf("%*s", cc, cs);         // ok
    printf("%*s", i, i);           // not ok (int -> char *)
    printf("%d %% %*s", i, i, cs); // ok
    printf("%*s", cs, cs);         // not ok (the width argument should be integer)

    printf("%c", 10);              // ok
    printf("%c", 1000);            // not ok [NOT DETECTED]
    printf("%wc", 10);             // ok
    printf("%wc", 1000);           // ok
    printf("%u", -1);              // not ok [NOT DETECTED]
    printf("%u", 10);              // ok
    printf("%u", 1000);            // ok

    printf("%i", MYONETHOUSAND);     // ok
    printf("%s", MYONETHOUSAND);     // not ok (enum -> char *)
    printf("%c", MYONETHOUSAND);     // not ok (enum -> char) [NOT DETECTED]

    printf("%i", mi);                // ok
    printf("%u", mi);                // not ok (int -> unsigned int) [NOT DETECTED]

    printf("%d", ull);               // not ok (unsigned long long -> int)
    printf("%u", ull);               // not ok (unsigned long long -> unsigned int)
    printf("%x", ull);               // not ok (unsigned long long -> unsigned int)
    printf("%Lx", ull);              // ok
    printf("%llx", ull);             // ok
}

typedef size_t SIZE_T;

void g()
{
    unsigned long ul;
    size_t st;
    SIZE_T ST;
    const size_t c_st = sizeof(st);
    const SIZE_T C_ST = sizeof(st);
    ssize_t sst;

    printf("%zu", ul); // ok (dubious, e.g. on 64-bit Windows `long` is 4 bytes but `size_t` is 8)
    printf("%zu", st); // ok
    printf("%zu", ST); // ok
    printf("%zu", c_st); // ok
    printf("%zu", C_ST); // ok
    printf("%zu", sizeof(ul)); // ok
    printf("%zu", sst); // not ok [NOT DETECTED]

    printf("%zd", ul); // not ok [NOT DETECTED]
    printf("%zd", st); // not ok [NOT DETECTED]
    printf("%zd", ST); // not ok [NOT DETECTED]
    printf("%zd", c_st); // not ok [NOT DETECTED]
    printf("%zd", C_ST); // not ok [NOT DETECTED]
    printf("%zd", sizeof(ul)); // not ok [NOT DETECTED]
    printf("%zd", sst); // ok
    {
        char *ptr_a, *ptr_b;
        char buf[100];

        printf("%tu", ptr_a - ptr_b); // ok
        printf("%td", ptr_a - ptr_b); // ok
        printf("%zu", ptr_a - ptr_b); // ok (dubious)
        printf("%zd", ptr_a - ptr_b); // ok (dubious)
    }
}

void h(int i, struct some_type *j, int k)
{
	// %R is a made-up format symbol, to simulate something obscure that we don't
	// recognize.  We should not report a problem if we're unable to understand what's
	// going on.
	printf("%i %R %i", i, j, k); // GOOD (as far as we can tell)
}

typedef long ptrdiff_t;

void fun1(unsigned char* a, unsigned char* b) {
  ptrdiff_t pdt;

  printf("%td\n", pdt); // GOOD
  printf("%td\n", a-b); // GOOD
}

typedef wchar_t WCHAR_T; // WCHAR_T -> wchar_t -> int
typedef int MYCHAR; // MYCHAR -> int (notably not via the wchar_t typedef)

void fun2() {
  wchar_t *myString1;
  WCHAR_T *myString2;
  int *myString3;
  MYCHAR *myString4;

  printf("%S", myString1); // GOOD
  printf("%S", myString2); // GOOD
  printf("%S", myString3); // GOOD
  printf("%S", myString4); // GOOD
}

typedef void *VOIDPTR;
typedef int (*FUNPTR)(int);

void fun3(void *p1, VOIDPTR p2, FUNPTR p3, char *p4)
{
  printf("%p\n", p1); // GOOD
  printf("%p\n", p2); // GOOD
  printf("%p\n", p3); // GOOD
  printf("%p\n", p4); // GOOD
  printf("%p\n", p4 + 1); // GOOD
  printf("%p\n", 0); // GOOD [FALSE POSITIVE]
}

typedef unsigned int wint_t;

void test_chars(char c, wchar_t wc, wint_t wt)
{
  printf("%c", c); // GOOD
  printf("%c", wc); // BAD [NOT DETECTED]
  printf("%c", wt); // BAD [NOT DETECTED]
  printf("%C", c); // BAD [NOT DETECTED]
  printf("%C", wc); // GOOD (converts to wint_t)
  printf("%C", wt); // GOOD
  wprintf(L"%c", c); // GOOD
  wprintf(L"%c", wc); // BAD [NOT DETECTED]
  wprintf(L"%c", wt); // BAD [NOT DETECTED]
  wprintf(L"%C", c); // BAD [NOT DETECTED]
  wprintf(L"%C", wc); // GOOD (converts to wint_t)
  wprintf(L"%C", wt); // GOOD
}

void test_ws(char *c, wchar_t *wc)
{
  wprintf(L"%s", c); // GOOD
  wprintf(L"%s", wc); // BAD
  wprintf(L"%S", c); // BAD
  wprintf(L"%S", wc); // GOOD
}

void fun4()
{
  int i;
  unsigned int ui;
  long l;
  unsigned long ul;
  long long ll;
  unsigned long long ull;

  printf("%qi\n", i); // BAD
  printf("%qu\n", ui); // BAD
  printf("%qi\n", l); // GOOD
  printf("%qu\n", ul); // GOOD
  printf("%qi\n", ll); // GOOD
  printf("%qu\n", ull); // GOOD
}
