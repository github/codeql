//semmle-extractor-options: --edg --target --edg linux_x86_64

// Semmle test cases for rule CWE-119.

// library types, functions etc
typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);
void *memcpy(void *s1, const void *s2, size_t n);
void *memmove(void *s1, const void *s2, size_t n);
void *memset(void *s, int c, size_t n);
int memcmp(const void *s1, const void *s2, size_t n);
int printf(const char *format, ...);
size_t strlen(const char *s);
char *strncpy(char *s1, const char *s2, size_t n);

void test1()
{
	char smallbuffer[10];
	char bigbuffer[20];

	memcpy(bigbuffer, smallbuffer, sizeof(smallbuffer)); // GOOD
	memcpy(bigbuffer, smallbuffer, sizeof(bigbuffer)); // BAD: over-read
	memcpy(smallbuffer, bigbuffer, sizeof(smallbuffer)); // GOOD
	memcpy(smallbuffer, bigbuffer, sizeof(bigbuffer)); // BAD: over-write
}

void test2()
{
	char *smallbuffer = (char *)malloc(sizeof(char) * 10);
	char *bigbuffer = (char *)malloc(sizeof(char) * 20);

	memcpy(bigbuffer, smallbuffer, sizeof(smallbuffer)); // GOOD
	memcpy(bigbuffer, smallbuffer, sizeof(bigbuffer)); // BAD: over-read [NOT DETECTED]
	memcpy(smallbuffer, bigbuffer, sizeof(smallbuffer)); // GOOD
	memcpy(smallbuffer, bigbuffer, sizeof(bigbuffer)); // BAD: over-write [NOT DETECTED]

	free(bigbuffer);
	free(smallbuffer);
}

void test3()
{
	char *smallbuffer, *bigbuffer;

	smallbuffer = new char[10];
	bigbuffer = new char[20];

	memcpy(bigbuffer, smallbuffer, sizeof(smallbuffer)); // GOOD
	memcpy(bigbuffer, smallbuffer, sizeof(bigbuffer)); // BAD: over-read [NOT DETECTED]
	memcpy(smallbuffer, bigbuffer, sizeof(smallbuffer)); // GOOD
	memcpy(smallbuffer, bigbuffer, sizeof(bigbuffer)); // BAD: over-write [NOT DETECTED]

	delete [] bigbuffer;
	delete [] smallbuffer;
}

void test4(int unbounded)
{
	int bounded = 100;
	char buffer1[100], buffer2[100];

	memmove(buffer1, buffer2, bounded); // GOOD
	memmove(buffer1, buffer2, unbounded); // BAD: may over-write [NOT DETECTED]
}

void test5(int unbounded)
{
	int a, b, c, d, e;
	char buffer[100];

	buffer[unbounded] = 'x'; // BAD: may under- or over-write [NOT DETECTED]
	buffer[0] = buffer[unbounded]; // BAD: may under- or over-read [NOT DETECTED]

	a = unbounded;
	buffer[a] = 'x'; // BAD: may under- or over-write [NOT DETECTED]
	buffer[0] = buffer[a]; // BAD: may under- or over-read [NOT DETECTED]

	b = unbounded;
	if (b < 0) {b = 0;}
	buffer[b] = 'x'; // BAD: may over-write [NOT DETECTED]
	buffer[0] = buffer[b]; // BAD: may over-read [NOT DETECTED]

	c = unbounded;
	if (c > 99) {c = 99;}
	buffer[c] = 'x'; // BAD: may under-write [NOT DETECTED]
	buffer[0] = buffer[c]; // BAD: may under-read [NOT DETECTED]

	d = unbounded;
	if (d < 0) {d = 0;}
	if (d > 99) {d = 99;}
	buffer[d] = 'x'; // GOOD
	buffer[0] = buffer[d]; // GOOD

	e = unbounded;
	e = 50;
	buffer[e] = 'x'; // GOOD
	buffer[0] = buffer[e]; // GOOD
}

