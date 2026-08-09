
int printf(const char *format, ...);

void test1()
{
	long l;
	void *ptr;

	printf("%ld\n", l); // GOOD
	printf("%d\n", l); // $ Alert // BAD

	printf("%p\n", ptr); // GOOD
	printf("%d\n", ptr); // $ Alert // BAD
	printf("%u\n", ptr); // $ Alert // BAD
	printf("%x\n", ptr); // $ Alert // BAD
}
