
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

void f2(char *src)
{
	char buffer[100];
	char *ptr;
	int amount;

	amount = 100;
	memcpy(buffer, src, amount); // GOOD
	amount = amount + 1;
	memcpy(buffer, src, amount); // BAD [NOT DETECTED]
	amount = 101;
	memcpy(buffer, src, amount); // BAD

	ptr = buffer;
	memcpy(ptr, src, 101); // BAD [NOT DETECTED]
	ptr = &(buffer[0]);
	memcpy(ptr, src, 101); // BAD [NOT DETECTED]
	ptr = &(buffer[1]);
	memcpy(ptr, src, 100); // BAD [NOT DETECTED]
}

void f3() {
    int i;
    char buffer[5];
    for (i=0; i<10; i++) {
        if (i < 5) {
            buffer[i] = 0; // GOOD
        }
    }
}
