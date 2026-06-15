#define NULL 0
typedef unsigned int size_t;
struct mbstate_t{};
struct _locale_t{};
int printf ( const char * format, ... );
void* calloc (size_t num, size_t size);
void* malloc (size_t size);

size_t mbstowcs(wchar_t *wcstr,const char *mbstr,size_t count);
size_t _mbstowcs_l(wchar_t *wcstr,const char *mbstr,size_t count, _locale_t locale);
size_t mbsrtowcs(wchar_t *wcstr,const char *mbstr,size_t count, mbstate_t *mbstate);


static void badTest1(void *src,  int size) {
    mbstowcs((wchar_t*)src,(char*)src,size); // BAD
    _locale_t locale;
    _mbstowcs_l((wchar_t*)src,(char*)src,size,locale); // BAD
    mbstate_t *mbstate;
    mbsrtowcs((wchar_t*)src,(char*)src,size,mbstate); // BAD
}
static void goodTest2(){
  char src[] = "0123456789ABCDEF";
  wchar_t dst[16];
  int res = mbstowcs(dst, src,16); // GOOD
  if (res == sizeof(dst)) {
      dst[res-1] = NULL;
  } else {
      dst[res] = NULL;
  }
  printf("%s\n", dst);
}
static void badTest2(){
  char src[] = "0123456789ABCDEF";
  wchar_t dst[16];
  mbstowcs(dst, src,16); // BAD
  printf("%s\n", dst);
}
static void goodTest3(){
  char src[] = "0123456789ABCDEF";
  int size = mbstowcs(NULL, src,NULL);
  wchar_t * dst = (wchar_t*)calloc(size + 1, sizeof(wchar_t));
  mbstowcs(dst, src,size+1); // GOOD
}
static void badTest3(){
  char src[] = "0123456789ABCDEF";
  int size = mbstowcs(NULL, src,NULL);
  wchar_t * dst = (wchar_t*)calloc(size + 1, 1);
  mbstowcs(dst, src,size+1); // BAD
}
static void goodTest4(){
  char src[] = "0123456789ABCDEF";
  int size = mbstowcs(NULL, src,NULL);
  wchar_t * dst = (wchar_t*)malloc((size + 1)*sizeof(wchar_t));
  mbstowcs(dst, src,size+1); // GOOD
}
static void badTest4(){
  char src[] = "0123456789ABCDEF";
  int size = mbstowcs(NULL, src,NULL);
  wchar_t * dst = (wchar_t*)malloc(size + 1);
  mbstowcs(dst, src,size+1); // BAD
}
static int goodTest5(void *src){
  return mbstowcs(NULL, (char*)src,NULL); // GOOD
}
static int badTest5 (void *src) {
  return mbstowcs(NULL, (char*)src,3); // BAD
}
static void goodTest6(void *src){
  wchar_t dst[5];
  int size = mbstowcs(NULL, (char*)src,NULL);
  if(size>=sizeof(dst)){
      printf("buffer size error\n");
      return;
  }
  mbstowcs(dst, (char*)src,sizeof(dst)); // GOOD
  printf("%s\n", dst);
}
static void badTest6(void *src){
  wchar_t dst[5];
  mbstowcs(dst, (char*)src,260); // BAD
  printf("%s\n", dst);
}
