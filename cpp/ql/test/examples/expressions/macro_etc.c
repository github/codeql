#define VARNAME t

int bar(int i) {
  union u {
    int a: 3;
    int b: 3;
    int c;
  } uu;
  uu.b = i + uu.a;
  return uu.b + i + 2;
}

#define SETSTR(S) \
  S##t \
  = #S

#define BODY \
  for (i = 0; i < 6; ++i) { \
    t += i; \
  }

int foo (void) {
  int VARNAME = 4;
  int (*bp)(int);
  char *bt, i;
  char arr[t];
  BODY
  BODY
  SETSTR(b);
  arr[0] = t;
  bp = bar;
  return t + arr[1];
}
