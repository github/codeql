/** standard printf functions */

int printf(const char *format, ...);

/** test program */

void restrict_cases(char * restrict str1, const char * restrict str2, short * restrict str3)
{
	printf("%s", str1); // GOOD
	printf("%s", str2); // GOOD
	printf("%s", str3); // BAD
}
