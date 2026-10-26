struct S {
  int a;
  int b;
  int c;
  unsigned long *d;

  union {
    struct {
      const char *e;
      int f;
      S *g;
      const char *h;
      int i;
      bool j;
      bool k;
      const char *l;
      char **m;
    } n;

    struct {
      bool o;
      bool p;
    } q;
  } r;
};

int too_many_constants_init(S *s);

char *too_many_constants(const char *h, bool k, int i) {
  const char *e = "";
  char l[64] = "";
  char *m;

  S s[] = {
      {.a = 0, .c = 0, .d = nullptr, .r = {.n = {.e = e, .f = 1, .g = nullptr, .h = h, .i = i, .j = false, .k = k, .l = l, .m = &m}}},
      {.a = 0, .c = 0, .d = nullptr, .r = {.q = {.o = true, .p = true}}}
  };

  too_many_constants_init(s);

  return m; // GOOD - initialized by too_many_constants_init
}
