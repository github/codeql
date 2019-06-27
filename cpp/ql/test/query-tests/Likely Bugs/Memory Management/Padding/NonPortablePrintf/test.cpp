
int printf(const char *format, ...);

void test1()
{
	long l;
	void *ptr;

	printf("%l\n", l); // GOOD
	printf("%d\n", l); // BAD

	printf("%p\n", ptr); // GOOD
	printf("%d\n", ptr); // BAD
	printf("%u\n", ptr); // BAD
	printf("%x\n", ptr); // BAD
}
