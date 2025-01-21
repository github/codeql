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
    char pop_back();
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

void VAListUsage(int x, __builtin_va_list args) {
  __builtin_va_list args2;
  __builtin_va_copy(args2, args);
  double d = __builtin_va_arg(args, double);
  float f = __builtin_va_arg(args, int);
  __builtin_va_end(args2);
}

void VarArgUsage(int x, ...) {
  __builtin_va_list args;

  __builtin_va_start(args, x);
  __builtin_va_list args2;
  __builtin_va_copy(args2, args);
  double d = __builtin_va_arg(args, double);
  float f = __builtin_va_arg(args, int);
  __builtin_va_end(args);
  VAListUsage(x, args2);
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

void IfStmtWithDeclaration(int x, int y) {
  if (bool b = x < y) {
    x = 5;
  }
  else if (int z = x + y) {
    y = 7;
  }
  else if (int* p = &x) {
    *p = 2;
  }
}

void WhileStmtWithDeclaration(int x, int y) {
  while (bool b = x < y) {
  }
  while (int z = x + y) {
  }
  while (int* p = &x) {
  }
}

int PointerDecay(int a[], int fn(float)) {
  return a[0] + fn(1.0);
}

int StmtExpr(int b, int y, int z) {
  int x = ({
    int w;
    if (b) {
      w = y;
    } else {
      w = z;
    }
    w;
  });

  return ({x;});
}

// TODO: `delete` gets translated to NoOp
void OperatorDelete() {
  delete static_cast<int*>(nullptr);  // No destructor
  delete static_cast<String*>(nullptr);  // Non-virtual destructor, with size.
  delete static_cast<SizedDealloc*>(nullptr);  // No destructor, with size.
  delete static_cast<Overaligned*>(nullptr);  // No destructor, with size and alignment.
  delete static_cast<PolymorphicBase*>(nullptr);  // Virtual destructor
}

// TODO: `delete[]` gets translated to NoOp
void OperatorDeleteArray() {
  delete[] static_cast<int*>(nullptr);  // No destructor
  delete[] static_cast<String*>(nullptr);  // Non-virtual destructor, with size.
  delete[] static_cast<SizedDealloc*>(nullptr);  // No destructor, with size.
  delete[] static_cast<Overaligned*>(nullptr);  // No destructor, with size and alignment.
  delete[] static_cast<PolymorphicBase*>(nullptr);  // Virtual destructor
}

struct EmptyStruct {};

void EmptyStructInit() {
  EmptyStruct s = {};
}

auto lam = []() {};

void Lambda(int x, const String& s) {
  auto lambda_empty = [](float f) { return 'A'; };
  lambda_empty(0);
  auto lambda_ref = [&](float f) { return s.c_str()[x]; };
  lambda_ref(1);
  auto lambda_val = [=](float f) { return s.c_str()[x]; };
  lambda_val(2);
  auto lambda_ref_explicit = [&s](float f) { return s.c_str()[0]; };
  lambda_ref_explicit(3);
  auto lambda_val_explicit = [s](float f) { return s.c_str()[0]; };
  lambda_val_explicit(4);
  auto lambda_mixed_explicit = [&s, x](float f) { return s.c_str()[x]; };
  lambda_mixed_explicit(5);
  int r = x - 1;
  auto lambda_inits = [&s, x, i = x + 1, &j = r](float f) { return s.c_str()[x + i - j]; };
  lambda_inits(6);
}

namespace std {
    template<class T>
    struct remove_const { typedef T type; };

    template<class T>
    struct remove_const<const T> { typedef T type; };

    // `remove_const_t<T>` removes any `const` specifier from `T`
    template<class T>
    using remove_const_t = typename remove_const<T>::type;

    struct ptrdiff_t;

    template<class I> struct iterator_traits;

    template <class Category,
              class value_type,
              class difference_type = ptrdiff_t,
              class pointer_type = value_type*,
              class reference_type = value_type&>
    struct iterator {
        typedef Category iterator_category;

        iterator();
        iterator(iterator<Category, remove_const_t<value_type> > const &other); // non-const -> const conversion constructor

        iterator &operator++();
        iterator operator++(int);
        iterator &operator--();
        iterator operator--(int);
        bool operator==(iterator other) const;
        bool operator!=(iterator other) const;
        reference_type operator*() const;
        pointer_type operator->() const;
        iterator operator+(int);
        iterator operator-(int);
        iterator &operator+=(int);
        iterator &operator-=(int);
        int operator-(iterator);
        reference_type operator[](int);
    };

    struct input_iterator_tag {};
    struct forward_iterator_tag : public input_iterator_tag {};
    struct bidirectional_iterator_tag : public forward_iterator_tag {};
    struct random_access_iterator_tag : public bidirectional_iterator_tag {};

    struct output_iterator_tag {};

    template<typename T>
    struct vector {
        vector(T);
        ~vector();

        using iterator = std::iterator<random_access_iterator_tag, T>;
        using const_iterator = std::iterator<random_access_iterator_tag, const T>;

        iterator begin() const;
        iterator end() const;
    };

    template<typename T>
    bool operator==(typename vector<T>::iterator left, typename vector<T>::iterator right);
    template<typename T>
    bool operator!=(typename vector<T>::iterator left, typename vector<T>::iterator right);

}

void RangeBasedFor(const std::vector<int>& v) {
    for (int e : v) {
        if (e > 0) {
            continue;
        }
    }

    for (const int& e : v) {
        if (e < 5) {
            break;
        }
    }
}

#if 0  // Explicit capture of `this` requires possible extractor fixes.

struct LambdaContainer {
  int x;

  void LambdaMember(const String& s) {
    auto lambda_implicit_this = [=](float f) { return s.c_str()[x]; };
    lambda_implicit_this(1);
    auto lambda_explicit_this_byref = [this, &s](float f) { return s.c_str()[x]; };
    lambda_explicit_this_byref(2);
    auto lambda_explicit_this_bycopy = [*this, &s](float f) { return s.c_str()[x]; };
    lambda_explicit_this_bycopy(3);
  }
};

#endif

int AsmStmt(int x) {
  __asm__("");
  return x;
}

static void AsmStmtWithOutputs(unsigned int& a, unsigned int b, unsigned int& c, unsigned int d)
{
  __asm__ __volatile__
    (
  "cpuid\n\t"
    : "+a" (a), "+b" (b) : "c" (c), "d" (d)
    );
}

void ExternDeclarations()
{
    extern int g;
    int x;
    int y, f(float);
    int z(float), w(float), h;
    typedef double d;
}

#define EXTERNS_IN_MACRO \
    extern int g; \
    for (int i = 0; i < 10; ++i) { \
        extern int g; \
    }

void ExternDeclarationsInMacro()
{
    EXTERNS_IN_MACRO;
}

void TryCatchNoCatchAny(bool b) {
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
}

#define vector(elcount, type)  __attribute__((vector_size((elcount)*sizeof(type)))) type

void VectorTypes(int i) {
  vector(4, int) vi4 = { 0, 1, 2, 3 };
  int x = vi4[i];
  vi4[i] = x;
  vector(4, int) vi4_shuffle = __builtin_shufflevector(vi4, vi4, 3+0, 2, 1, 0);
  vi4 = vi4 + vi4_shuffle;
}

void *memcpy(void *dst, void *src, int size);

int ModeledCallTarget(int x) {
  int y;
  memcpy(&y, &x, sizeof(int));
  return y;
}

String ReturnObjectImpl() {
  return String("foo");
}

void switch1Case(int x) {
    int y = 0;
    switch(x) {
        case 1:
        y = 2;
    }
    int z = y;
}

void switch2Case_fallthrough(int x) {
    int y = 0;
    switch(x) {
        case 1:
        y = 2;
        case 2:
        y = 3;
    }
    int z = y;
}

void switch2Case(int x) {
    int y = 0;
    switch(x) {
        case 1:
        y = 2;
        break;
        case 2:
        y = 3;
    }
    int z = y;
}

void switch2Case_default(int x) {
    int y = 0;
    switch(x) {
        case 1:
            y = 2;
            break;

        case 2:
            y = 3;
            break;

        default:
            y = 4;
    }
    int z = y;
}

int staticLocalInit(int x) {
    static int a = 0;  // Constant initialization
    static int b = sizeof(x);  // Constant initialization
    static int c = x;  // Dynamic initialization
    static int d;  // Zero initialization

    return a + b + c + d;
}

void staticLocalWithConstructor(const char* dynamic) {
    static String a;
    static String b("static");
    static String c(dynamic);
}

// --- strings ---

char *strcpy(char *destination, const char *source);
char *strcat(char *destination, const char *source);

void test_strings(char *s1, char *s2) {
    char buffer[1024] = {0};

    strcpy(buffer, s1);
    strcat(buffer, s2);
}

struct A {
    int member;

    static void static_member(A* a, int x) {
        a->member = x;
    }

    static void static_member_without_def();
};

A* getAnInstanceOfA();

void test_static_member_functions(int int_arg, A* a_arg) {
    C c;
    c.StaticMemberFunction(10);
    C::StaticMemberFunction(10);

    A a;
    a.static_member(&a, int_arg);
    A::static_member(&a, int_arg);

    (&a)->static_member(a_arg, int_arg + 2);
    (*a_arg).static_member(&a, 99);
    a_arg->static_member(a_arg, -1);

    a.static_member_without_def();
    A::static_member_without_def();

    getAnInstanceOfA()->static_member_without_def();
}

int missingReturnValue(bool b, int x) {
    if (b) {
        return x;
    }
}

void returnVoid(int x, int y) {
    return IntegerOps(x, y);
}

void gccBinaryConditional(bool b, int x, long y) {
    int z = x;
    z = b ?: x;
    z = b ?: y;
    z = x ?: x;
    z = x ?: y;
    z = y ?: x;
    z = y ?: y;

    z = (x && b || y) ?: x;
}

bool predicateA();
bool predicateB();

int shortCircuitConditional(int x, int y) {
    return predicateA() && predicateB() ? x : y;
}

void *operator new(size_t, void *) noexcept;

void f(int* p)
{
  new (p) int;
}

template<typename T>
T defaultConstruct() {
    return T();
}

class constructor_only {
public:
    int x;

public:
    constructor_only(int x);
};

class copy_constructor {
public:
    int y;

public:
    copy_constructor();
    copy_constructor(const copy_constructor&);

    void method();
};

class destructor_only {
public:
    ~destructor_only();

    void method();
};

template<typename T>
void acceptRef(const T& v);

template<typename T>
void acceptValue(T v);

template<typename T>
T returnValue();

void temporary_string() {
    String s = returnValue<String>();  // No temporary
    const String& rs = returnValue<String>();  // Binding a reference variable to a temporary

    acceptRef(s);  // No temporary
    acceptRef<String>("foo");  // Binding a const reference to a temporary
    acceptValue(s);
    acceptValue<String>("foo");
    String().c_str();
    returnValue<String>().c_str();  // Member access on a temporary

    defaultConstruct<String>();
}

void temporary_destructor_only() {
    destructor_only d = returnValue<destructor_only>();
    const destructor_only& rd = returnValue<destructor_only>();
    destructor_only d2;
    acceptRef(d);
    acceptValue(d);
    destructor_only().method();
    returnValue<destructor_only>().method();

    defaultConstruct<destructor_only>();
}

void temporary_copy_constructor() {
    copy_constructor d = returnValue<copy_constructor>();
    const copy_constructor& rd = returnValue<copy_constructor>();
    copy_constructor d2;
    acceptRef(d);
    acceptValue(d);
    copy_constructor().method();
    returnValue<copy_constructor>().method();
    defaultConstruct<copy_constructor>();

    int y = returnValue<copy_constructor>().y;
}

void temporary_point() {
    Point p = returnValue<Point>();  // No temporary
    const Point& rp = returnValue<Point>();  // Binding a reference variable to a temporary

    acceptRef(p);  // No temporary
    acceptValue(p);
    Point().x;
    int y = returnValue<Point>().y;

    defaultConstruct<Point>();
}

struct UnusualFields {
    int& r;
    float a[10];
};

void temporary_unusual_fields() {
    const int& rx = returnValue<UnusualFields>().r;
    int x = returnValue<UnusualFields>().r;

    const float& rf = returnValue<UnusualFields>().a[3];
    float f = returnValue<UnusualFields>().a[5];
}

struct POD_Base {
    int x;

    float f() const;
};

struct POD_Middle : POD_Base {
    int y;
};

struct POD_Derived : POD_Middle {
    int z;
};

void temporary_hierarchy() {
    POD_Base b = returnValue<POD_Middle>();
    b = (returnValue<POD_Derived>());  // Multiple conversions plus parens
    int x = returnValue<POD_Derived>().x;
    float f = (returnValue<POD_Derived>()).f();
}

struct Inheritance_Test_B {
  ~Inheritance_Test_B() {}
};

struct Inheritance_Test_A : public Inheritance_Test_B {
  int x;
  int y;
  Inheritance_Test_A() : x(42) {
    y = 3;
  }
};

void array_structured_binding() {
    int xs[2] = {1, 2};
    // structured binding use
    {
        auto& [x0, x1] = xs;
        x1 = 3;
        int &rx1 = x1;
        int x = x1;
    }
    // explicit reference version
    {
        auto& unnamed_local_variable = xs;
        auto& x0 = unnamed_local_variable[0];
        auto& x1 = unnamed_local_variable[1];
        x1 = 3;
        int &rx1 = x1;
        int x = x1;
    }
}

struct StructuredBindingDataMemberMemberStruct {
    int x = 5;
};

struct StructuredBindingDataMemberStruct {
    typedef int ArrayType[2];
    typedef int &RefType;
    int i = 1;
    double d = 2.0;
    unsigned int b : 3;
    int& r = i;
    int* p = &i;
    ArrayType xs = {1, 2};
    RefType r_alt = i;
    StructuredBindingDataMemberMemberStruct m;
};

void data_member_structured_binding() {
    StructuredBindingDataMemberStruct s;
    // structured binding use
    {
        auto [i, d, b, r, p, xs, r_alt, m] = s;
        d = 4.0;
        double& rd = d;
        int v = i;
        r = 5;
        *p = 6;
        int& rr = r;
        int* pr = &r;
        int w = r;
    }
    // explicit reference version
    {
        auto unnamed_local_variable = s;
        auto& i = unnamed_local_variable.i;
        auto& d = unnamed_local_variable.d;
        // no equivalent for b
        auto& r = unnamed_local_variable.r;
        auto& p = unnamed_local_variable.p;
        d = 4.0;
        double& rd = d;
        int v = i;
        r = 5;
        *p = 6;
        int& rr = r;
        int* pr = &r;
        int w = r;
    }
}

namespace std {
    template<typename T>
    struct tuple_size;
    template<int, typename T>
    struct tuple_element;
}

struct StructuredBindingTupleRefGet {
    int i = 1;
    double d = 2.2;
    int& r = i;

    template<int i>
    typename std::tuple_element<i, StructuredBindingTupleRefGet>::type& get();
};

template<>
struct std::tuple_size<StructuredBindingTupleRefGet> {
    static const unsigned int value = 3;
};

template<>
struct std::tuple_element<0, StructuredBindingTupleRefGet> {
    using type = int;
};
template<>
struct std::tuple_element<1, StructuredBindingTupleRefGet> {
    using type = double;
};
template<>
struct std::tuple_element<2, StructuredBindingTupleRefGet> {
    using type = int&;
};

template<>
std::tuple_element<0, StructuredBindingTupleRefGet>::type& StructuredBindingTupleRefGet::get<0>() {
    return i;
}
template<>
std::tuple_element<1, StructuredBindingTupleRefGet>::type& StructuredBindingTupleRefGet::get<1>() {
    return d;
}
template<>
std::tuple_element<2, StructuredBindingTupleRefGet>::type& StructuredBindingTupleRefGet::get<2>() {
    return r;
}

void tuple_structured_binding_ref_get() {
    StructuredBindingTupleRefGet t;
    // structured binding use
    {
        auto [i, d, r] = t;
        d = 4.0;
        double& rd = d;
        int v = i;
        r = 5;
        int& rr = r;
        int w = r;
    }
    // explicit reference version
    {
        auto unnamed_local_variable = t;
        auto& i = unnamed_local_variable.get<0>();
        auto& d = unnamed_local_variable.get<1>();
        auto& r = unnamed_local_variable.get<2>();
        d = 4.0;
        double& rd = d;
        int v = i;
        r = 5;
        int& rr = r;
        int w = r;
    }
}

struct StructuredBindingTupleNoRefGet {
    int i = 1;
    int& r = i;

    template<int i>
    typename std::tuple_element<i, StructuredBindingTupleNoRefGet>::type get();
};

template<>
struct std::tuple_size<StructuredBindingTupleNoRefGet> {
    static const unsigned int value = 3;
};

template<>
struct std::tuple_element<0, StructuredBindingTupleNoRefGet> {
    using type = int;
};
template<>
struct std::tuple_element<1, StructuredBindingTupleNoRefGet> {
    using type = int&;
};
template<>
struct std::tuple_element<2, StructuredBindingTupleNoRefGet> {
    using type = int&&;
};

template<>
std::tuple_element<0, StructuredBindingTupleNoRefGet>::type StructuredBindingTupleNoRefGet::get<0>() {
    return i;
}
template<>
std::tuple_element<1, StructuredBindingTupleNoRefGet>::type StructuredBindingTupleNoRefGet::get<1>() {
    return r;
}
template<>
std::tuple_element<2, StructuredBindingTupleNoRefGet>::type StructuredBindingTupleNoRefGet::get<2>() {
    return 5;
}

void tuple_structured_binding_no_ref_get() {
    StructuredBindingTupleNoRefGet t;
    //structured binding use
    {
        auto&& [i, r, rv] = t;
        i = 4;
        int& ri = i;
        int v = i;
        r = 5;
        int& rr = r;
        int w = r;
    }
    // explicit reference version
    {
        auto&& unnamed_local_variable = t;
        auto&& i = unnamed_local_variable.get<0>();
        auto& r = unnamed_local_variable.get<1>();
        auto&& rv = unnamed_local_variable.get<2>();
        i = 4;
        int& ri = i;
        int v = i;
        r = 5;
        int& rr = r;
        int w = r;
    }
}

void array_structured_binding_non_ref_init() {
    int xs[2] = {1, 2};
    auto [x0, x1] = xs;
}

class CapturedLambdaMyObj
{
public:
    CapturedLambdaMyObj() {}
};

void captured_lambda(int x, int &y, int &&z)
{
    const auto &obj1 = CapturedLambdaMyObj();
    auto obj2 = CapturedLambdaMyObj();

    auto lambda_outer = [obj1, obj2, x, y, z](){
        auto lambda_inner = [obj1, obj2, x, y, z](){;};
    };
}

int goto_on_same_line() {
  int x = 42;
  goto next; next:
  return x;
}

class TrivialLambdaClass {
public:
    void m() const {
        auto l_m_outer = [*this] {
            m();

            auto l_m_inner = [*this] {
                m();
            };
        };
    };
};

void captured_lambda2(TrivialLambdaClass p1, TrivialLambdaClass &p2, TrivialLambdaClass &&p3) {
    const TrivialLambdaClass l1;
    const TrivialLambdaClass &l2 = TrivialLambdaClass();

    auto l_outer1 = [p1, p2, p3, l1, l2] {
        auto l_inner1 = [p1] {};
    };
}

class CopyConstructorWithImplicitArgumentClass {
    int x;
public:
    CopyConstructorWithImplicitArgumentClass() {}
    CopyConstructorWithImplicitArgumentClass(const CopyConstructorWithImplicitArgumentClass &c) {
        x = c.x;
    }
};

class CopyConstructorWithBitwiseCopyClass {
    int y;
public:
    CopyConstructorWithBitwiseCopyClass() {}
};

class CopyConstructorTestNonVirtualClass :
        public CopyConstructorWithImplicitArgumentClass,
        public CopyConstructorWithBitwiseCopyClass {
public:
    CopyConstructorTestNonVirtualClass() {}
};

class CopyConstructorTestVirtualClass :
        public virtual CopyConstructorWithImplicitArgumentClass,
        public virtual CopyConstructorWithBitwiseCopyClass {
public:
    CopyConstructorTestVirtualClass() {}
};

int implicit_copy_constructor_test(
        const CopyConstructorTestNonVirtualClass &x,
        const CopyConstructorTestVirtualClass &y) {
    CopyConstructorTestNonVirtualClass cx = x;
    CopyConstructorTestVirtualClass cy = y;
}

void if_initialization(int x) {
    if (int y = x; x + 1) {
        x = x + y;
    }

    int w;
    if (w = x; x + 1) {
        x = x + w;
    }

    if (w = x; int w2 = w) {
        x = x + w;
    }

    if (int v = x; int v2 = v) {
        x = x + v;
    }

    int z = x;
    if (z) {
        x = x + z;
    }

    if (int z2 = z) {
        x += z2;
    }
}

void switch_initialization(int x) {
    switch (int y = x; x + 1) {
    default:
        x = x + y;
    }

    int w;
    switch (w = x; x + 1) {
    default:
        x = x + w;
    }

    switch (w = x; int w2 = w) {
    default:
        x = x + w;
    }

    switch (int v = x; int v2 = v) {
    default:
        x = x + v;
    }

    int z = x;
    switch (z) {
    default:
        x = x + z;
    }

    switch (int z2 = z) {
    default:
        x += z2;
    }
}

int global_1;

int global_2 = 1;

const int global_3 = 2;

constructor_only global_4(1);

constructor_only global_5 = constructor_only(2);

char *global_string = "global string";

int global_6 = global_2;

namespace block_assignment {
    class A {
        enum {} e[1];
        virtual void f();
    };
    
    struct B : A {
        B(A *);
    };

    void foo() {
        B v(0);
        v = 0;
    }
}

void magicvars() {
    const char *pf = __PRETTY_FUNCTION__;
    const char *strfunc = __func__;
}

namespace missing_declaration_entries {
    struct S {};

    template<typename A, typename B> struct pair{};

    template<typename T> struct Bar1 {
        typedef S* pointer;

        void* missing_type_decl_entry(pointer p) {
            typedef pair<pointer, bool> _Res;
            return p;
        }
    };

    void test1() {
        Bar1<int> b;
        b.missing_type_decl_entry(nullptr);
    }

    template<typename T> struct Bar2 {

        int two_missing_variable_declaration_entries() {
            int x[10], y[10];
            *x = 10;
            *y = 10;
            return *x + *y;
        }
    };

    void test2() {
        Bar2<int> b;
        b.two_missing_variable_declaration_entries();
    }

    template<typename T> struct Bar3 {

        int two_more_missing_variable_declaration_entries() {
            extern int g;
            int z(float);
            return g;
        }
    };

    void test3() {
        Bar3<int> b;
        b.two_more_missing_variable_declaration_entries();
    }
}

template<typename T> T global_template = 42;

int test_global_template_int() {
    int local_int = global_template<int>;
    char local_char = global_template<char>;
    return local_int + (int)local_char;
}

[[noreturn]] void noreturnFunc();

int noreturnTest(int x) {
    if (x < 10) {
        return x;
    } else {
        noreturnFunc();
    }
}

int noreturnTest2(int x) {
    if (x < 10) {
        noreturnFunc();
    }
    return x;
}

int static_function(int x) {
    return x;
}

void test_static_functions_with_assignments() {
    C c;
    int x;
    x = c.StaticMemberFunction(10);
    int y;
    y = C::StaticMemberFunction(10);
    int z;
    z = static_function(10);
}

void test_double_assign() {
  int i, j;
  i = j = 40;
}

void test_assign_with_assign_operation() {
  int i, j = 0;
  i = (j += 40);
}

class D {
    static D x;

public:
    static D& ReferenceStaticMemberFunction() {
        return x;
    }
    static D ObjectStaticMemberFunction() {
        return x;
    }
};

void test_static_member_functions_with_reference_return() {
    D d;

    d.ReferenceStaticMemberFunction();
    D::ReferenceStaticMemberFunction();
    d.ObjectStaticMemberFunction();
    D::ObjectStaticMemberFunction();

    D x;
    x = d.ReferenceStaticMemberFunction();
    D y;
    y = D::ReferenceStaticMemberFunction();
    D j;
    j = d.ObjectStaticMemberFunction();
    D k;
    k = D::ObjectStaticMemberFunction();
}

void test_volatile() {
    volatile int x;
    x;
}

struct ValCat {
  static ValCat& lvalue();
  static ValCat&& xvalue();
  static ValCat prvalue();
};

void value_category_test() {
    ValCat c;

    c.lvalue() = {};
    c.xvalue() = {};
    c.prvalue() = {};
    ValCat::lvalue() = {};
    ValCat::xvalue() = {};
    ValCat::prvalue() = {};
}

void SetStaticFuncPtr() {
    C c;
    int (*pfn)(int) = C::StaticMemberFunction;
    pfn = c.StaticMemberFunction;
}

void TernaryTestInt(bool a, int x, int y, int z) {
    z = a ? x : y;
    z = a ? x : 5;
    z = a ? 3 : 5;
    (a ? x : y) = 7;
}

struct TernaryPodObj {
};

void TernaryTestPodObj(bool a, TernaryPodObj x, TernaryPodObj y, TernaryPodObj z) {
    z = a ? x : y;
    z = a ? x : TernaryPodObj();
    z = a ? TernaryPodObj() : TernaryPodObj();
    (z = a ? x : y) = TernaryPodObj();
}

struct TernaryNonPodObj {
    virtual ~TernaryNonPodObj() {}
};

void TernaryTestNonPodObj(bool a, TernaryNonPodObj x, TernaryNonPodObj y, TernaryNonPodObj z) {
    z = a ? x : y;
    z = a ? x : TernaryNonPodObj();
    z = a ? TernaryNonPodObj() : TernaryNonPodObj();
    (z = a ? x : y) = TernaryNonPodObj();
}

void CommaTestHelper(unsigned int);

unsigned int CommaTest(unsigned int x) {
  unsigned int y;
  y = x < 100 ?
    (CommaTestHelper(x), x) :
    (CommaTestHelper(x), 10);
}

void NewDeleteMem() {
  int* x = new int;  // No constructor
  *x = 6;
  delete x;
}

class Base2 {
public:
    void operator delete(void* p) {
    }
    virtual ~Base2() {};
};

class Derived2 : public Base2 {
    int i;
public:
    ~Derived2() {};

    void operator delete(void* p) {
    }
};

// Delete is kind-of virtual in these cases
int virtual_delete()
{
    Base2* b1 = new Base2{};
    delete b1;

    Base2* b2 = new Derived2{};
    delete b2;

    Derived2* d = new Derived2{};
    delete d;
}

void test_constant_folding_use(int);

void test_constant_folding() {
  const int x = 116;
  test_constant_folding_use(x);
}

void exit(int code);

int NonExit() {
    int x = Add(3,4);
    if (x == 7)
        exit(3);
    VoidFunc();
    return x;
}

void CallsNonExit() {
    VoidFunc();
    exit(3);
}

int TransNonExit() {
    int x = Add(3,4);
    if (x == 7)
        CallsNonExit();
    VoidFunc();
    return x;
}

void newArrayCorrectType(size_t n) {
  new int[n];  // No constructor
  new(1.0f) int[n];  // Placement new, no constructor
  new String[n];  // Constructor
  new Overaligned[n];  // Aligned new
  new DefaultCtorWithDefaultParam[n];
  new int[n] { 0, 1, 2 };
}

double strtod (const char* str, char** endptr);

char* test_strtod(char *s) {
  char *end;
  double d = strtod(s, &end);
  return end;
}

struct HasOperatorBool {
    operator bool();
};

void call_as_child_of_ConditionDeclExpr() {
  if(HasOperatorBool b = HasOperatorBool()) {}
}

class ClassWithDestructor {
    char *x;
public:
    ClassWithDestructor() { x = new char; }
    ~ClassWithDestructor() { delete x; }

    void set_x(char y) { *x = y; }
    char get_x() { return *x; }
    operator bool() const;
};

constexpr bool initialization_with_destructor_bool = true;

void initialization_with_destructor(bool b, char c) {
    if (ClassWithDestructor x; b)
        x.set_x('a');

    if constexpr (ClassWithDestructor x; initialization_with_destructor_bool)
        x.set_x('a');

    switch(ClassWithDestructor x; c) {
        case 'a':
          x.set_x('a');
          break;
        default:
          x.set_x('b');
          break;
    }

    ClassWithDestructor x;
    for(std::vector<ClassWithDestructor> ys(x); ClassWithDestructor y : ys)
      y.set_x('a');

    for(std::vector<ClassWithDestructor> ys(x); ClassWithDestructor y : ys) {
      y.set_x('a');
      if (y.get_x() == 'b')
        return;
    }

    for(std::vector<int> ys(1); int y : ys) {
      if (y == 1)
        return;
    }

    for(std::vector<ClassWithDestructor> ys(x); ClassWithDestructor y : ys) {
      ClassWithDestructor z1;
      ClassWithDestructor z2;
    }
}

void static_variable_with_destructor_1() {
    ClassWithDestructor a;
    static ClassWithDestructor b;
}

void static_variable_with_destructor_2() {
    static ClassWithDestructor a;
    ClassWithDestructor b;
}

void static_variable_with_destructor_3() {
    ClassWithDestructor a;
    ClassWithDestructor b;
    static ClassWithDestructor c;
}

static ClassWithDestructor global_class_with_destructor;

namespace vacuous_destructor_call {
    template<typename T>
    T& get(T& t) { return t; }

    template<typename T>
    void call_destructor(T& t) {
        get(t).~T();
    }

    void non_vacuous_destructor_call() {
        ClassWithDestructor c;
        call_destructor(c);
    }

    void vacuous_destructor_call() {
        int i;
        call_destructor(i);
    }
}

void TryCatchDestructors(bool b) {
  try {
    String s;
    if (b) {
      throw "string literal";
    }
    String s2;
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

void IfDestructors(bool b) {
    String s1;
    if(b) {
        String s2;
    } else {
        String s3;
    }
    String s4;
}

void ForDestructors() {
    char c = 'a';
    for(String s("hello"); c != 0; c = s.pop_back()) {
        String s2;
    }

    for(String s : std::vector<String>(String("hello"))) {
        String s2;
    }
    
    for(String s("hello"), s2("world"); c != 0; c = s.pop_back()) {
        c = 0;
    }
}

void IfDestructors2(bool b) {
    if(String s = String("hello"); b) {
        int x = 0;
    } else {
        int y = 0;
    }
}

class Bool {
    public:
    Bool(bool b_);
    operator bool();
    ~Bool();
};

void IfDestructors3(bool b) {
    if(Bool B = Bool(b)) {
        String s1;
    } else {
        String s2;
    }
}

void WhileLoopDestructors(bool b) {
    {
        String s;
        while(b) {
            b = false;
        }
    }

    {
        while (Bool B = Bool(b)) {
            b = false;
        }
    }
}

void VoidFunc() {}

void IfReturnDestructors(bool b) {
    String s;
    if(b) {
        return;
    }
    if(b) {
        return VoidFunc();
    }
    s;
}

int IfReturnDestructors3(bool b) {
    String s;
    if(b) {
        return 1;
    }
    return 0;
}

void VoidReturnDestructors() {
    String s;
    return VoidFunc();
}

namespace return_routine_type {
    struct HasVoidToIntFunc
    {
        void VoidToInt(int);
    };

    typedef void (HasVoidToIntFunc::*VoidToIntMemberFunc)(int);

    static VoidToIntMemberFunc GetVoidToIntFunc()
    {
        return &HasVoidToIntFunc::VoidToInt;
    }

}

int small_operation_should_not_be_constant_folded() {
    return 1 ^ 2;
}

#define BINOP2(x) (x ^ x)
#define BINOP4(x) (BINOP2(x) ^ BINOP2(x))
#define BINOP8(x) (BINOP4(x) ^ BINOP4(x))
#define BINOP16(x) (BINOP8(x) ^ BINOP8(x))
#define BINOP32(x) (BINOP16(x) ^ BINOP16(x))
#define BINOP64(x) (BINOP32(x) ^ BINOP32(x))

int large_operation_should_be_constant_folded() {
    return BINOP64(1);
}

void initialization_with_temp_destructor() {
    if (char x = ClassWithDestructor().get_x())
        x++;

    if (char x = ClassWithDestructor().get_x(); x)
        x++;

    if constexpr (char x = ClassWithDestructor().get_x(); initialization_with_destructor_bool)
        x++;

    switch(char x = ClassWithDestructor().get_x()) {
        case 'a':
          x++;
    }

    switch(char x = ClassWithDestructor().get_x(); x) {
        case 'a':
          x++;
    }

    for(char x = ClassWithDestructor().get_x(); char y : std::vector<char>(x))
        y += x;
}

void param_with_destructor_by_value(ClassWithDestructor c) {
    // The call to ~ClassWithDestructor::ClassWithDestructor() happens on the side of the caller
}

void param_with_destructor_by_pointer(ClassWithDestructor* c) {
    // No destructor call should be here
}

void param_with_destructor_by_ref(ClassWithDestructor& c) {
    // No destructor call should be here
}

void param_with_destructor_by_rref(ClassWithDestructor&& c) {
    // No destructor call should be here
}

void rethrow_with_destruction(int x) {
    ClassWithDestructor c;
    throw;
}

struct ByValueConstructor {
    ByValueConstructor(ClassWithDestructor);
};

void new_with_destructor(ClassWithDestructor a)
{
    ByValueConstructor* b = new ByValueConstructor(a);
}

namespace rvalue_conversion_with_destructor {
    struct A {
        unsigned a;
    };

    struct B
    {
        ~B();

        inline A *operator->() const;
    };

    B get();

    void test()
    {
        auto a = get()->a;
    }
}

void destructor_without_block(bool b)
{
    if (b)
      ClassWithDestructor c;

    if (b)
      ClassWithDestructor d;
    else
      ClassWithDestructor e;

    while (b)
      ClassWithDestructor f;

    for(int i = 0; i < 42; ++i)
      ClassWithDestructor g;
}

void destruction_in_switch_1(int c) {
  switch (c) {
    case 0: {
      ClassWithDestructor x;
      break;
    }
  }
}

void destruction_in_switch_2(int c) {
  switch (ClassWithDestructor y; c) {
    case 0: {
      break;
    }
    default: {
      break;
    }
  }
}

void destruction_in_switch_3(int c) {
  switch (ClassWithDestructor y; c) {
    case 0: {
      ClassWithDestructor x;
      break;
    }
    default: {
      break;
    }
  }
}

void destructor_possibly_not_handled() {
  ClassWithDestructor x;
  try {
    throw 42;
  }
  catch(char) {
  }
}

ClassWithDestructor getClassWithDestructor();

void this_inconsistency(bool b) {
  if (const ClassWithDestructor& a = getClassWithDestructor())
    ;
}

void constexpr_inconsistency(bool b) {
  if constexpr (const ClassWithDestructor& a = getClassWithDestructor(); initialization_with_destructor_bool)
    ;
}

void builtin_bitcast(unsigned long ul) {
    double d = __builtin_bit_cast(double, ul);
}

void p_points_to_x_or_y(int a, int b) {
    int x;
    int y;
    int* p;
    if (a < b) {
        p = &x;
    } else {
        p = &y;
    }
    *p = 5;
    int z = x;
    int w = y;
}

int phi_after_while() {
  int r;
  int *rP = &r;

  while(predicateA()) {
    int s = 0;
    *rP = s;
    rP = &s;
  }

  return r;
}

// This testcase will loop infinitely if the analysis attempts to propagate
// phi inputs with a non-unknown bit offset.
char *recursive_conditional_call_with_increment(char *d, bool b)
{
  if (b) {
    d = recursive_conditional_call_with_increment(d, b);
  }
  d++;
  return d;
}

struct Recursive
{
  Recursive *next;
};

static Recursive *merge(Recursive *a)
{
  Recursive *b;
  Recursive **p = &b;

  while (predicateA())
  {
    *p = a;
    p = &a->next;
  }
  
  return b;
}

void use_const_int(const int*);

void escaping_pointer(bool b)
{
  int *data;
  int l1, l2;
  if (b)
  {
    data = &l1;
  }
  else
  {
    data = &l2;
  }
  use_const_int(data);
}

using int64_t = long long;
#define NULL ((void *)0)

void *malloc(unsigned long);
void use_const_void_pointer(const void *);

static void needs_chi_for_initialize_groups()
{
  if (predicateA())
  {
    int64_t *data = (int64_t *)malloc(100);
    if (data != NULL)
    {
      data = (int64_t *)malloc(100);
    }
    use_const_void_pointer(data);
  }
  else
  {
    int64_t *data = (int64_t *)malloc(100);
    if (data != NULL)
    {
      data = (int64_t *)malloc(200);
    }
    use_const_void_pointer(data);
  }
}

void use_int(int);

static void phi_with_single_input_at_merge(bool b)
{
  int *data = nullptr;
  if(b) {
    int intBuffer = 8;
    data = &intBuffer;
  }
  use_int(*data);
}

void use(const char *fmt);

#define call_use(format) use(format)

#define twice_call_use(format) \
  do                       \
  {                        \
    call_use(format);           \
    call_use(format);           \
  } while (0)

void test(bool b)
{
  twice_call_use(b ? "" : "");
}

namespace concepts {

int requires_use() {
  int y = requires { sizeof(int) > 0; };
  return y;
}

}

void branch_on_integral_in_cpp(int x1, int x2) {
  if (x1) {}
  if(!x1) {}

  int y = !x1;
  if(y) {}
  if(!y) {}

  if(x1 && x2) {}
  if(!x1 && x2) {}
  if(x1 && !x2) {}
  if(!x1 && !x2) {}
  if(x1 || x2) {}
  if(!x1 || x2) {}
  if(x1 || !x2) {}
  if(!x1 || !x2) {}

  int x_1_and_2 = x1 && x2;
  if(x_1_and_2) {}
  if(!x_1_and_2) {}
}

struct WithBracketOperator {
  const char& operator[](int pos) const;
};

char UseBracketOperator(const WithBracketOperator x, int i) {
  return x[i];
}

// semmle-extractor-options: -std=c++20 --clang