void test6(bool cond)
{
	int a, b, c, d, e, f, g, h, i, j, k;
	char buffer[100];
	char ch;

	a = -1;
	buffer[a] = 'x'; // BAD: under-write [NOT DETECTED]
	ch = buffer[a]; // BAD: under-read [NOT DETECTED]

	b = 0;
	buffer[b] = 'x'; // GOOD
	ch = buffer[b]; // GOOD

	c = 100;
	buffer[c] = 'x'; // BAD: over-write [NOT DETECTED]
	ch = buffer[c]; // BAD: over-read [NOT DETECTED]

	d = 0;
	d = 1000;
	buffer[d] = 'x'; // BAD: over-write [NOT DETECTED]
	ch = buffer[d]; // BAD: over-read [NOT DETECTED]

	e = 1000;
	e = 0;
	buffer[e] = 'x'; // GOOD
	ch = buffer[e]; // GOOD

	f = 0;
	if (cond) {f = 1000;}
	buffer[f] = 'x'; // BAD: may over-write [NOT DETECTED]
	ch = buffer[f]; // BAD: may over-read [NOT DETECTED]

	g = 1000;
	if (cond) {g = 0;}
	buffer[g] = 'x'; // BAD: may over-write [NOT DETECTED]
	ch = buffer[g]; // BAD: may over-read [NOT DETECTED]

	h = 1000;
	if (cond)
	{
		h = 10;
	} else {
		h = 20;
	}
	buffer[h] = 'x'; // GOOD
	ch = buffer[h]; // GOOD

	for (i = 0; i < 100; i++)
	{
		buffer[i] = 'x'; // GOOD
		ch = buffer[i]; // GOOD
	}

	for (j = -1; j < 100; j++)
	{
		buffer[j] = 'x'; // BAD: under-write [NOT DETECTED]
		ch = buffer[j]; // BAD: under-read [NOT DETECTED]
	}

	for (k = 0; k <= 100; k++)
	{
		buffer[k] = 'x'; // BAD: over-write
		ch = buffer[k]; // BAD: over-read
	}
}

void test7()
{
	char *names[] = {"tom", "dick", "harry"};

	printf("name: %s\n", names[-1]); // BAD: under-read
	printf("name: %s\n", names[0]); // GOOD
	printf("name: %s\n", names[1]); // GOOD
	printf("name: %s\n", names[2]); // GOOD
	printf("name: %s\n", names[3]); // BAD: over-read
}

void test8(int unbounded)
{
	char buffer[128];
	int v1 = 128;
	int v2 = 256;
	int i;

	for (i = 0; i < v1; i++)
	{
		buffer[i] = 0; // GOOD
	}

	for (i = 0; i < v2; i++)
	{
		buffer[i] = 0; // BAD: over-write [NOT DETECTED]
	}

	for (i = 0; i < unbounded; i++)
	{
		buffer[i] = 0; // BAD: may over-write [NOT DETECTED]
	}

	unbounded = 128;
	for (i = 0; i < unbounded; i++)
	{
		buffer[i] = 0; // GOOD
	}
}

char global_array_5[] = {1, 2, 3, 4, 5};
char global_array_6[] = {1, 2, 3, 4, 5, 6};

void test9(int param)
{
	{
		char buffer1[32];
		char *buffer2 = new char[32];
		void *buffer3;
		void *buffer4;
		buffer3 = malloc(32);
		buffer4 = buffer3;

		memset(buffer1, 0, 32); // GOOD
		memset(buffer1, 0, 33); // BAD: overrun write of buffer1
		memset(buffer2, 0, 32); // GOOD
		memset(buffer2, 0, 33); // BAD: overrun write of buffer2
		memset(buffer3, 0, 32); // GOOD
		memset(buffer3, 0, 33); // BAD: overrun write of buffer3
		memset(buffer4, 0, 32); // GOOD
		memset(buffer4, 0, 33); // BAD: overrun write of buffer4 (buffer3)

		memcmp(buffer1, buffer2, 32); // GOOD
		memcmp(buffer1, buffer2, 33); // BAD: overrun read of buffer1, buffer2
	}

	{
		char *str1 = "1234567";
		char *str2 = "abcdefgh";

		strncpy(str1, str2, strlen(str1) + 1); // GOOD
		strncpy(str1, str2, strlen(str2) + 1); // BAD: overrun write of str1
		strncpy(str2, str1, strlen(str1) + 1); // DUBIOUS (detected)
		strncpy(str2, str1, strlen(str2) + 1); // BAD: overrun read of str1 [NOT REPORTED]
	}

	memmove(global_array_6, global_array_5, 6); // BAD: overrun read of global_array_5
	memmove(global_array_5, global_array_6, 6); // BAD: overrun write of global_array_5

	if (param > 0)
	{
		void *buffer = malloc(param);

		memset(buffer, 0xFF, param);     // GOOD
		memset(buffer, 0xFF, param * 2); // BAD: overrun write of buffer [NOT REPORTED]
	}
}

wchar_t *wmemset(wchar_t *s, wchar_t c, size_t n);

void test10()
{
	wchar_t buffer1[32];
	char buffer2[32];


	wmemset(buffer1, 0, 32); // GOOD
	wmemset(buffer1, 0, 33); // BAD: overrun write of buffer1
	wmemset((wchar_t *)buffer2, 0, 32); // BAD: overrun write of buffer2
}

