// semmle-extractor-options: --expect_errors

typedef unsigned long size_t;
typedef int wchar_t;

int swprintf(wchar_t *s, size_t n, const wchar_t *format, ...);

void test_extraction_errors() {
    WCHAR buffer[3];
    swprintf(buffer, 3, L"abc");
}
