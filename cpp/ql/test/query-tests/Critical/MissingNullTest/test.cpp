
#define NULL (0)

typedef unsigned long size_t;

void *memcpy(void *s1, const void *s2, size_t n);
void bcopy(const void *source, void *dest, size_t amount);

void mycopyint(const int *source, int *dest)
{
	*dest = *source;
}

void test1(bool cond)
{
	int x, y;

	{
		int *p, *q;

		y = *p; // $ MISSING: Alert // BAD (p is uninitialized and could be 0) [NOT DETECTED]
		p = NULL;
		y = *p; // $ Alert // BAD (p is 0)
		p = &x;
		y = *p; // GOOD (p points to x)
		p = q;
		y = *p; // $ MISSING: Alert // BAD (p is uninitialized and could be 0) [NOT DETECTED]
	}

	{
		int *p = &x;
		int *q = 0;

		memcpy(p, &y, sizeof(int)); // GOOD (p points to x)
		memcpy(q, &y, sizeof(int)); // $ Alert // BAD (p is 0)
	}

	{
		int *p = &x;
		int *q = 0;

		bcopy(&y, p, sizeof(int)); // GOOD (p points to x)
		bcopy(&y, q, sizeof(int)); // $ Alert // BAD (p is 0)
	}

	{
		int *p = &x;
		int *q = 0;

		mycopyint(&y, p); // GOOD (p points to x)
		mycopyint(&y, q); // $ Alert // BAD (p is 0)
	}

	{
		int *p = 0;
		int *q = &x;

		y = *p; // $ Alert // BAD (p is 0)
		memcpy(&p, &q, sizeof(p));
		y = *p; // GOOD (p points to x)
	}

	{
		int *p = 0;
		int *q = &x;

		y = *p; // $ Alert // BAD (p is 0)
		bcopy(&q, &p, sizeof(p));
		y = *p; // GOOD (p points to x)
	}
}