void test11()
{
	{
		char *string = "Hello, world!";

		memset(string, 0, 14); // GOOD
		memset(string, 0, 15); // BAD: overrun write of string
	}

	{
		char *buffer = new char[128];

		memset(buffer, 0, 128);

		buffer = new char[64];

		memset(buffer, 0, 128); // BAD: overrun write of buffer
	}

	{
		char array[10] = "123";

		memset(array, 0, 10); // GOOD
		memset(array, 0, 11); // BAD: overrun write of array
	}
}

struct myStruct
{
	char buffer[16];
	int field;
};
myStruct myVar;

void test12()
{
	char buf[16];
	char *dbuf;
	dbuf = new char[16];

	memset(&myVar, 0, sizeof(myVar)); // GOOD
	memset(&myVar, 0, sizeof(myVar) + 1); // BAD: overrun write of myVar
	memset(myVar.buffer, 0, 16); // GOOD
	memset(myVar.buffer, 0, 17); // DUBIOUS: overrun write of myVar.buffer, but not out of myVar itself [NOT DETECTED]
	memset(&(myVar.field), 0, sizeof(int)); // GOOD
	memset(&(myVar.field), 0, sizeof(int) * 2); // BAD: overrun write of myVar.field

	memset(buf + 8, 0, 8); // GOOD
	memset(buf + 8, 0, 9); // BAD: overrun write of buf [NOT DETECTED]
	memset(dbuf + 8, 0, 8); // GOOD
	memset(dbuf + 8, 0, 9); // BAD: overrun write of dbuf [NOT DETECTED]

	{
		myStruct *myPtr1 = &myVar;
		myStruct *myPtr2;
		myPtr2 = myPtr1;

		memset(myPtr1, 0, sizeof(myStruct)); // GOOD
		memset(myPtr1, 0, sizeof(myStruct) + 1); // BAD: overrun write of myVar
		memset(myPtr2, 0, sizeof(myStruct)); // GOOD
		memset(myPtr2, 0, sizeof(myStruct) + 1); // BAD: overrun write of myVar
	}

	{
		void *myPtr3 = (void *)(&myVar);

		memset(myPtr3, 0, sizeof(myStruct)); // GOOD
		memset(myPtr3, 0, sizeof(myStruct) + 1); // BAD: overrun write of myVar
	}
}

void test13(char *argArray)
{
	char charArray[10];
	int intArray[10];
	myStruct structArray[10];
	char *ptrArray = charArray;
	char *ptrArrayOffset = charArray + 1;

	charArray[-1] = 1; // BAD: underrun write
	charArray[0] = 1; // GOOD
	charArray[9] = 1; // GOOD
	charArray[10] = 1; // BAD: overrun write
	charArray[5] = charArray[10]; // BAD: overrun read

	intArray[-1] = 1; // BAD: underrun write
	intArray[0] = 1; // GOOD
	intArray[9] = 1; // GOOD
	intArray[10] = 1; // BAD: overrun write
	intArray[5] = intArray[10]; // BAD: overrun read

	structArray[-1].field = 1; // BAD: underrun write
	structArray[0].field = 1; // GOOD
	structArray[9].field = 1; // GOOD
	structArray[10].field = 1; // BAD: overrun write
	structArray[5].field = structArray[10].field; // BAD: overrun read

	charArray[9] = (char)intArray[9]; // GOOD
	charArray[9] = (char)intArray[10]; // BAD: overrun read

	ptrArray[-2] = 1; // BAD: underrun write
	ptrArray[-1] = 1; // BAD: underrun write
	ptrArray[0] = 1; // GOOD
	ptrArray[8] = 1; // GOOD
	ptrArray[9] = 1; // GOOD
	ptrArray[10] = 1; // BAD: overrun write

	ptrArrayOffset[-2] = 1; // BAD: underrun write [NOT DETECTED]
	ptrArrayOffset[-1] = 1; // GOOD (there is room for this)
	ptrArrayOffset[0] = 1; // GOOD
	ptrArrayOffset[8] = 1; // GOOD
	ptrArrayOffset[9] = 1; // BAD: overrun write [NOT DETECTED]
	ptrArrayOffset[10] = 1; // BAD: overrun write [NOT DETECTED]

	argArray[-1] = 1; // BAD: underrun write [NOT DETECTED]
	argArray[0] = 1; // GOOD
	argArray[1] = 1; // GOOD (we can't tell the length of this array)
	argArray[999] = 1; // GOOD (we can't tell the length of this array)

	{
		unsigned short *buffer1 = (unsigned short *)malloc(sizeof(short) * 50);
		unsigned short *buffer2 = (unsigned short *)malloc(101); // 50.5 shorts

		buffer1[0] = 0xFFFF;
		buffer1[49] = 0xFFFF;
		buffer1[50] = 0xFFFF; // BAD: overrun write
		buffer2[0] = 0xFFFF;
		buffer2[49] = 0xFFFF;
		buffer2[50] = 0xFFFF; // BAD: overrun write
	}
}

