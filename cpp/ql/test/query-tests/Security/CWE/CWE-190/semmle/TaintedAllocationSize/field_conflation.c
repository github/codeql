int atoi(const char *nptr);
void *malloc(unsigned long size);
char *getenv(const char *name);


struct XY {
  int x;
  int y;
};

void taint_array(struct XY *xyp) {
  int tainted = atoi(getenv("VAR"));
  xyp->y = tainted;
}

void test_conflated_fields3(void) {
  struct XY xy;
  xy.x = 4;
  taint_array(&xy);
  malloc(xy.x); // not tainted
}
