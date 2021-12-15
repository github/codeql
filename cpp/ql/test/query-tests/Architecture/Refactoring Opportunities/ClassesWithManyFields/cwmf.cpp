// semmle-extractor-options: --clang
#define TEN(X) X(1) X(2) X(3) X(4) X(5) X(6) X(7) X(8) X(9) X(10)

#define int_f(n) int f##n;
#define int_g(n) int g##n;

struct aa {
  TEN(int_f)
  TEN(int_g)
};

class bb {
  TEN(int_f)
  TEN(int_g)
};

union cc_not_flagged_up_because_unions_are_not_classes_in_this_sense {
  TEN(int_f)
  TEN(int_g)
};

template <typename T>
struct dd {
  TEN(int_f)
  TEN(int_g)
};

template <typename U>
struct ee {
  TEN(int_f)
  TEN(int_g)
};

void instantiate() {
  dd<float> d1;
  dd<int> d2;
}

// from the qhelp (30 fields)
struct MyParticle {
  bool isActive;
  int priority;

  float x, y, z;
  float dx, dy, dz;
  float ddx, ddy, ddz;
  bool isCollider;

  int age, maxAge;
  float size1, size2;

  bool hasColor;
  unsigned char r1, g1, b1, a1;
  unsigned char r2, g2, b2, a2;

  class texture *tex;
  float u1, v1, u2, v2;
};

struct MyAlphaClass1 {
  int a1, b1, c1, d1, e1, f1, g1, h1, i1, j1;
  int k1, l1, m1, n1, o1, p1, q1, r1, s1, t1;
  int u1, v1, w1, x1, y1, z1;

  // ...
  // ...
  // ...

  int a2, b2, c2, d2, e2, f2, g2, h2, i2, j2;
  int k2, l2, m2, n2, o2, p2, q2, r2, s2, t2;
  int u2, v2, w2, x2, y2, z2;
};

struct MyAlphaClass2 {
  int x;

  // ...
  // ...
  // ...

  int a1, b1, c1, d1, e1, f1, g1, h1, i1, j1;
  int k1, l1, m1, n1, o1, p1, q1, r1, s1, t1;
  int u1, v1, w1, x1, y1, z1;
};
