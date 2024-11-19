#define CP_ACP 1
#define CP_UTF8 1
#define WC_COMPOSITECHECK 1
#define NULL 0
typedef unsigned int UINT;
typedef unsigned long DWORD, *PDWORD, *LPDWORD;
typedef char CHAR;
#define CONST const
typedef wchar_t WCHAR;

typedef CHAR *LPSTR;
typedef CONST CHAR *LPCSTR;
typedef CONST WCHAR *LPCWSTR;

typedef int BOOL;
typedef BOOL *LPBOOL;


int WideCharToMultiByte(UINT CodePage,DWORD dwFlags,LPCWSTR lpWideCharStr,int cchWideChar,LPSTR lpMultiByteStr,int cbMultiByte,LPCWSTR lpDefaultChar,LPBOOL lpUsedDefaultChar);
int MultiByteToWideChar(UINT CodePage,DWORD dwFlags,LPCSTR lpMultiByteStr,int cbMultiByte,LPCWSTR lpWideCharStr,int cchWideChar);

int printf ( const char * format, ... );
typedef unsigned int size_t;
void* calloc (size_t num, size_t size);
void* malloc (size_t size);

static void badTest1(void *src,  int size) {
    WideCharToMultiByte(CP_ACP, 0, (LPCWSTR)src, -1, (LPSTR)src, size, 0, 0); // BAD
    MultiByteToWideChar(CP_ACP, 0, (LPCSTR)src, -1, (LPCWSTR)src, 30); // BAD
}
void goodTest2(){
  wchar_t src[] = L"0123456789ABCDEF";
  char dst[16];
  int res = WideCharToMultiByte(CP_UTF8, 0, src, -1, dst, 16, NULL, NULL); // GOOD
  if (res == sizeof(dst)) {
      dst[res-1] = NULL;
  } else {
      dst[res] = NULL;
  }
  printf("%s\n", dst);
}
static void badTest2(){
  wchar_t src[] = L"0123456789ABCDEF";
  char dst[16];
  WideCharToMultiByte(CP_UTF8, 0, src, -1, dst, 16, NULL, NULL); // BAD
  printf("%s\n", dst);
}
static void goodTest3(){
  char src[] = "0123456789ABCDEF";
  int size = MultiByteToWideChar(CP_UTF8, 0, src,sizeof(src),NULL,0);
  wchar_t * dst = (wchar_t*)calloc(size + 1, sizeof(wchar_t));
  MultiByteToWideChar(CP_UTF8, 0, src, -1, dst, size+1); // GOOD
}
static void badTest3(){
  char src[] = "0123456789ABCDEF";
  int size = MultiByteToWideChar(CP_UTF8, 0, src,sizeof(src),NULL,0);
  wchar_t * dst = (wchar_t*)calloc(size + 1, 1);
  MultiByteToWideChar(CP_UTF8, 0, src, -1, dst, size+1); // BAD
}
static void goodTest4(){
  char src[] = "0123456789ABCDEF";
  int size = MultiByteToWideChar(CP_UTF8, 0, src,sizeof(src),NULL,0);
  wchar_t * dst = (wchar_t*)malloc((size + 1)*sizeof(wchar_t));
  MultiByteToWideChar(CP_UTF8, 0, src, -1, dst, size+1); // GOOD
}
static void badTest4(){
  char src[] = "0123456789ABCDEF";
  int size = MultiByteToWideChar(CP_UTF8, 0, src,sizeof(src),NULL,0);
  wchar_t * dst = (wchar_t*)malloc(size + 1);
  MultiByteToWideChar(CP_UTF8, 0, src, -1, dst, size+1); // BAD
}
static int goodTest5(void *src){
  return WideCharToMultiByte(CP_ACP, 0, (LPCWSTR)src, -1, 0, 0, 0, 0); // GOOD
}
static int badTest5 (void *src) {
  return WideCharToMultiByte(CP_ACP, 0, (LPCWSTR)src, -1, 0, 3, 0, 0);  // BAD
}
static void goodTest6(WCHAR *src)
{
  int size;
  char dst[5] ="";
  size = WideCharToMultiByte(CP_ACP, WC_COMPOSITECHECK, src, -1, dst, 0, 0, 0);
  if(size>=sizeof(dst)){
      printf("buffer size error\n");
      return;
  }
  WideCharToMultiByte(CP_ACP, 0, src, -1, dst, sizeof(dst), 0, 0); // GOOD
  printf("%s\n", dst);
}
static void badTest6(WCHAR *src)
{
    char dst[5] ="";
    WideCharToMultiByte(CP_ACP, 0, src, -1, dst, 260, 0, 0); // BAD
    printf("%s\n", dst);
}
