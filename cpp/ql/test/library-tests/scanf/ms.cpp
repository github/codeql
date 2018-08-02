// semmle-extractor-options: --microsoft --edg --target --edg win64
/** standard library functions */
typedef __int32 int32_t;
typedef __int64 int64_t;

int sscanf(const char *s, const char *format, ...);
int printf(const char *format, ...);

/** test program */

void test()
{
	// I64 is a Microsoft specific size prefix
	{
		__int64	i64;

		sscanf("9999999999", "%I64i", &i64); // [MISSING FROM SCANFFORMATLITERAL]
		printf("= %I64i\n", i64);
	}
}
