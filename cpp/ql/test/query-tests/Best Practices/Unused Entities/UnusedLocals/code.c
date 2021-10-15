
void f1(unsigned int x) {
    unsigned int y = x + 1;
    unsigned int z = x + 2; // BAD: 'z' is unused [NOT DETECTED - due to ASM code]

    asm volatile("decl %[cnt];" : [cnt] "+r" (y));
}

void f2(unsigned int x) {
    unsigned int y = x + 1; // BAD: 'y' is unused
    unsigned int z = x + 2; // BAD: 'z' is unused
}

#define my_int int
#define COMPLEX_MACRO do { int z = 3; } while(0)

void f3() {
  int x = 1; // BAD: 'x' is unused
  my_int y = 2; // BAD: 'y' is unused
  COMPLEX_MACRO; // GOOD: unused locals declared in macros are considered OK. 
}

void write_ptr(int *ptr) {
	ptr = 1;
}

#define ZERO(x) x = 0

int f4() {
	int a, b, c, d, e, f, g, h, i, j, k, l, m, n; // BAD: 'n' is unused

	a = b;
	c++;
	if (d) {
		int *ptr = &e;
		ptr = &f;
	}
	write_ptr(&g);
	h = (i) ? (j) : (k);
	ZERO(l);
	
	return m;
}

void f5() {
	int x; // BAD: 'x' is unused
	
	{
		int x;
		
		{
			int x; // BAD: 'x' is unused
		}
		
		x = 12;
	}
}

typedef unsigned int size_t;
void *memset(void *ptr, int value, size_t num);

void f6() {
	int arr1[10];
	int arr2[10];
	int arr3[10];
	int arr4[10];
	int arr5[10]; // BAD: 'arr5' is unused
	int *ptr;
	int x;

	x = 6;
	arr1[5] = arr2[x];
	ptr = arr3;
	memset(arr4, 0, sizeof(arr4));
}