int strncmp(const char *s1, const char *s2, size_t n);

const char *get_buffer();
void get_line(const char **ptr);

void test14()
{
	const char *buf;

	buf = get_buffer();

	if (buf != 0 && memcmp(buf, "mydata", 6) == 0) // GOOD
	{
		// ...
	}
}

void test15()
{
	const char *ptr = get_buffer();
	int i;

	for (i = 0; ; i++)
	{
		get_line(&ptr);

		if (strncmp(ptr, "token", 5) == 0)
		{
			if (ptr[5] == ' ') // GOOD
			{
				break;
			}
		}
	}
}

typedef struct mystruct16
{
	int data;
	struct mystruct16 *next;
};

void test16()
{
	int arr1[10];
	int *ptr1_1 = &arr1[9]; // GOOD
	int *ptr1_2 = &arr1[10]; // GOOD: valid as long as we don't dereference it
	int *ptr1_3 = &arr1[11]; // BAD: not guaranteed to be valid [NOT DETECTED - considered outside the scope of CWE-119]

	int x = *--ptr1_2; // GOOD

	mystruct16 arr2[10];
	mystruct16 *ptr2_1 = &arr2[9]; // GOOD
	mystruct16 *ptr2_2 = &arr2[10]; // GOOD: valid as long as we don't dereference it
	mystruct16 *ptr2_3 = &arr2[11]; // BAD: not guaranteed to be valid [NOT DETECTED - considered outside the scope of CWE-119]

	(--ptr2_2)->data = 1; // GOOD
}

void test17(long long *longArray)
{
	longArray[-1] = -1; // BAD: underrun write [NOT DETECTED]

	{
		int intArray[5];

		((char *)intArray)[-3] = 0; // BAD: underrun write
	}

	{
		int multi[10][10];

		multi[5][5] = 0; // GOOD

		multi[-5][5] = 0; // BAD: underrun write [INCORRECT MESSAGE]
		multi[5][-5] = 0; // DUBIOUS: underrun write (this one is still within the bounds of the whole array)
		multi[-5][-5] = 0; // BAD: underrun write [INCORRECT MESSAGE]
		multi[0][-5] = 0; // BAD: underrun write [NOT DETECTED]

		multi[15][5] = 0; // BAD: overrun write
		multi[5][15] = 0; // DUBIOUS: overrun write (this one is still within the bounds of the whole array)
		multi[15][15] = 0; // BAD: overrun write
	}
}

char *update(char *ptr);

void test18()
{
	char buffer[128];
	char *p1 = buffer;
	char *p2 = buffer;
	char *p3 = buffer;
	char *p4 = (char *)malloc(128);
	char *p5 = (char *)malloc(128);

	p1[-1] = 0; // BAD: underrun write
	p2[-1] = 0; // BAD: underrun write
	p2++;
	p2[-1] = 0; // GOOD

	p3[-1] = 0; // BAD
	while (*p3 != 0) {
		p3 = update(p3);
	}
	p3[-1] = 0; // GOOD

	p4[-1] = 0; // BAD: underrun write
	p4++;
	p4[-1] = 0; // GOOD

	p5[-1] = 0; // BAD
	while (*p5 != 0) {
		p5 = update(p5);
	}
	p5[-1] = 0; // GOOD
}

void test19(bool b)
{
	char *p1, *p2, *p3;

	p1 = (char *)malloc(10);
	p2 = (char *)malloc(10);
	p3 = (char *)malloc(20);

	// ...

	if (b)
	{
		p1 = (char *)malloc(10);
		p2 = (char *)malloc(20);
		p3 = (char *)malloc(20);
	}

	// ...

	if (b)
	{
		memset(p1, 0, 20); // BAD
		memset(p2, 0, 20); // GOOD
		memset(p3, 0, 20); // GOOD
	}
}

typedef struct {} FILE;
FILE *fileSource;

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);

void test20()
{
	char charBuffer[100];
	int intBuffer[100];
	int num;

	if (fread(charBuffer, sizeof(char), 100, fileSource) > 0) // GOOD
	{
		// ...
	}

	if (fread(charBuffer, sizeof(char), 101, fileSource) > 0) // BAD
	{
		// ...
	}

	if (fread(charBuffer, sizeof(int), 100, fileSource) > 0) // BAD
	{
		// ...
	}

	if (fread(intBuffer, sizeof(int), 100, fileSource) > 0) // GOOD
	{
		// ...
	}

	num = 101;
	if (fread(intBuffer, sizeof(int), num, fileSource) > 0) // BAD [NOT DETECTED]
	{
		// ...
	}
}

