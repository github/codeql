
typedef unsigned int size_t;

void *memcpy(void *dest, const void *src, size_t count);

void f1(void)
{
	char buffer1[3];
	char buffer2[] = {'a', 'b', 'c'};
	int i;

	for (i = 0; i < 3; i++)
	{
		buffer1[i] = 0; // GOOD
		buffer2[i] = 0; // GOOD
	}
	for (i = 0; i < 4; i++)
	{
		buffer1[i] = 0; // BAD
		buffer2[i] = 0; // BAD
	}

	memcpy(buffer1, buffer2, 3); // GOOD
	memcpy(buffer1, buffer2, 4); // BAD
	memcpy(buffer2, buffer1, 3); // GOOD
	memcpy(buffer2, buffer1, 4); // BAD
}
