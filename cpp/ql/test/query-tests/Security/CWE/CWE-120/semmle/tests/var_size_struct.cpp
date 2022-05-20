//semmle-extractor-options: --edg --target --edg linux_x86_64

// Semmle test cases for rule CWE-120 involving variable size structs.

// library types, functions etc
typedef unsigned long size_t;
void *malloc(size_t size);
char *strcpy(char *s1, const char *s2); 

// --- Semmle tests ---

struct varStruct {
  int size;
  char data[1];
};

void testVarStruct() {
  varStruct *vs = (varStruct *)malloc(sizeof(varStruct) + 8);

  vs->size = 9;
  strcpy(vs->data, "12345678"); // GOOD
  strcpy(vs->data, "123456789"); // BAD: buffer overflow
}