void test21(bool cond)
{
	char buffer[100];
	char *ptr;
	int i;

	if (buffer[-1] == 0) { return; } // BAD: accesses buffer[-1]

	ptr = buffer;
	if (cond)
	{
		ptr++;
		if (ptr[-1] == 0) { return; } // GOOD: accesses buffer[0]
	} else {
		if (ptr[-1] == 0) { return; } // BAD: accesses buffer[-1]
	}
	if (ptr[-1] == 0) { return; } // BAD: accesses buffer[-1] or buffer[0] [NOT DETECTED]

	ptr = buffer;
	for (i = 0; i < 2; i++)
	{
		ptr++;
	}
	if (ptr[-1] == 0) { return; } // GOOD: accesses buffer[1]
}

void test22(bool b, const char* source) {
	char buffer[16];
	int k;
	for (k = 0; k <= 100; k++) {
		if(k < 16) {
			buffer[k] = 'x'; // GOOD
		}
	}

	char dest[128];
	int n = b ? 1024 : 132;
	if (n >= 128) {
    return;
  }
  memcpy(dest, source, n); // GOOD
}

int test23() {
	char buffer[100];
	return sizeof(buffer) / sizeof(buffer[101]); // GOOD
}

char* strcpy(char *, const char *);

void test24(char* source) {
	char buffer[100];
	strcpy(buffer, source); // BAD
}

struct my_struct {
	char* home;
};

void test25(char* source) {
	my_struct s;

	s.home = source;

	char buf[100];
	strcpy(buf, s.home); // BAD
}

void test26(bool cond)
{
	char buffer[100];
	char *ptr;
	int i;

	if (buffer[-1] == 0) { return; } // BAD: accesses buffer[-1]

	ptr = buffer;
	if (cond)
	{
		ptr += 1;
		if (ptr[-1] == 0) { return; } // GOOD: accesses buffer[0]
	} else {
		if (ptr[-1] == 0) { return; } // BAD: accesses buffer[-1]
	}
	if (ptr[-1] == 0) { return; } // BAD: accesses buffer[-1] or buffer[0] [NOT DETECTED]

	ptr = buffer;
	for (i = 0; i < 2; i++)
	{
		ptr += 1;
	}
	if (ptr[-1] == 0) { return; } // GOOD: accesses buffer[1]
}

#define IND 100
#define MAX_SIZE 100
void test27(){
	char *src = "";
	char *dest = "abcdefgh";
	int ind = 100;
	char buffer[MAX_SIZE];

	strncpy(dest, src, 8); // GOOD, strncpy will not read past null terminator of source

	if(IND < MAX_SIZE){
		buffer[IND] = 0; // GOOD: out of bounds, but inaccessible code
	}
}

typedef struct _MYSTRUCT {
    unsigned long  a;
    unsigned short b;
    unsigned char  z[ 100 ];
} MYSTRUCT;


const MYSTRUCT _myStruct = { 0 };
typedef const MYSTRUCT& MYSTRUCTREF;

// False positive case due to use of typedefs
int test28(MYSTRUCTREF g)
{
	return memcmp(&g, &_myStruct, sizeof(MYSTRUCT)); // GOOD
}

#define offsetof(s, m) __builtin_offsetof(s, m)

struct HasSomeFields {
	unsigned long a;
	unsigned long b;
	unsigned long c;

	void test29() {
		memset(&a, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, a)); // GOOD
	};

	void test30() {
		memset(&b, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, b)); // GOOD
	};

	void test31() {
		memset(&c, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, c)); // GOOD
	};

	void test32() {
		memset(&c, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, a)); // BAD
	};

	void test33() {
		memset(&c, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, b)); // BAD
	};

	void test34() {
		memset(&b, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, a)); // BAD
	};

	void test35() {
		memset(&b, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, b) - sizeof(unsigned long)); // GOOD
	};
};

void test36() {
	HasSomeFields hsf;
	memset(&hsf.a, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, a)); // GOOD
	memset(&hsf.c, 0, sizeof(HasSomeFields) - offsetof(HasSomeFields, a)); // BAD
}

struct AnonUnionInStruct
{
  union {
    struct {
      unsigned int a_1;
      unsigned int b_1;
      unsigned int c_1;
    };
    struct {
      unsigned int a_2;
      unsigned int b_2;
    };
  };
  unsigned int d;

