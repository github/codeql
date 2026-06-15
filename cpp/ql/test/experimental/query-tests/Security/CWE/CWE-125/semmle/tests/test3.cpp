#define NULL 0
typedef unsigned int size_t;

unsigned char * _mbsnbcpy(unsigned char * strDest,const unsigned char * strSource,size_t count);
size_t _mbclen(const unsigned char *c);
void _mbccpy(unsigned char *dest,const unsigned char *src);
unsigned char *_mbsinc(const unsigned char *current);
void goodTest1(unsigned char *src){
  unsigned char dst[50];
  _mbsnbcpy(dst,src,sizeof(dst)); // GOOD
}
static size_t badTest1(unsigned char *src){
  int cb = 0;
  unsigned char dst[50];
  while( cb < sizeof(dst) )
    dst[cb++]=*src++; // BAD
  return _mbclen(dst);
}
static void goodTest2(unsigned char *src){

  int cb = 0;
  unsigned char dst[50];
  while( (cb + _mbclen(src)) <= sizeof(dst) )
  {
    _mbccpy(dst+cb,src); // GOOD
    cb+=_mbclen(src);
    src=_mbsinc(src);
  }
}
static void badTest2(unsigned char *src){

  int cb = 0;
  unsigned char dst[50];
  while( cb < sizeof(dst) )
  {
    _mbccpy(dst+cb,src); // BAD
    cb+=_mbclen(src);
    src=_mbsinc(src);
  }
}
static void goodTest3(){
  wchar_t name[50];
  name[sizeof(name) / sizeof(*name) - 1] = L'\0'; // GOOD
}
static void badTest3(){
  wchar_t name[50];
  name[sizeof(name) - 1] = L'\0'; // BAD
}
