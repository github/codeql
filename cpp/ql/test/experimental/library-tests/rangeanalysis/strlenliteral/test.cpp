unsigned long strlen(const char *);

void func(const char *s) {
  strlen("literal");
  strlen(s);
}
