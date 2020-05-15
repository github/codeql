int atoi(const char *nptr);
void *malloc(unsigned long size);
char *getenv(const char *name);
void *memcpy(void *dst, void *src, unsigned long size);

struct ContainsArray {
  int arr[16];
  int x;
};

void taint_array(struct ContainsArray *ca, int offset) {
  int tainted = atoi(getenv("VAR"));
  memcpy(ca->arr + offset, &tainted, sizeof(int));
}

void test_conflated_fields3(int arbitrary) {
  struct ContainsArray ca;
  ca.x = 4;
  taint_array(&ca, arbitrary);
  malloc(ca.x); // not tainted [FALSE POSITIVE]
}
