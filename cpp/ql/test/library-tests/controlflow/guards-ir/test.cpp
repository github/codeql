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
