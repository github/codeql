int atoi(const char *nptr);
void *malloc(unsigned long size);
char *getenv(const char *name);


struct XY {
  int x;
  int y;
};

void taint_field(struct XY *xyp) {
  int tainted = atoi(getenv("VAR"));
  xyp->y = tainted;
}

void test_conflated_fields3(void) {
  struct XY xy;
  xy.x = 4;
  taint_field(&xy);
  malloc(xy.x); // not tainted
}

struct ContainsArray {
  int arr[16];
  int x;
};

void taint_array(struct ContainsArray *ca, int offset) {
  int tainted = atoi(getenv("VAR"));
  memcpy(ca->arr + offset, &tainted, sizeof(int));
}

void test_conflated_fields4(int arbitrary) {
  struct ContainsArray ca;
  ca.x = 4;
  taint_array(&ca, arbitrary);
  malloc(ca.x); // not tainted [FALSE POSITIVE]
}