  void test37() {
    memset(&a_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_1)); // GOOD
    memset(&a_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_1)); // GOOD
    memset(&a_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, c_1)); // GOOD
    memset(&a_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_2)); // GOOD
    memset(&a_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_2)); // GOOD
    memset(&a_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, d)); // GOOD

    memset(&b_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_1)); // BAD
    memset(&b_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_1)); // GOOD
    memset(&b_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, c_1)); // GOOD
    memset(&b_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_2)); // BAD
    memset(&b_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_2)); // GOOD
    memset(&b_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, d)); // GOOD

    memset(&c_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_1)); // BAD
    memset(&c_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_1)); // BAD
    memset(&c_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, c_1)); // GOOD
    memset(&c_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_2)); // BAD
    memset(&c_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_2)); // GOOD
    memset(&c_1, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, d)); // GOOD

    memset(&a_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_1)); // GOOD
    memset(&a_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_1)); // GOOD
    memset(&a_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, c_1)); // GOOD
    memset(&a_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_2)); // GOOD
    memset(&a_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_2)); // GOOD
    memset(&a_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, d)); // GOOD

    memset(&b_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_1)); // BAD
    memset(&b_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_1)); // GOOD
    memset(&b_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, c_1)); // GOOD
    memset(&b_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, a_2)); // BAD
    memset(&b_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, b_2)); // GOOD
    memset(&b_2, 0, sizeof(AnonUnionInStruct) - offsetof(AnonUnionInStruct, d)); // GOOD
  };
};

struct UnionWithoutStruct
{
  union
  {
    unsigned int a;
  };

  unsigned int b;

  void test37() {
    memset(&a, 0, sizeof(UnionWithoutStruct) - offsetof(UnionWithoutStruct, a)); // GOOD
    memset(&a, 0, sizeof(UnionWithoutStruct) - offsetof(UnionWithoutStruct, b)); // GOOD
    memset(&b, 0, sizeof(UnionWithoutStruct) - offsetof(UnionWithoutStruct, a)); // BAD
  };
};

struct ThreeUInts {
  unsigned int a;
  unsigned int b;
  unsigned int c;
};

struct FourUInts {
  ThreeUInts inner;
  unsigned int x;
};

struct S2 {
  FourUInts f;
  unsigned u;
  void test38() {
    memset(&f.inner.a, 0, sizeof(S2) - offsetof(ThreeUInts, a)); // GOOD
    memset(&f.inner.a, 0, sizeof(S2) - offsetof(ThreeUInts, b)); // GOOD
    memset(&f.inner.a, 0, sizeof(S2) - offsetof(ThreeUInts, c)); // GOOD
    memset(&f.inner.a, 0, sizeof(S2) - offsetof(FourUInts, inner)); // GOOD
    memset(&f.inner.a, 0, sizeof(S2) - offsetof(FourUInts, x)); // GOOD
    memset(&f.inner.a, 0, sizeof(S2) - offsetof(S2, f)); // GOOD
    memset(&f.inner.a, 0, sizeof(S2) - offsetof(S2, u)); // GOOD

    memset(&f.inner.b, 0, sizeof(S2) - offsetof(ThreeUInts, a)); // BAD
    memset(&f.inner.b, 0, sizeof(S2) - offsetof(ThreeUInts, b)); // GOOD
    memset(&f.inner.b, 0, sizeof(S2) - offsetof(ThreeUInts, c)); // GOOD
    memset(&f.inner.b, 0, sizeof(S2) - offsetof(FourUInts, inner)); // BAD
    memset(&f.inner.b, 0, sizeof(S2) - offsetof(FourUInts, x)); // GOOD
    memset(&f.inner.b, 0, sizeof(S2) - offsetof(S2, f)); // BAD
    memset(&f.inner.b, 0, sizeof(S2) - offsetof(S2, u)); // GOOD

    memset(&f.inner.c, 0, sizeof(S2) - offsetof(ThreeUInts, a)); // BAD
    memset(&f.inner.c, 0, sizeof(S2) - offsetof(ThreeUInts, b)); // BAD
    memset(&f.inner.c, 0, sizeof(S2) - offsetof(ThreeUInts, c)); // GOOD
    memset(&f.inner.c, 0, sizeof(S2) - offsetof(FourUInts, inner)); // BAD
    memset(&f.inner.c, 0, sizeof(S2) - offsetof(FourUInts, x)); // GOOD
    memset(&f.inner.c, 0, sizeof(S2) - offsetof(S2, f)); // BAD
    memset(&f.inner.c, 0, sizeof(S2) - offsetof(S2, u)); // GOOD

    memset(&f.inner, 0, sizeof(S2) - offsetof(ThreeUInts, a)); // GOOD
    memset(&f.inner, 0, sizeof(S2) - offsetof(ThreeUInts, b)); // GOOD
    memset(&f.inner, 0, sizeof(S2) - offsetof(ThreeUInts, c)); // GOOD
    memset(&f.inner, 0, sizeof(S2) - offsetof(FourUInts, inner)); // GOOD
    memset(&f.inner, 0, sizeof(S2) - offsetof(FourUInts, x)); // GOOD
    memset(&f.inner, 0, sizeof(S2) - offsetof(S2, f)); // GOOD
    memset(&f.inner, 0, sizeof(S2) - offsetof(S2, u)); // GOOD

    memset(&f.x, 0, sizeof(S2) - offsetof(ThreeUInts, a)); // BAD
    memset(&f.x, 0, sizeof(S2) - offsetof(ThreeUInts, b)); // BAD
    memset(&f.x, 0, sizeof(S2) - offsetof(ThreeUInts, c)); // BAD
    memset(&f.x, 0, sizeof(S2) - offsetof(FourUInts, inner)); // BAD
    memset(&f.x, 0, sizeof(S2) - offsetof(FourUInts, x)); // GOOD
    memset(&f.x, 0, sizeof(S2) - offsetof(S2, f)); // GOOD
    memset(&f.x, 0, sizeof(S2) - offsetof(S2, u)); // GOOD

    memset(&f, 0, sizeof(S2) - offsetof(ThreeUInts, a)); // GOOD
    memset(&f, 0, sizeof(S2) - offsetof(ThreeUInts, b)); // GOOD
    memset(&f, 0, sizeof(S2) - offsetof(ThreeUInts, c)); // GOOD
    memset(&f, 0, sizeof(S2) - offsetof(FourUInts, inner)); // GOOD
    memset(&f, 0, sizeof(S2) - offsetof(FourUInts, x)); // GOOD
    memset(&f, 0, sizeof(S2) - offsetof(S2, f)); // GOOD
    memset(&f, 0, sizeof(S2) - offsetof(S2, u)); // GOOD

    memset(&u, 0, sizeof(S2) - offsetof(ThreeUInts, a)); // BAD
    memset(&u, 0, sizeof(S2) - offsetof(ThreeUInts, b)); // BAD
    memset(&u, 0, sizeof(S2) - offsetof(ThreeUInts, c)); // BAD
    memset(&u, 0, sizeof(S2) - offsetof(FourUInts, inner)); // BAD
    memset(&u, 0, sizeof(S2) - offsetof(FourUInts, x)); // BAD
    memset(&u, 0, sizeof(S2) - offsetof(S2, f)); // BAD
    memset(&u, 0, sizeof(S2) - offsetof(S2, u)); // GOOD
  }
};

