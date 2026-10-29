void Constants() {
    char c_i = 1;
    char c_c = 'A';

    signed char sc_i = -1;
    signed char sc_c = 'A';

    unsigned char uc_i = 5;
    unsigned char uc_c = 'A';

    short s = 5;
    unsigned short us = 5;

    int i = 5;
    unsigned int ui = 5;

    long l = 5;
    unsigned long ul = 5;

    long long ll_i = 5;
    long long ll_ll = 5LL;
    unsigned long long ull_i = 5;
    unsigned long long ull_ull = 5ULL;

    bool b_t = true;
    bool b_f = false;

    wchar_t wc_i = 5;
    wchar_t wc_c = L'A';

    char16_t c16 = u'A';
    char32_t c32 = U'A';

    float f_i = 1;
    float f_f = 1.0f;
    float f_d = 1.0;

    double d_i = 1;
    double d_f = 1.0f;
    double d_d = 1.0;
}

void Foo() {
    int x = 5 + 12;
    short y = 7;
    y = x + y;
    x = x * y;
}

void IntegerOps(int x, int y) {
    int z;

    z = x + y;
    z = x - y;
    z = x * y;
    z = x / y;
    z = x % y;

    z = x & y;
    z = x | y;
    z = x ^ y;

    z = x << y;
    z = x >> y;

    z = x;

    z += x;
    z -= x;
    z *= x;
    z /= x;
    z %= x;
    
    z &= x;
    z |= x;
    z ^= x;

    z <<= x;
    z >>= x;

    z = +x;
    z = -x;
    z = ~x;
    z = !x;
}

void IntegerCompare(int x, int y) {
    bool b;

    b = x == y;
    b = x != y;
    b = x < y;
    b = x > y;
    b = x <= y;
    b = x >= y;
}

void IntegerCrement(int x) {
    int y;

    y = ++x;
    y = --x;
    y = x++;
    y = x--;
}

void IntegerCrement_LValue(int x) {
    int* p;

    p = &(++x);
    p = &(--x);
}

void FloatOps(double x, double y) {
    double z;

    z = x + y;
    z = x - y;
    z = x * y;
    z = x / y;

    z = x;

    z += x;
    z -= x;
    z *= x;
    z /= x;

    z = +x;
    z = -x;
}

void FloatCompare(double x, double y) {
    bool b;

    b = x == y;
    b = x != y;
    b = x < y;
    b = x > y;
    b = x <= y;
    b = x >= y;
}

void FloatCrement(float x) {
    float y;

    y = ++x;
    y = --x;
    y = x++;
    y = x--;
}

void PointerOps(int* p, int i) {
    int* q;
    bool b;

    q = p + i;
    q = i + p;
    q = p - i;
    i = p - q;

    q = p;

    q += i;
    q -= i;

    b = p;
    b = !p;
}

void ArrayAccess(int* p, int i) {
    int x;

    x = p[i];
    x = i[p];

    p[i] = x;
    i[p] = x;

    int a[10];
    x = a[i];
    x = i[a];
    a[i] = x;
    i[a] = x;
}

void StringLiteral(int i) {
    char c = "Foo"[i];
    wchar_t* pwc = L"Bar";
    wchar_t wc = pwc[i];
}

void PointerCompare(int* p, int* q) {
    bool b;

    b = p == q;
    b = p != q;
    b = p < q;
    b = p > q;
    b = p <= q;
    b = p >= q;
}

void PointerCrement(int* p) {
    int* q;

    q = ++p;
    q = --p;
    q = p++;
    q = p--;
}

void CompoundAssignment() {
    // No conversion necessary
    int x = 5;
    x += 7;

    // Left side is converted to 'int'
    short y = 5;
    y += x;

    // Technically the left side is promoted to int, but we don't model that
    y <<= 1;

    // Left side is converted to 'float'
    long z = 7;
    z += 2.0f;
}

void UninitializedVariables() {
    int x;
    int y = x;
}

int Parameters(int x, int y) {
    return x % y;
}

void IfStatements(bool b, int x, int y) {
    if (b) {
    }

    if (b) {
        x = y;
    }

    if (x < 7)
        x = 2;
    else
        x = 7;
}

void WhileStatements(int n) {
    while (n > 0) {
        n -= 1;
    }
}

void DoStatements(int n) {
    do {
        n -= 1;
    } while (n > 0);
}

void For_Empty() {
    int j;
    for (;;) {
        ;
    }
}

void For_Init() {
    for (int i = 0;;) {
        ;
    }
}

void For_Condition() {
    int i = 0;
    for (; i < 10;) {
        ;
    }
}

