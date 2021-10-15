//semmle-extractor-options: --edg --target --edg linux_x86_64

// Semmle test cases for rule CWE-119 involving variable size structs.

// library types, functions etc
typedef unsigned long size_t;
void *malloc(size_t size);
void *memset(void *s, int c, size_t n);
char *strncpy(char *s1, const char *s2, size_t n);

// --- tests ---

struct VarString1 {
  int length;
  char str[1];
};

struct VarString2 {
  int length;
  char str[1];
  void f(void) {return;};
};

struct VarString3 {
  int length;
  char str[1];
  bool operator==(const struct VarString3 &other) const { return true; }
};

struct VarString4 {
  int length;
  char str[1];
  int i;
};

struct VarString5 {
  int length;
  char str[1];
  char str2[1];
};

void testVarString(int n) {
  if (n >= 2)
  {
    VarString1* s1 = (VarString1*)malloc(sizeof(VarString1) + n);
    VarString2* s2 = (VarString2*)malloc(sizeof(VarString2) + n);
    VarString3* s3 = (VarString3*)malloc(sizeof(VarString3) + n);
    VarString4* s4 = (VarString4*)malloc(sizeof(VarString4) + n);
    VarString5* s5 = (VarString5*)malloc(sizeof(VarString5) + n);

    s1->str[1] = '?'; // GOOD
    s2->str[1] = '?'; // GOOD
    s3->str[1] = '?'; // GOOD
    s4->str[1] = '?'; // BAD [NOT DETECTED]
    s5->str[1] = '?'; // BAD [NOT DETECTED]
  }
}

// ---

struct varStruct1 {
  int amount;
  char data[0];
};

void testVarStruct1() {
  varStruct1 *vs1 = (varStruct1 *)malloc(sizeof(varStruct1) + 1024);

  vs1->amount = 1024;
  memset(vs1->data, 0, 1024); // GOOD
  memset(vs1->data, 0, 1025); // BAD: buffer overflow
  strncpy(vs1->data, "Hello, world!", 1024); // GOOD
  strncpy(vs1->data, "Hello, world!", 1025); // BAD
}

struct varStruct2 {
  int size;
  int elements[];
};

void testVarStruct2() {
  varStruct2 *vs2 = (varStruct2 *)malloc(sizeof(varStruct2) + (16 * sizeof(int)));
  int i;

  vs2->size = 16;
  vs2->elements[15] = 0; // GOOD
  vs2->elements[16] = 0; // BAD: buffer overflow
}

struct notVarStruct1 {
  int length;
  char str[128];
};

void testNotVarStruct1() {
  notVarStruct1 *nvs1 = (notVarStruct1 *)malloc(sizeof(notVarStruct1) * 2);

  memset(nvs1->str, 0, 128); // GOOD
  memset(nvs1->str, 0, 129); // BAD: buffer overflow
  memset(nvs1[1].str, 0, 128); // GOOD
  memset(nvs1[1].str, 0, 129); // BAD: buffer overflow
  strncpy(nvs1->str, "Hello, world!", 128); // GOOD
  strncpy(nvs1->str, "Hello, world!", 129); // BAD
}

struct notVarStruct2 {
  char str[0];
  int length;
};

void testNotVarStruct2() {
  notVarStruct2 *nvs2 = (notVarStruct2 *)malloc(sizeof(notVarStruct2) + 128);

  nvs2->length = 200;
  nvs2->str[0] = '?'; // BAD: buffer overflow [NOT DETECTED]
  nvs2->str[1] = '?'; // BAD: buffer overflow [NOT DETECTED]
}

struct varStruct3 {
  int a, b, c, d;
  unsigned char arr[1];
};
struct varStruct4 {
  int a, b, c, d;
  unsigned char arr[1];
};
struct varStruct5 {
  int a, b, c, d;
  unsigned char arr[1];
};
struct varStruct6 {
  int a, b, c, d;
  unsigned char arr[1];
};
struct varStruct7 {
  int a, b, c, d;
  unsigned char arr[1];
};
struct varStruct8 {
  int a, b, c, d;
  float arr[1];
};
struct varStruct9 {
  int a, b, c, d;
  unsigned char arr[1];
};

#define offsetof(type, memberdesignator) (size_t)(&((type*)0)->memberdesignator)

size_t sizeForVarStruct7(unsigned int array_size)
{
	return sizeof(varStruct7) + (sizeof(unsigned char) * array_size) - sizeof(unsigned char);
}

void useVarStruct34(varStruct5 *vs5) {
  varStruct3 *vs3a = (varStruct3 *)malloc(sizeof(varStruct3) + 9); // establish varStruct3 as variable size
  varStruct3 *vs3b = (varStruct3 *)malloc(sizeof(varStruct3));
  varStruct4 *vs4a = (varStruct4 *)malloc(sizeof(varStruct4));
  varStruct4 *vs4b = (varStruct4 *)malloc(sizeof(varStruct4));
  varStruct5 *vs5a = (varStruct5 *)malloc(sizeof(*vs5) + 9); // establish varStruct5 as variable size
  varStruct5 *vs5b = (varStruct5 *)malloc(sizeof(*vs5));
  varStruct6 *vs6 = (varStruct6 *)malloc(offsetof(varStruct6, arr) + 9); // establish varStruct6 as variable size
  varStruct7 *vs7 = (varStruct7 *)malloc(sizeForVarStruct7(9)); // establish varStruct7 as variable size
  varStruct9 *vs9 = (varStruct9 *)malloc(__builtin_offsetof(varStruct9, arr) + 9); // establish varStruct9 as variable size
}

void testVarStruct34(varStruct3 *vs3, varStruct4 *vs4, varStruct5 *vs5, varStruct6 *vs6, varStruct7 *vs7, varStruct8 *vs8, varStruct9 *vs9) {
  memset(vs3->arr, 'x', 100); // GOOD: it's variable size, we don't know how big so shouldn't flag
  memset(vs4->arr, 'x', 100); // BAD: [NOT DETECTED] it's not variable size, so this is a buffer overflow
  memset(vs5->arr, 'x', 100); // GOOD: it's variable size, we don't know how big so shouldn't flag
  memset(vs6->arr, 'x', 100); // GOOD: it's variable size, we don't know how big so shouldn't flag
  memset(vs7->arr, 'x', 100); // GOOD: it's variable size, we don't know how big so shouldn't flag
  memset(vs8->arr, 'x', 100); // GOOD: it's variable size, we don't know how big so shouldn't flag
  memset(vs9->arr, 'x', 100); // GOOD: it's variable size, we don't know how big so shouldn't flag
}

// ---

#define NUMINTS (10)

struct PseudoUnion {
	unsigned int flags;
	char data[0];
	int vals[NUMINTS];
};

void usePseudoUnion(PseudoUnion *pu, char *data) {
  // clear via pu->vals
  memset(pu->vals, 0, sizeof(int) * NUMINTS); // GOOD

  // fill via pu->data
  strncpy((char *)(pu->vals), data, sizeof(int) * NUMINTS); // GOOD

  // clear via pu->data
  memset(pu->data, 0, sizeof(int) * NUMINTS); // GOOD

  // fill via pu->data
  strncpy(pu->data, data, sizeof(int) * NUMINTS); // GOOD
}
