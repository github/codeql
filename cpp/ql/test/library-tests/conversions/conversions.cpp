typedef unsigned short ushort;

enum E {
  E0,
  E1
};

enum class EC : int {
  EC0,
  EC1
};

void ArithmeticConversions() {
  char c = 0;
  unsigned char uc = 0;
  short s = 0;
  unsigned short us = 0;
  int i = 0;
  unsigned int ui = 0;
  long l = 0;
  unsigned long ul = 0;
  long long ll = 0;
  unsigned long long ull = 0;
  float f = 0;
  double d = 0;
  wchar_t wc = 0;
  E e{};
  EC ec{};

  c = uc;
  c = (char)uc;
  c = char(uc);
  c = static_cast<char>(uc);
  i = s;
  i = (int)s;
  i = int(s);
  i = static_cast<int>(s);
  us = i;
  us = (unsigned short)i;
  us = ushort(i);
  us = static_cast<unsigned short>(i);

  i = d;
  i = (int)d;
  i = int(d);
  i = static_cast<int>(d);

  f = c;
  f = (float)c;
  f = float(c);
  f = static_cast<float>(c);

  f = d;
  f = (float)d;
  f = float(d);
  f = static_cast<float>(d);

  d = f;
  d = (double)f;
  d = double(f);
  d = static_cast<double>(f);

  i = E0;
  i = e;
  i = static_cast<int>(EC::EC0);
  i = static_cast<int>(ec);
  e = static_cast<E>(i);
  ec = static_cast<EC>(i);
}

struct S {
  int x;
  double y;
};

void ConversionsToBool() {
  bool b = 0;
  int i = 0;
  double d = 0;
  void* p = nullptr;
  int S::* pmd = nullptr;

  if (b) {
  }
  else if ((bool)b) {
  }
  else if (i) {
  }
  else if (d) {
  }
  else if (p) {
  }
  else if (pmd) {
  }
}

struct Base {
  int b1;
  void BaseMethod();
};

struct Middle : Base {
  int m1;
  void MiddleMethod();
};

struct Derived : Middle {
  int d1;
  void DerivedMethod();
};

void HierarchyCasts() {
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
}

void PTMCasts() {
  int Base::* pb = &Base::b1;
  void (Base::* pmfb)() = &Base::BaseMethod;
  int Middle::* pm = &Middle::m1;
  void (Middle::* pmfm)() = &Middle::MiddleMethod;
  int Derived::* pd = &Derived::d1;
  void (Derived::* pmfd)() = &Derived::DerivedMethod;

  pb = (int Base::*)pm;
  pmfb = (void (Base::*)())pmfm;
  pb = static_cast<int Base::*>(pm);
  pmfb = static_cast<void (Base::*)()>(pmfm);

  pm = pb;
  pmfm = pmfb;
  pm = (int Middle::*)pb;
  pmfm = (void (Middle::*)())pmfb;
  pm = static_cast<int Middle::*>(pb);
  pmfm = static_cast<void (Middle::*)()>(pmfb);

  pb = (int Base::*)pd;
  pmfb = (void (Base::*)())pmfd;
  pb = static_cast<int Base::*>(pd);
  pmfb = static_cast<void (Base::*)()>(pmfd);

  pd = pb;
  pmfd = pmfb;
  pd = (int Derived::*)pb;
  pmfd = (void (Derived::*)())pmfb;
  pd = static_cast<int Derived::*>(pb);
  pmfd = static_cast<void (Derived::*)()>(pmfb);
}

struct String {
  String();
  String(const String&);
  ~String();
};

void Adjust() {
  const String& s1 = String();  // prvalue adjustment
  Base b;
  Derived d;
  const Base& rb = true ? b : d;  // glvalue adjustment
  const Base& r = (Base&)s1;
}

void QualificationConversions() {
  const int* pc = nullptr;
  const volatile int* pcv = nullptr;
  pcv = pc;
  pc = const_cast<const int*>(pcv);
}

void PointerIntegralConversions() {
  void* p = nullptr;
  long n = (long)p;
  n = reinterpret_cast<long>(p);
  p = (void*)n;
  p = reinterpret_cast<void*>(n);
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

  // These two casts were previously represented as BaseClassCasts because they were resolved at compile time, but the front-end no longer performs this optimization.
  pb = dynamic_cast<PolymorphicBase*>(pd);
  PolymorphicBase& rb = dynamic_cast<PolymorphicBase&>(d);

  pd = dynamic_cast<PolymorphicDerived*>(pb);
  PolymorphicDerived& rd = dynamic_cast<PolymorphicDerived&>(b);
}

void FuncPtrConversions(int(*pfn)(int), void* p) {
  p = (void*)pfn;
  pfn = (int(*)(int))p;
}

int Func();

void ConversionsToVoid() {
  int x;
  (void)x;
  static_cast<void>(x);
  (void)Func();
  static_cast<void>(Func());
  (void)1;
  static_cast<void>(1);
}