void For_Update() {
    int i = 0;
    for (;; i += 1) {
        ;
    }
}

void For_InitCondition() {
    for (int i = 0; i < 10;) {
        ;
    }
}

void For_InitUpdate() {
    for (int i = 0;; i += 1) {
        ;
    }
}

void For_ConditionUpdate() {
    int i = 0;
    for (; i < 10; i += 1) {
        ;
    }
}

void For_InitConditionUpdate() {
    for (int i = 0; i < 10; i += 1) {
        ;
    }
}

void For_Break() {
    for (int i = 0; i < 10; i += 1) {
        if (i == 5) {
            break;
        }
    }
}

void For_Continue_Update() {
    for (int i = 0; i < 10; i += 1) {
        if (i == 5) {
            continue;
        }
    }
}

void For_Continue_NoUpdate() {
    for (int i = 0; i < 10;) {
        if (i == 5) {
            continue;
        }
    }
}

int Dereference(int* p) {
    *p = 1;
    return *p;
}

int g;

int* AddressOf() {
    return &g;
}

void Break(int n) {
    while (n > 0) {
        if (n == 1)
            break;
        n -= 1;
    }
}

void Continue(int n) {
    do {
        if (n == 1) {
            continue;
        }
        n -= 1;
    } while (n > 0);
}

void VoidFunc();
int Add(int x, int y);

void Call() {
    VoidFunc();
}

int CallAdd(int x, int y) {
    return Add(x, y);
}

int Comma(int x, int y) {
    return VoidFunc(), CallAdd(x, y);
}

void Switch(int x) {
    int y;
    switch (x) {
        y = 1234;

        case -1:
            y = -1;
            break;

        case 1:
        case 2:
            y = 1;
            break;
        
        case 3:
            y = 3;
        case 4:
            y = 4;
            break;

        default:
            y = 0;
            break;

        y = 5678;
    }
}

struct Point {
    int x;
    int y;
};

struct Rect {
    Point topLeft;
    Point bottomRight;
};

Point ReturnStruct(Point pt) {
    return pt;
}

void FieldAccess() {
    Point pt;
    pt.x = 5;
    pt.y = pt.x;
    int* p = &pt.y;
}

void LogicalOr(bool a, bool b) {
    int x;
    if (a || b) {
        x = 7;
    }

    if (a || b) {
        x = 1;
    }
    else {
        x = 5;
    }
}

void LogicalAnd(bool a, bool b) {
    int x;
    if (a && b) {
        x = 7;
    }

    if (a && b) {
        x = 1;
    }
    else {
        x = 5;
    }
}

void LogicalNot(bool a, bool b) {
    int x;
    if (!a) {
        x = 1;
    }

    if (!(a && b)) {
        x = 2;
    }
    else {
        x = 3;
    }
}

void ConditionValues(bool a, bool b) {
    bool x;
    x = a && b;
    x = a || b;
    x = !(a || b);
}

void Conditional(bool a, int x, int y) {
    int z = a ? x : y;
}

void Conditional_LValue(bool a) {
    int x;
    int y;
    (a ? x : y) = 5;
}

void Conditional_Void(bool a) {
    a ? VoidFunc() : VoidFunc();
}

void Nullptr() {
    int* p = nullptr;
    int* q = 0;
    p = nullptr;
    q = 0;
}

void InitList(int x, float f) {
    Point pt1 = { x, f };
    Point pt2 = { x };
    Point pt3 = {};

    int x1 = { 1 };
    int x2 = {};
}

void NestedInitList(int x, float f) {
    Rect r1 = {};
    Rect r2 = { { x, f } };
    Rect r3 = { { x, f }, { x, f } };
    Rect r4 = { { x }, { x } };
}

void ArrayInit(int x, float f) {
    int a1[3] = {};
    int a2[3] = { x, f, 0 };
    int a3[3] = { x };
}

union U {
    double d;
    int i;
};

void UnionInit(int x, float f) {
    U u1 = { f };
//    U u2 = {};  Waiting for fix
}

void EarlyReturn(int x, int y) {
    if (x < y) {
        return;
    }

    y = x;
}

int EarlyReturnValue(int x, int y) {
    if (x < y) {
        return x;
    }

    return x + y;
}

int CallViaFuncPtr(int (*pfn)(int)) {
    return pfn(5);
}

typedef enum {
    E_0,
    E_1
} E;

