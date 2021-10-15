
typedef wchar_t MYWCHAR;

void test_wchar1(wchar_t *wstr)
{
	printf("%ws\n", wstr); // GOOD
}

#ifdef TEST_MICROSOFT
	void test_wchar2(__wchar_t *wstr)
	{
		printf("%ws\n", wstr); // GOOD
	}
#endif

void test_wchar3(MYWCHAR *wstr)
{
	printf("%ws\n", wstr); // GOOD
}

void test_wchar4(char c, const char cc, wchar_t wc, const wchar_t wcc) {
    printf("%c", c);               // GOOD
    printf("%c", cc);              // GOOD
    printf("%c", 'c');             // GOOD
    printf("%c", "c");             // BAD
    printf("%wc", wc);             // GOOD
    printf("%wc", wcc);            // GOOD
    printf("%wc", L'c');           // GOOD
    printf("%wc", L"c");           // BAD [NOT DETECTED]
}
