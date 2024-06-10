class X
{
public:
  void set();
};

class Y
{
public:
  Y* f();

  const X* get() const { return 0; }
  X* get() { return 0; }
};

Y* Y::f()
{
  if ( get() )
    get()->set();
  return 0;
}

class Error {
public:
  Error() {}
};

bool getABool();

void doSomething(int x) {
  if (x == -1) {
    throw new Error();
  }
}

void doSomethingElse(int x);

bool testWithCatch0(int v)
{
    try
    {
        if( getABool() )
        {
            doSomething(v);
            return true;
        }
    }
    catch(Error &e)
    {
      doSomethingElse(v);
    }

    return false;
}

void use1(int);
void use2(int);
void use3(int);

void test_switches_simple(int i) {
  switch(i) {
    case 0:
      use1(i);
      break;
    case 1:
      use2(i);
      /* NOTE: fallthrough */
    case 2:
      use3(i);
  }
}

void test_switches_range(int i) {
  switch(i) {
    case 0 ... 10:
      use1(i);
      break;
    case 11 ... 20:
      use2(i);
  }
}

void test_switches_default(int i) {
  switch(i) {
    default:
      use1(i);
  }
}

void use(...);

void pointer_comparison(char* c) {
  if(c) {
    use(c);
  }
}

void implicit_float_comparison(float f) {
  if(f) {
    use(f);
  }
}

void explicit_float_comparison(float f) {
  if(f != 0.0f) {
    use(f);
  }
}

void int_float_comparison(int i) {
  if(i != 0.0f) {
    use(i);
  }
}

int source();
bool safe(int);

void test(bool b)
{
    int x;
    if (b)
    {
        x = source();
        if (!safe(x)) return;
    }
    use(x);
}

void binary_test_builtin_expected(int a, int b) {
  if(__builtin_expect(a == b + 42, 0)) {
      use(a);
  }

  if(__builtin_expect(a != b + 42, 0)) {
      use(a);
  }
}

void unary_test_builtin_expected(int a) {
  if(__builtin_expect(a == 42, 0)) {
      use(a);
  }

  if(__builtin_expect(a != 42, 0)) {
      use(a);
  }
}