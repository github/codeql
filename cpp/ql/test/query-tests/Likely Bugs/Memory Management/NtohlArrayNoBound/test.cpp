
typedef unsigned int size_t;
void *memcpy(void *s1, const void *s2, size_t n);
size_t strlen(const char *s);
int ntohl(int x);

void test1(const char *source, size_t len)
{
	char buffer[256];
	size_t len2 = ntohl(len);

	memcpy(buffer, source, ntohl(len)); // BAD

	if (len2 < 256)
	{
		memcpy(buffer, source, len2); // GOOD
	}

	if (source != 0)
	{
		memcpy(buffer, source, len2); // BAD
	}

	if ((len2 < 256) && (source != 0))
	{
		memcpy(buffer, source, len2); // GOOD
	}

	if ((len2 < 256) || (source != 0))
	{
		memcpy(buffer, source, len2); // BAD
	}

	if (len2 < 256)
	{
		if (source != 0)
		{
			memcpy(buffer, source, len2); // GOOD
		}
	}

	if (len2 >= 256)
	{
		// fail
	} else {
		memcpy(buffer, source, len2); // GOOD
	}

	if (len2 + 1 < 256)
	{
		memcpy(buffer, source, len2 + 1); // GOOD
	}

	if (strlen(source) < 256)
	{
		memcpy(buffer, source, strlen(source)); // GOOD
	}

	if (strlen(source) < 256)
	{
		memcpy(buffer, source, len2); // BAD
	}

	buffer[len2] = 0; // BAD

	if (len2 < 256)
	{
		buffer[len2] = 0; // GOOD
	}

	{
		unsigned short lens = len2;
		buffer[lens] = 0; // BAD
	}

	if (len2 < 256)
	{
		unsigned short lens = len2;
		buffer[lens] = 0; // GOOD
	}

	size_t len3 = 0;
	if (len3 < 256)
	{
		len3 = ntohl(len);
		buffer[len3] = 0; // BAD
	}
}

void test2(size_t len)
{
	char buffer[256];

	buffer[len] = 0; // BAD
}

void test3(size_t len)
{
	test2(ntohl(len));
}
