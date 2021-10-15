// semmle-extractor-options: --edg --target --edg linux_x86_64
/*
 * Test for printf in a snapshot that contains multiple word/pointer sizes.
 */

int printf(const char * format, ...);

void test_64()
{
	long l;
	void *void_ptr;

	printf("%li", l); // GOOD
	printf("%li", void_ptr); // BAD
	printf("%p", l); // BAD
	printf("%p", void_ptr); // GOOD
}