int EnumSwitch(E e) {
    switch (e) {
        case E_0:
            return 0;
        case E_1:
            return 1;
        default:
            return -1;
    }
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

void VarArgFunction(const char* s, ...);

void VarArgs() {
    VarArgFunction("%d %s", 1, "string");
}

int FuncPtrTarget(int);

void SetFuncPtr() {
    int (*pfn)(int) = FuncPtrTarget;
    pfn = &FuncPtrTarget;
    pfn = *FuncPtrTarget;
    pfn = ***&FuncPtrTarget;
}

struct String {
    String();
    String(const String&);
    String(String&&);
    String(const char*);
    ~String();

    String& operator=(const String&);
    String& operator=(String&&);

    const char* c_str() const;

private:
    const char* p;
};

String ReturnObject();

void DeclareObject() {
    String s1;
    String s2("hello");
    String s3 = ReturnObject();
    String s4 = String("test");
}

void CallMethods(String& r, String* p, String s) {
    r.c_str();
    p->c_str();
    s.c_str();
}

namespace {
class C {
public:
    static int StaticMemberFunction(int x) {
        return x;
    }

    int InstanceMemberFunction(int x) {
        return x;
    }

    virtual int VirtualMemberFunction(int x) {
        return x;
    }

    void FieldAccess() {
        this->m_a = 0;
        (*this).m_a = 1;
        m_a = 2;
        int x;
        x = this->m_a;
        x = (*this).m_a;
        x = m_a;
    }

    void MethodCalls() {
        this->InstanceMemberFunction(0);
        (*this).InstanceMemberFunction(1);
        InstanceMemberFunction(2);
    }
    
    C() :
        m_a(1),
        m_c(3),
        m_e{},
        m_f("test")
    {
    }

private:
    int m_a;
    String m_b;
    char m_c;
    float m_d;
    void* m_e;
    String m_f;
};
}

int DerefReference(int& r) {
    return r;
}

int& TakeReference() {
    return g;
}

String& ReturnReference();

void InitReference(int x) {
    int& r = x;
    int& r2 = r;
    const String& r3 = ReturnReference();
}

void ArrayReferences() {
  int a[10];
  int (&ra)[10] = a;
  int x = ra[5];
}

void FunctionReferences() {
  int(&rfn)(int) = FuncPtrTarget;
  int(*pfn)(int) = rfn;
  rfn(5);
}

template<typename T>
T min(T x, T y) {
  return (x < y) ? x : y;
}

int CallMin(int x, int y) {
  return min(x, y);
}

template<typename T>
struct Outer {
  template<typename U, typename V>
  static T Func(U x, V y) {
    return T();
  }
};

double CallNestedTemplateFunc() {
  return Outer<long>::Func<void*, char>(nullptr, 'o');
}

void TryCatch(bool b) {
  try {
    int x = 5;
    if (b) {
      throw "string literal";
    }
    else if (x < 2) {
      x = b ? 7 : throw String("String object");
    }
    x = 7;
  }
  catch (const char* s) {
    throw String(s);
  }
  catch (const String& e) {
  }
  catch (...) {
    throw;
  }
}

struct Base {
  String base_s;

  Base() {
  }
  ~Base() {
  }
};

struct Middle : Base {
  String middle_s;

  Middle() {
  }
  ~Middle() {
  }
};

struct Derived : Middle {
  String derived_s;

  Derived() {
  }
  ~Derived() {
  }
};

struct MiddleVB1 : virtual Base {
  String middlevb1_s;

  MiddleVB1() {
  }
  ~MiddleVB1() {
  }
};

struct MiddleVB2 : virtual Base {
  String middlevb2_s;

  MiddleVB2() {
  }
  ~MiddleVB2() {
  }
};

struct DerivedVB : MiddleVB1, MiddleVB2 {
  String derivedvb_s;

  DerivedVB() {
  }
  ~DerivedVB() {
  }
};

void HierarchyConversions() {
  Base b;
  Middle m;
  Derived d;

  Base* pb = &b;
  Middle* pm = &m;
  Derived* pd = &d;

  b = m;
  b = (Base)m;
  b = static_cast<Base>(m);
  pb = pm;
  pb = (Base*)pm;
  pb = static_cast<Base*>(pm);
  pb = reinterpret_cast<Base*>(pm);

  m = (Middle&)b;
  m = static_cast<Middle&>(b);
  pm = (Middle*)pb;
  pm = static_cast<Middle*>(pb);
  pm = reinterpret_cast<Middle*>(pb);

  b = d;
  b = (Base)d;
  b = static_cast<Base>(d);
  pb = pd;
  pb = (Base*)pd;
  pb = static_cast<Base*>(pd);
  pb = reinterpret_cast<Base*>(pd);

  d = (Derived&)b;
  d = static_cast<Derived&>(b);
  pd = (Derived*)pb;
  pd = static_cast<Derived*>(pb);
  pd = reinterpret_cast<Derived*>(pb);

  MiddleVB1* pmv = nullptr;
  DerivedVB* pdv = nullptr;
  pb = pmv;
  pb = pdv;
}

struct PolymorphicBase {
  virtual ~PolymorphicBase();
};

struct PolymorphicDerived : PolymorphicBase {
};

void DynamicCast() {
  PolymorphicBase b;
  PolymorphicDerived d;

  PolymorphicBase* pb = &b;
  PolymorphicDerived* pd = &d;

  // These two casts are represented as BaseClassCasts because they can be resolved at compile time.
  pb = dynamic_cast<PolymorphicBase*>(pd);
  PolymorphicBase& rb = dynamic_cast<PolymorphicBase&>(d);

  pd = dynamic_cast<PolymorphicDerived*>(pb);
  PolymorphicDerived& rd = dynamic_cast<PolymorphicDerived&>(b);

  void* pv = dynamic_cast<void*>(pb);
  const void* pcv = dynamic_cast<const void*>(pd);
}

String::String() :
  String("") {  // Delegating constructor call
}

void ArrayConversions() {
  char a[5];
  const char* p = a;
  p = "test";
  p = &a[0];
  p = &"test"[0];
  char (&ra)[5] = a;
  const char (&rs)[5] = "test";
  const char (*pa)[5] = &a;
  pa = &"test";
}

void FuncPtrConversions(int(*pfn)(int), void* p) {
  p = (void*)pfn;
  pfn = (int(*)(int))p;
}

void VarArgUsage(int x, ...) {
  __builtin_va_list args;

  __builtin_va_start(args, x);
  __builtin_va_list args2;
  __builtin_va_start(args2, args);
  double d = __builtin_va_arg(args, double);
  float f = __builtin_va_arg(args, float);
  __builtin_va_end(args);
  __builtin_va_end(args2);
}

void CastToVoid(int x) {
  (void)x;
}

void ConstantConditions(int x) {
  bool a = true && true;
  int b = (true) ? x : x;
}

typedef unsigned long size_t;

namespace std {
  enum class align_val_t : size_t {};
}

void* operator new(size_t, float);
void* operator new[](size_t, float);
void* operator new(size_t, std::align_val_t, float);
void* operator new[](size_t, std::align_val_t, float);
void operator delete(void*, float);
void operator delete[](void*, float);
void operator delete(void*, std::align_val_t, float);
void operator delete[](void*, std::align_val_t, float);

struct SizedDealloc {
  char a[32];
  void* operator new(size_t);
  void* operator new[](size_t);
  void operator delete(void*, size_t);
  void operator delete[](void*, size_t);
};

struct alignas(128) Overaligned {
  char a[256];
};

struct DefaultCtorWithDefaultParam {
  DefaultCtorWithDefaultParam(double d = 1.0);
};

void OperatorNew() {
  new int;  // No constructor
  new(1.0f) int;  // Placement new, no constructor
  new int();  // Zero-init
  new String();  // Constructor
  new(1.0f) String("hello");  // Placement new, constructor with args
  new Overaligned;  // Aligned new
  new(1.0f) Overaligned();  // Placement aligned new with zero-init
}

void OperatorNewArray(int n) {
  new int[10];  // Constant size
  new int[n];  // No constructor
  new(1.0f) int[n];  // Placement new, no constructor
  new String[n];  // Constructor
  new Overaligned[n];  // Aligned new
  new(1.0f) Overaligned[10];  // Aligned placement new
  new DefaultCtorWithDefaultParam[n];
  new int[n] { 0, 1, 2 };
}

int designatedInit() {
  int a1[1000] = { [2] = 10002, [900] = 10900 };
  return a1[900];
}

#if 0
void OperatorDelete() {
  delete static_cast<int*>(nullptr);  // No destructor
  delete static_cast<String*>(nullptr);  // Non-virtual destructor, with size.
  delete static_cast<SizedDealloc*>(nullptr);  // No destructor, with size.
  delete static_cast<Overaligned*>(nullptr);  // No destructor, with size and alignment.
  delete static_cast<PolymorphicBase*>(nullptr);  // Virtual destructor
}

void OperatorDeleteArray() {
  delete[] static_cast<int*>(nullptr);  // No destructor
  delete[] static_cast<String*>(nullptr);  // Non-virtual destructor, with size.
  delete[] static_cast<SizedDealloc*>(nullptr);  // No destructor, with size.
  delete[] static_cast<Overaligned*>(nullptr);  // No destructor, with size and alignment.
  delete[] static_cast<PolymorphicBase*>(nullptr);  // Virtual destructor
}
#endif

// semmle-extractor-options: -std=c++17
