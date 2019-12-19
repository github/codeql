
// library types, functions etc
typedef unsigned long size_t;
void *malloc(size_t size);
void *realloc(void *ptr, size_t size);
void *calloc(size_t nmemb, size_t size); 
void free(void *ptr);
wchar_t *wcscpy(wchar_t *s1, const wchar_t *s2); 

// --- Semmle tests ---

void tests2() {
  wchar_t *buffer;

  buffer = (wchar_t *)malloc(2 * sizeof(wchar_t));
  wcscpy(buffer, L"1"); // GOOD
  wcscpy(buffer, L"12"); // BAD: buffer overflow
  free(buffer);

  buffer = (wchar_t *)malloc(3 * sizeof(wchar_t));
  wcscpy(buffer, L"12"); // GOOD
  wcscpy(buffer, L"123"); // BAD: buffer overflow
  free(buffer);

  buffer = (wchar_t *)realloc(0, 4 * sizeof(wchar_t));
  wcscpy(buffer, L"123"); // GOOD
  wcscpy(buffer, L"1234"); // BAD: buffer overflow

  buffer = (wchar_t *)realloc(buffer, 5 * sizeof(wchar_t));
  wcscpy(buffer, L"1234"); // GOOD
  wcscpy(buffer, L"12345"); // BAD: buffer overflow
  free(buffer);

  buffer = (wchar_t *)calloc(6, sizeof(wchar_t));
  wcscpy(buffer, L"12345"); // GOOD
  wcscpy(buffer, L"123456"); // BAD: buffer overflow
  free(buffer);

  buffer = (wchar_t *)calloc(sizeof(wchar_t), 7);
  wcscpy(buffer, L"123456"); // GOOD
  wcscpy(buffer, L"1234567"); // BAD: buffer overflow
  free(buffer);

  buffer = new wchar_t[8];
  wcscpy(buffer, L"1234567"); // GOOD
  wcscpy(buffer, L"12345678"); // BAD: buffer overflow
  delete [] buffer;
}