typedef int MyArray[10];

typedef struct _MyArrayArray {
	struct {
		int as[10];
	} bs[10];

	union {
		int i;
		char cs[4];
	} ds[10];

	struct {
		MyArray xs;
	} ys[10];
} MyArrayArray;

void test26() {
	MyArrayArray maa;

	maa.bs[0].as[-1] = 0; // BAD: underrun write [NOT DETECTED]
	maa.bs[0].as[0] = 0; // GOOD
	maa.bs[0].as[99] = 0; // GOOD (overflows into bs[9])
	maa.bs[0].as[100] = 0; // BAD: overrun write [NOT DETECTED]
	maa.bs[1].as[-1] = 0; // GOOD (underflows into bs[0])
	maa.bs[1].as[0] = 0; // GOOD
	maa.bs[1].as[99] = 0; // BAD: overrun write [NOT DETECTED]
	maa.bs[1].as[100] = 0; // BAD: overrun write[ NOT DETECTED]

	maa.ds[0].i = 0; // GOOD
	maa.ds[9].i = 0; // GOOD
	maa.ds[10].i = 0; // BAD: overrun write [NOT DETECTED]
	maa.ds[0].cs[0] = 0; // GOOD
	maa.ds[0].cs[3] = 0; // GOOD
	maa.ds[0].cs[4] = 0; // GOOD (overflows into vs[1])
	maa.ds[0].cs[39] = 0; // GOOD (overflows into vs[9])
	maa.ds[0].cs[40] = 0; // BAD: overrun write [NOT DETECTED]
	maa.ds[9].cs[0] = 0; // GOOD
	maa.ds[9].cs[3] = 0; // GOOD
	maa.ds[9].cs[4] = 0; // BAD: overrun write [NOT DETECTED]

	maa.ys[0].xs[-1] = 0; // BAD: underrun write [NOT DETECTED]
	maa.ys[0].xs[0] = 0; // GOOD
	maa.ys[0].xs[99] = 0; // GOOD (overflows into bs[9])
	maa.ys[0].xs[100] = 0; // BAD: overrun write [NOT DETECTED]
	maa.ys[1].xs[-1] = 0; // GOOD (underflows into ys[0])
	maa.ys[1].xs[0] = 0; // GOOD
	maa.ys[1].xs[99] = 0; // BAD: overrun write [NOT DETECTED]
	maa.ys[1].xs[100] = 0; // BAD: overrun write [NOT DETECTED]

	char zs[2][2];
	zs[0][-1] = 0; // BAD: underrun write [NOT DETECTED]
	zs[0][0] = 0; // GOOD
	zs[0][1] = 0; // GOOD
	zs[0][2] = 0; // GOOD
	zs[0][3] = 0; // GOOD
	zs[0][4] = 0; // BAD: overrun write [NOT DETECTED]
	zs[1][-3] = 0; // BAD: underrun write [NOT DETECTED]
	zs[1][-2] = 0; // GOOD
	zs[1][-1] = 0; // GOOD
	zs[1][0] = 0; // GOOD
	zs[1][1] = 0; // GOOD
	zs[1][2] = 0; // BAD: overrun write [NOT DETECTED]
}

