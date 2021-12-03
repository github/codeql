typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);
#define NULL 0

void workFunction_0(char *s) {
  int intSize = 10;
  char *buf;
  buf = (char *) malloc(intSize);
  free(buf); // GOOD
  if(buf) free(buf); // BAD
}
void workFunction_1(char *s) {
  int intSize = 10;
  char *buf;
  buf = (char *) malloc(intSize);
  free(buf); // GOOD
  free(buf); // BAD
}
void workFunction_2(char *s) {
  int intSize = 10;
  char *buf;
  buf = (char *) malloc(intSize);
  free(buf); // GOOD
  buf = NULL;
  free(buf); // GOOD
}
void workFunction_3(char *s) {
  int intSize = 10;
  char *buf;
  int intFlag;
  buf = (char *) malloc(intSize);
  if(buf[1]%5) {
    free(buf); // GOOD
    buf = NULL;
  }
  free(buf); // GOOD
}
void workFunction_4(char *s) {
  int intSize = 10;
  char *buf;
  char *tmpbuf;
  tmpbuf = (char *) malloc(intSize);
  buf = (char *) malloc(intSize);
  free(buf); // GOOD
  buf = tmpbuf;
  free(buf); // GOOD
}
void workFunction_5(char *s, int intFlag) {
  int intSize = 10;
  char *buf;

  buf = (char *) malloc(intSize);
  if(intFlag) {
    free(buf); // GOOD
  }
  free(buf); // BAD
}
void workFunction_6(char *s, int intFlag) {
  int intSize = 10;
  char *buf;
  char *tmpbuf;

  tmpbuf = (char *) malloc(intSize);
  buf = (char *) malloc(intSize);
  if(intFlag) {
    free(buf); // GOOD
    buf = tmpbuf;
  }
  free(buf); // GOOD
}
void workFunction_7(char *s) {
  int intSize = 10;
  char *buf;
  char *buf1;
  buf = (char *) malloc(intSize);
  buf1 = (char *) realloc(buf,intSize*4);
  free(buf); // BAD
}
void workFunction_8(char *s) {
  int intSize = 10;
  char *buf;
  char *buf1;
  buf = (char *) malloc(intSize);
  buf1 = (char *) realloc(buf,intSize*4);
  if(!buf1)
  free(buf); // GOOD
}
void workFunction_9(char *s) {
  int intSize = 10;
  char *buf;
  char *buf1;
  buf = (char *) malloc(intSize);
  if(!(buf1 = (char *) realloc(buf,intSize*4)))
  free(buf); // GOOD
}
