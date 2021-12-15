//semmle-extractor-options: --edg --target --edg linux_x86_64 -std=c99

// library types, functions etc
typedef unsigned long size_t;
void *memcpy(void * restrict s1, const void * restrict s2, size_t n);

char smallbuf[1], largebuf[2];

void test1()
{
	memcpy(largebuf, smallbuf, 1); // GOOD
	memcpy(largebuf, smallbuf, 2); // BAD: source over-read
}

int main(int argc, char *argv[])
{
	test1();

	return 0;
}
