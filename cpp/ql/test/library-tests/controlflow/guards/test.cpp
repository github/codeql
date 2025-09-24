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

void test_cmp_implies(int a, int b) {
  if((a == b) == 0) {
    
  } else {

  }

  if((a == b) != 0) {
    
  } else {

  }


  if((a != b) == 0) {
    
  } else {

  }

  if((a != b) != 0) {
    
  } else {

  }


  if((a < b) == 0) {
    
  } else {

  }

  if((a < b) != 0) {
    
  } else {

  }
}

void test_cmp_implies_unary(int a) {
  if((a == 42) == 0) {
    
  } else {

  }

  if((a == 42) != 0) {
    
  } else {

  }


  if((a != 42) == 0) {
    
  } else {

  }

  if((a != 42) != 0) {
    
  } else {

  }

  if((a < 42) == 0) {
    
  } else {

  }

  if((a < 42) != 0) {
    
  } else {

  }
}

int foo();

void test_constant_value_and_case_range(bool b)
{
  int x = foo();
  if (b)
  {
    x = 42;
  }
  switch (x)
  {
  case 40 ... 50:
    // should not be guarded by `foo() = 40..50`
    use(x);
  }
}

void chk();

bool testNotNull1(void* input) {
  return input != nullptr;
}

void test_ternary(void* y) {
  int x = testNotNull1(y) ? 42 : 0;
  if (x != 0) {
    chk(); // $ guarded='... ? ... : ...:not 0' guarded='42:not 0' guarded='call to testNotNull1:true' guarded='x != 0:true' guarded='x:not 0' guarded='y:not null'
  }
}

bool testNotNull2(void* input) {
  if (input == nullptr) return false;
  return true;
}

int getNumOrDefault(int* number) {
  return number == nullptr ? 0 : *number;
}

char returnAIfNoneAreNull(char* s1, char* s2) {
  if (!s1 || !s2) return '\0';
  return 'a';
}

enum class Status { SUCCESS = 1, FAILURE = 2 };

Status testEnumWrapper(bool flag) {
  return flag ? Status::SUCCESS : Status::FAILURE;
}

void testWrappers(void* p, int* i, char* s, bool b) {
  if (testNotNull1(p)) {
    chk(); // $ guarded='p:not null' guarded='call to testNotNull1:true'
  } else {
    chk(); // $ guarded=p:null guarded='call to testNotNull1:false'
  }

  if (testNotNull2(p)) {
    chk(); // $ guarded='call to testNotNull2:true' guarded='p:not null'
  } else {
    chk(); // $ guarded='call to testNotNull2:false' guarded=p:null
  }

  if (0 == getNumOrDefault(i)) {
    chk(); // $ guarded='0 == call to getNumOrDefault:true' guarded='call to getNumOrDefault:0'
  } else {
    chk(); // $ guarded='0 == call to getNumOrDefault:false' guarded='call to getNumOrDefault:not 0' guarded='i:not null'
  }

  if ('\0' == returnAIfNoneAreNull(s, "suffix")) {
    chk(); // $ guarded='0 == call to returnAIfNoneAreNull:true' guarded='call to returnAIfNoneAreNull:0'
  } else {
    chk(); // $ guarded='0 == call to returnAIfNoneAreNull:false' guarded='call to returnAIfNoneAreNull:not 0' guarded='s:not null' guarded='suffix:not null'
  }

  switch (testEnumWrapper(b)) {
    case Status::SUCCESS:
      chk(); // $ guarded='call to testEnumWrapper=SUCCESS:true' guarded='call to testEnumWrapper:1' guarded=b:true 
      break;
    case Status::FAILURE:
      chk(); // $ guarded='call to testEnumWrapper=FAILURE:true' guarded='call to testEnumWrapper:2' guarded=b:false
      break;
  }
}

void ensureNotNull(void* o) {
  if (!o) throw 42;
}

void testExceptionWrapper(void* s) {
  chk(); // nothing guards here
  ensureNotNull(s);
  chk(); // $ MISSING: guarded='call to ensureNotNull:no exception' guarded='s:not null'
}
