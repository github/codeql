typedef unsigned long size_t;
#define MB_CUR_MAX 6
#define MB_LEN_MAX 16
int mbtowc(wchar_t *out, const char *in, size_t size);
int wprintf (const wchar_t* format, ...);
int strlen( const char * string );
int checkErrors();

static void goodTest0()
{
  char * ptr = "123456789";
  int ret;
  int len;
  len = 9;
  for (wchar_t wc; (ret = mbtowc(&wc, ptr, len)) > 0; len-=ret) { // GOOD
    wprintf(L"%lc", wc);
    ptr += ret;
  }
}
static void goodTest1(const char* ptr)
{
  int ret;
  int len;
  len = strlen(ptr);
  for (wchar_t wc; (ret = mbtowc(&wc, ptr, len)) > 0; len-=ret) { // GOOD
    wprintf(L"%lc", wc);
    ptr += ret;
  }
}
static void goodTest2(char* ptr)
{
  int ret;
  ptr[10]=0;
  int len = 9;
  for (wchar_t wc; (ret = mbtowc(&wc, ptr, 16)) > 0; len-=ret) { // GOOD
    wprintf(L"%lc", wc);
    ptr += ret;
  }
}

static void goodTest3(const char* ptr)
{
  int ret;
  int len;
  len = strlen(ptr);
  for (wchar_t wc; (ret = mbtowc(&wc, ptr, MB_CUR_MAX)) > 0; len-=ret) { // GOOD
    wprintf(L"%lc", wc);
    ptr += ret;
  }
}
static void goodTest4(const char* ptr)
{
  int ret;
  int len;
  len = strlen(ptr);
  for (wchar_t wc; (ret = mbtowc(&wc, ptr, MB_LEN_MAX)) > 0; len-=ret) { // GOOD
    wprintf(L"%lc", wc);
    ptr += ret;
  }
}
static void badTest1(const char* ptr)
{
  int ret;
  int len;
  len = strlen(ptr);
  for (wchar_t wc; (ret = mbtowc(&wc, ptr, 4)) > 0; len-=ret) { // BAD:we can get unpredictable results
    wprintf(L"%lc", wc);
    ptr += ret;
  }
}
static void badTest2(const char* ptr)
{
  int ret;
  int len;
  len = strlen(ptr);
  for (wchar_t wc; (ret = mbtowc(&wc, ptr, sizeof(wchar_t))) > 0; len-=ret) { // BAD:we can get unpredictable results
    wprintf(L"%lc", wc);
    ptr += ret;
  }
}

static void goodTest5(const char* ptr,wchar_t *wc,int wc_len)
{
  int ret;
  int len;
  len = wc_len;
  while (*ptr && len > 0) {
    ret = mbtowc(wc, ptr, len); // GOOD
    if (ret <0)
      break;
    if (ret == 0 || ret > len)
      break;
    len-=ret;
    ptr+=ret;
    wc++;
  }
}

static void badTest3(const char* ptr,int wc_len)
{
  int ret;
  int len;
  len = wc_len;
  wchar_t *wc = new wchar_t[wc_len];
  while (*ptr && len > 0) {
    ret = mbtowc(wc, ptr, MB_CUR_MAX); // BAD
    if (ret <0)
      break;
    if (ret == 0 || ret > len)
      break;
    len-=ret;
    ptr+=ret;
    wc++;
  }
}
static void badTest4(const char* ptr,int wc_len)
{
  int ret;
  int len;
  len = wc_len;
  wchar_t *wc = new wchar_t[wc_len];
  while (*ptr && len > 0) {
    ret = mbtowc(wc, ptr, 16); // BAD
    if (ret <0)
      break;
    if (ret == 0 || ret > len)
      break;
    len-=ret;
    ptr+=ret;
    wc++;
  }
}
static void badTest5(const char* ptr,int wc_len)
{
  int ret;
  int len;
  len = wc_len;
  wchar_t *wc = new wchar_t[wc_len];
  while (*ptr && len > 0) {
    ret = mbtowc(wc, ptr, sizeof(wchar_t)); // BAD
    if (ret <0)
      break;
    if (ret == 0 || ret > len)
      break;
    len-=ret;
    ptr+=ret;
    wc++;
  }
}

static void badTest6(const char* ptr,int wc_len)
{
  int ret;
  int len;
  len = wc_len;
  wchar_t *wc = new wchar_t[wc_len];
  while (*ptr && wc_len > 0) {
    ret = mbtowc(wc, ptr, wc_len); // BAD
    if (ret <0)
      if (checkErrors()) {
        ++ptr;
        --len;
        continue;
      } else
        break;
    if (ret == 0 || ret > len)
      break;
    wc_len--;
    len-=ret;
    wc++;
    ptr+=ret;
  }
}
static void badTest7(const char* ptr,int wc_len)
{
  int ret;
  int len;
  len = wc_len;
  wchar_t *wc = new wchar_t[wc_len];
  while (*ptr && wc_len > 0) {
    ret = mbtowc(wc, ptr, len); // BAD
    if (ret <0)
        break;
    if (ret == 0 || ret > len)
      break;
    len--;
    wc++;
    ptr+=ret;
  }
}
static void badTest8(const char* ptr,wchar_t *wc)
{
  int ret;
  int len;
  len = strlen(ptr);
  while (*ptr && len > 0) {
    ret = mbtowc(wc, ptr, len); // BAD
    if (ret <0)
      break;
    if (ret == 0 || ret > len)
      break;
    len-=ret;
    ptr++;
    wc+=ret;
  }
}
