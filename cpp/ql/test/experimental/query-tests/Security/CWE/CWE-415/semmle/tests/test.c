typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);

void workFunction_0(char *s) {
  int intSize = 10;
  char *buf;
  buf = (char *) malloc(intSize);
  free(buf); // BAD
  if(buf) free(buf);
}
void workFunction_1(char *s) {
  int intSize = 10;
  char *buf;
  char *buf1;
  buf = (char *) malloc(intSize);
  buf1 = (char *) realloc(buf,intSize*2);
  if(buf) free(buf); // GOOD
  buf = (char *) realloc(buf1,intSize*4); // BAD
  free(buf1);
}
