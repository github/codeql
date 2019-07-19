
struct S {
  union U { int a, b; } u;
  class C { public: int b, c; } c;
  int x, d;
  virtual void set_q(int val) { x = val; }
} s;

class C {
public:
  struct S { int d, e; } s;
  union U { int e, f; } u;
  int f, g;
} c;

union U {
  struct S { int g, h; } s;
  class C { public: int h, i; } c;
  int i, j;
} u;

int foo(void) {
  S s;
  C c;
  U u;
  s.u.a = c.s.e = u.c.i = 43;
  s.u.b += (u.c.i + u.j);
  return c.g;
}

struct T: S {
  int q, r;
  virtual void set_q(int val) { q = val; }
};

int bar(void) {
  const T *s = (const T *)&c;
  const S *t = static_cast<const S *>(s);
  T *x = const_cast<T *>(s);
  const T *v = dynamic_cast<const T *>(t);
  S *w = reinterpret_cast<S *>(&c);
  return x->c.b;
}
