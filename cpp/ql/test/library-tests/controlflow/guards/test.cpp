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

void test_with_reference(bool& b, int a) {
   b = a < 10;
   if(!b) {
      use(a);
   }
}

void test_with_negated_binary_equality(int a, int b) {
  bool c = a != b;

  if (!c) {

  }
}

void test_with_negated_unary_relational(int a) {
  bool b = a > 10;

  if (!b) {

  }
}

void test_with_negated_binary_relational(int a, int b) {
  bool c = a > b;

  if (!c) {

  }
}

void test_logical_and(bool b1, bool b2) {
  if(!(b1 && b2)) {
    use(b1);
    use(b2);
  } else {
    // b1 = true and b2 = true
    use(b1);
    use(b2);
  }
}

void test_logical_or(bool b1, bool b2) {
  if(!(b1 || b2)) {
    // b1 = false and b2 = false
    use(b1);
    use(b2);
  } else {
    use(b1);
    use(b2);
  }
}

struct Mystruct {
  int i;
  float f;
};

int test_types(signed char sc, unsigned long ul, float f, double d, bool b, Mystruct &ms) {
    int ctr = 0;

    if (sc == 0) {
        ctr++;
    }
    if (sc == 0x0) {
        ctr++;
    }
    if (ul == 0) {
        ctr++;
    }
    if (f == 0) {
        ctr++;
    }
    if (f == 0.0) {
        ctr++;
    }
    if (d == 0) {
        ctr++;
    }
    if (b == 0) {
        ctr++;
    }
    if (b == false) {
        ctr++;
    }
    if (ms.i == 0) {
        ctr++;
    }
    if (ms.f == 0) {
        ctr++;
    }
    if (ms.i == 0 && ms.f == 0 && ms.i == 0) {
        ctr++;
    }
}
