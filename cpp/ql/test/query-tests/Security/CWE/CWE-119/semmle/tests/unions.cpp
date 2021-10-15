//semmle-extractor-options: --edg --target --edg linux_x86_64

// Semmle test cases for rule CWE-119 involving unions.

// library types, functions etc
typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);
void *memset(void *s, int c, size_t n);
void *memcpy(void *s1, const void *s2, size_t n);

// --- unions ---

union myUnion {
	char small[10];
	char large[100];
};

void myUnionTest()
{
	myUnion mu;

	memset(&mu, 0, sizeof(mu));
	memset(&mu, 0, sizeof(mu.small));
	memset(&mu, 0, sizeof(mu.large));
	memset(&mu, 0, 200); // BAD
	memset(&(mu.small), 0, sizeof(mu)); // (dubious)
	memset(&(mu.small), 0, sizeof(mu.small));
	memset(&(mu.small), 0, sizeof(mu.large)); // (dubious)
	memset(&(mu.small), 0, 200); // BAD
	memset(&(mu.large), 0, sizeof(mu));
	memset(&(mu.large), 0, sizeof(mu.small)); // (dubious)
	memset(&(mu.large), 0, sizeof(mu.large));
	memset(&(mu.large), 0, 200); // BAD
}

// ---

struct Header {
  int f1;
  int f2;
  int f3;
  int f4;
};

union FileBuf {
  char buf[0x10000];
  struct Header header;
};

void fileBufTest(FileBuf *buf) {
  Header* h = (Header *)malloc(sizeof(FileBuf));
  memcpy(h, &(buf->header), sizeof(FileBuf)); // GOOD (h, buf are both the size of FileBuf)
}
