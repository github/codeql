// semmle-extractor-options: -std=c++17

struct Point {
  int x;
  int y;
};

struct Rect {
  Point topLeft;
  Point bottomRight;
};

int ChiPhiNode(Point* p, bool which1, bool which2) {
  if (which1) {
    p->x++;
  }
  else {
    p->y++;
  }

  if (which2) {
    p->x++;
  }
  else {
    p->y++;
  }

  return p->x + p->y;
}

int UnreachableViaGoto() {
  goto skip;
  return 1;
skip:
  return 0;
}

int UnreachableIf(bool b) {
  int x = 5;
  int y = 10;
  if (b) {
    if (x == y) {
      return 1;
    }
    else {
      return 0;
    }
  }
  else {
    if (x < y) {
      return 0;
    }
    else {
      return 1;
    }
  }
}

int DoWhileFalse() {
  int i = 0;
  do {
    i++;
  } while (false);

  return i;
}

void chiNodeAtEndOfLoop(int n, char* p) {
  while (n-- > 0)
    * p++ = 0;
}

void Escape(void* p);

void ScalarPhi(bool b) {
  int x = 0;
  int y = 1;
  int z = 2;
  if (b) {
    x = 3;
    y = 4;
  }
  else {
    x = 5;
  }
  int x_merge = x;
  int y_merge = y;
  int z_merge = z;
}

void MustExactlyOverlap(Point a) {
  Point b = a;
}

void MustExactlyOverlapEscaped(Point a) {
  Point b = a;
  Escape(&a);
}

void MustTotallyOverlap(Point a) {
  int x = a.x;
  int y = a.y;
}

void MustTotallyOverlapEscaped(Point a) {
  int x = a.x;
  int y = a.y;
  Escape(&a);
}

void MayPartiallyOverlap(int x, int y) {
  Point a = { x, y };
  Point b = a;
}

void MayPartiallyOverlapEscaped(int x, int y) {
  Point a = { x, y };
  Point b = a;
  Escape(&a);
}

void MergeMustExactlyOverlap(bool c, int x1, int x2) {
  Point a = {};
  if (c) {
    a.x = x1;
  }
  else {
    a.x = x2;
  }
  int x = a.x;  // Both reaching defs must exactly overlap.
  Point b = a;
}

void MergeMustExactlyWithMustTotallyOverlap(bool c, Point p, int x1) {
  Point a = {};
  if (c) {
    a.x = x1;
  }
  else {
    a = p;
  }
  int x = a.x;  // Only one (non-Chi) reaching def must exactly overlap, but we should still get a Phi for it.
}

void MergeMustExactlyWithMayPartiallyOverlap(bool c, Point p, int x1) {
  Point a = {};
  if (c) {
    a.x = x1;
  }
  else {
    a = p;
  }
  Point b = a;  // Only one reaching def must exactly overlap, but we should still get a Phi for it.
}

void MergeMustTotallyOverlapWithMayPartiallyOverlap(bool c, Rect r, int x1) {
  Rect a = {};
  if (c) {
    a.topLeft.x = x1;
  }
  else {
    a = r;
  }
  Point b = a.topLeft;  // Neither reaching def must exactly overlap, so we'll just get a Phi of the virtual variable.
}

struct Wrapper {
  int f;
};

void WrapperStruct(Wrapper w) {
  Wrapper x = w;  // MustExactlyOverlap
  int a = w.f;  // MustTotallyOverlap, because the types don't match
  w.f = 5;
  a = w.f;  // MustExactlyOverlap
  x = w;  // MustTotallyOverlap
}

int AsmStmt(int *p) {
  __asm__("");
  return *p;
}

static void AsmStmtWithOutputs(unsigned int& a, unsigned int& b, unsigned int& c, unsigned int& d)
{
  __asm__ __volatile__
    (
  "cpuid\n\t"
    : "+a" (a), "+b" (b)
    : "c" (c), "d" (d)
    );
}

int strcmp(const char *, const char *);
int strlen(const char *);
int abs(int);

int PureFunctions(char *str1, char *str2, int x) {
  int ret = strcmp(str1, str2);
  ret += strlen(str1);
  ret += abs(x);
  return ret;
}

void *memcpy(void *dst, void *src, int size);

int ModeledCallTarget(int x) {
  int y;
  memcpy(&y, &x, sizeof(int));
  return y;
}

void InitArray() {
    char a_pad[32] = ""; 
    char a_nopad[4] = "foo";
    char a_infer[] = "blah";
    char b[2];
    char c[2] = {};
    char d[2] = { 0 };
    char e[2] = { 0, 1 };
    char f[3] = { 0 };
}

extern void ExternalFunc();

char StringLiteralAliasing() {
  ExternalFunc();

  const char* s = "Literal";
  return s[2];  // Should be defined by `AliasedDefinition`, not `Chi` or `CallSideEffect`.
}

class Constructible {
  public:
    Constructible(int x) {};
    void g() {}
};

void ExplicitConstructorCalls() {
  Constructible c(1);
  c.g();
  c.g();
  Constructible c2 = Constructible(2);
  c2.g();
}

char *VoidStarIndirectParameters(char *src, int size) {
  char *dst = new char[size];
  *src = 'a';
  memcpy(dst, src, size);
  return dst;
}

char StringLiteralAliasing2(bool b) {
  if (b) {
    ExternalFunc();
  }
  else {
    ExternalFunc();
  }

  const char* s = "Literal";
  return s[2];
}

void *malloc(int size);

void *MallocAliasing(void *s, int size) {
  void *buf = malloc(size);
  memcpy(buf, s, size);
  return buf;
}

Point *pp;
void EscapedButNotConflated(bool c, Point p, int x1) {
  Point a = {};
  pp = &a; // `a` escapes here and therefore belongs to the aliased vvar
  if (c) {
    a.x = x1;
  }
  int x = a.x; // The phi node here is not conflated
}

struct A {
  int i;
  A(int x) {}
  A(A*) {}
  A() {}
};

Point *NewAliasing(int x) {
  Point* p = new Point;
  Point* q = new Point;
  int j = (new A(new A(x)))->i;
  A* a = new A;
  return p;
}

void unknownFunction(int argc, char **argv);

int main(int argc, char **argv) {
  unknownFunction(argc, argv);
  unknownFunction(argc, argv);
  return **argv; // Chi chain goes through side effects from unknownFunction
}

class ThisAliasTest {
  int x, y;
  
  void setX(int arg) {
    this->x = arg;
  }
};