struct Array10 {
	int values[10];
};

void test27(size_t s) {
	Array10 arr;

	if (s < sizeof(arr.values[10])) { // GOOD (harmless)
		// ...
	}

	if (s < offsetof(Array10, values[10])) { // GOOD (harmless)
		// ...
	}

	if (s < &(arr.values[10]) - &(arr.values[0])) { // GOOD (harmless)
		// ...
	}
}

bool cond();

void test28() {
	int arr[10];

	int *ptr1 = arr;
	ptr1[-1] = 0; // BAD: underrun write
	ptr1++;
	ptr1[-1] = 0; // GOOD

	int *ptr2 = arr;
	ptr2[-1] = 0; // BAD: underrun write
	*ptr2++;
	ptr2[-1] = 0; // GOOD

	int *ptr3 = arr;
	ptr3[-1] = 0; // BAD: underrun write
	if (cond()) {
		ptr3++;
	}
	ptr3[-1] = 0; // GOOD (depending what cond() does)

	int *ptr4 = arr;
	ptr4[-1] = 0; // BAD: underrun write
	while (true) {
		ptr4++;
		if (cond()) break;
	}
	ptr4[-1] = 0; // GOOD

	int *ptr5 = arr;
	ptr5[-1] = 0; // BAD: underrun write
	while (true) {
		if (cond()) ptr5++;
		if (cond()) break;
	}
	ptr5[-1] = 0; // GOOD (depending what cond() does)
}

typedef int myInt29;
typedef myInt29 myArray29[10];
struct _myStruct29 {
	myArray29 arr1;
	myInt29 arr2[20];
};
typedef _myStruct29 myStruct29;

void test29() {
	myStruct29 *ptr;

	memset(ptr->arr1, 0, sizeof(ptr->arr1) + sizeof(ptr->arr2)); // GOOD (overwrites arr1, arr2)
	memset(&(ptr->arr1[0]), 0, sizeof(ptr->arr1) + sizeof(ptr->arr2)); // GOOD (overwrites arr1, arr2)

	memset(ptr->arr1, 0, sizeof(ptr->arr1) + sizeof(ptr->arr2) + 10); // BAD
}

struct UnionStruct {
	int a;
	union {
		char buffer1[64];
		int b;
	};
	union {
		char buffer2[64];
		int c;
	};
};

void test30() {
	UnionStruct us;

	memset(us.buffer1, 0, sizeof(us.buffer1)); // GOOD
	memset(us.buffer1, 0, sizeof(us)); // BAD
	memset(us.buffer2, 0, sizeof(us.buffer2)); // GOOD
	memset(us.buffer2, 0, sizeof(us)); // BAD

	strncpy(us.buffer1, "", sizeof(us.buffer1) - 1); // GOOD
	strncpy(us.buffer1, "", sizeof(us) - 1); // BAD
	strncpy(us.buffer2, "", sizeof(us.buffer2) - 1); // GOOD
	strncpy(us.buffer2, "", sizeof(us) - 1); // BAD
}

int tests_main(int argc, char *argv[])
{
	long long arr17[19];

	test1();
	test2();
	test3();
	test4(argc);
	test5(argc);
	test6(argc == 0);
	test7();
	test8(argc);
	test9(argc);
	test10();
	test11();
	test12();
	test15();
	test16();
	test17(arr17);
	test18();
	test19(argc == 0);
	test20();
	test21(argc == 0);
	test22(argc == 0, argv[0]);
	test23();
	test24(argv[0]);
	test25(argv[0]);
	test26();
	test27(argc);
	test28();
	test29();
	test30();

	return 0;
}
