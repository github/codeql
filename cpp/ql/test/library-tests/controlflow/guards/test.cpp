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