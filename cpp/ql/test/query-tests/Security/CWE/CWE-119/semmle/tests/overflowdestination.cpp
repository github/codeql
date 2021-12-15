// Semmle test cases for rule CWE-119.

// --- library types, functions etc ---
typedef unsigned long size_t;
typedef size_t FILE;

void *malloc(size_t size);
char *strncpy(char *s1, const char *s2, size_t n);
size_t strlen(const char *s);
char *fgets(char *s, int n, FILE *stream);
void *memcpy(void *s1, const void *s2, size_t n);

// --- example from the qhelp ---

inline size_t min(size_t a, size_t b) {
	if (a < b) {
		return a;
	} else {
		return b;
	}
}

int main(int argc, char* argv[]) {
	char param[20];
	char *arg1;

	arg1 = argv[1];

	//wrong: only uses the size of the source (argv[1]) when using strncpy
	strncpy(param, arg1, strlen(arg1));

	//correct: uses the size of the destination array as well
	strncpy(param, arg1, min(strlen(arg1), sizeof(param) -1));
}

// --- test cases ---

void overflowdest_test1(FILE *f)
{
	char dest[64];
	char src[128];

	fgets(src, 128, f); // GOOD (taints `src`)

	memcpy(dest, src, sizeof(dest)); // GOOD
	memcpy(dest, src, sizeof(src)); // BAD: size derived from the source buffer
	memcpy(dest, dest, sizeof(dest)); // GOOD
}

void overflowdest_test2(FILE *f, char *dest, char *src)
{
	memcpy(dest, src, strlen(dest) + 1); // GOOD
	memcpy(dest, src, strlen(src) + 1); // BAD: size derived from the source buffer
	memcpy(dest, dest, strlen(dest) + 1); // GOOD
}

void overflowdest_test3(FILE *f, char *dest, char *src)
{
	char *dest2 = dest;
	char *src2 = src;
	char *src3 = src;

	memcpy(dest2, src2, strlen(dest2) + 1); // GOOD
	memcpy(dest2, src2, strlen(src2) + 1); // BAD: size derived from the source buffer
	memcpy(dest2, dest2, strlen(dest2) + 1); // GOOD
}

void overflowdest_test23_caller(FILE *f)
{
	char dest[64];
	char src[128];

	fgets(src, 128, f); // GOOD (taints `src`)

	overflowdest_test2(f, dest, src);
	overflowdest_test3(f, dest, src);
}

void overflowdest_test4(FILE *f, int destSize, int srcSize)
{
	char *dest = (char *)malloc(destSize);
	char *src = (char *)malloc(srcSize);

	fgets(src, srcSize, f); // GOOD (taints `src`)

	memcpy(dest, src, destSize); // GOOD
	memcpy(dest, src, srcSize); // BAD: size derived from the source buffer [NOT DETECTED]
	memcpy(dest, dest, destSize); // GOOD
}

class OverflowDestClass5 {
public:
	unsigned int bufferSize;
	char *buffer;
};

void overflowdest_test5(FILE *f, OverflowDestClass5 &dest, const OverflowDestClass5 &src)
{
	fgets(src.buffer, src.bufferSize, f); // GOOD (taints `src`)

	memcpy(dest.buffer, src.buffer, dest.bufferSize); // GOOD
	memcpy(dest.buffer, src.buffer, src.bufferSize); // BAD: size derived from the source buffer [NOT DETECTED]
	memcpy(dest.buffer, dest.buffer, dest.bufferSize); // GOOD
}
