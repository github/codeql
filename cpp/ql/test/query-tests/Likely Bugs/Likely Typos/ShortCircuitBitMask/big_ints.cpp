static void bad(int x) {
  x && 2;
  x && 4;
  x && 16;
  x && 256;
  x && 0x10000;
  x && 0x80000000;
  x && 0x100000000LL;
  x && 0x800000000LL;
  x && 0x10000000000LL;
  x && 0x123456789ABLL;
}

static void good(int x) {
  x & 0; x & 1;
  x & 2; x & 3;
  x & 4; x & 9;
  x & 16; x & 99;
  x & 256;
  x & 0x10000;
  x & 0x80000000;
  x & 0x100000000LL;
  x & 0x800000000LL;
  x & 0x10000000000LL;
}



template<int i>
void templateFunc() {
	(i & (i - 1)) && true;
	4 && true;
}

void templateTest() {
  templateFunc<1>();
  templateFunc<3>();
  templateFunc<5>();
  templateFunc<7>();
}


// Macros
struct myStruct {
	int a, b, c;
};

#define OFFSETOF(t, m) &(((t *)0)->m)
#define CHECK_OFFSETOF(t, m) (0 && OFFSETOF(t, m))
	// ensure that we can compute the offset of `t.m`, without actually doing anything.

void testMacro()
{
	CHECK_OFFSETOF(myStruct, a); // GOOD
	CHECK_OFFSETOF(myStruct, b); // GOOD
	CHECK_OFFSETOF(myStruct, c); // GOOD
}






// Macros (more)

#define MYFLAG (0x80)

unsigned int calc1 = 123 & MYFLAG; // OK
unsigned int calc2 = 123 && MYFLAG; // BAD
