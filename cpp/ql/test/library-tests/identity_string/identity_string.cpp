// semmle-extractor-options: -std=c++17

template<typename T>
void check_type(const char* expected);
template<typename TFunc>
void check_func(TFunc func, const char* expected);
template<typename TVar>
void check_var(TVar var, const char* expected);

struct S
{
  enum NestedEnum
  {
    Blah,
    Bluh
  };

  int i;
  float f;
};

struct T
{
  bool b;
};

enum E
{
  One,
  Two,
  Three
};

void checks()
{
  // Primitive types
  check_type<char>("char");
  check_type<unsigned char>("unsigned char");
  check_type<signed char>("signed char");
  check_type<signed short>("short");
  check_type<short>("short");
  check_type<unsigned short>("unsigned short");
  check_type<int>("int");
  check_type<signed int>("int");
  check_type<unsigned int>("unsigned int");
  check_type<long>("long");
  check_type<signed long>("long");
  check_type<unsigned long>("unsigned long");
  check_type<long long>("long long");
  check_type<signed long long>("long long");
  check_type<unsigned long long>("unsigned long long");
  check_type<float>("float");
  check_type<double>("double");
  check_type<long double>("long double");
  check_type<bool>("bool");
  check_type<wchar_t>("wchar_t");
  check_type<char16_t>("char16_t");
  check_type<char32_t>("char32_t");
  check_type<void>("void");
  check_type<decltype(nullptr)>("decltype(nullptr)");

  check_type<const char>("char const");
  check_type<volatile short>("short volatile");
  check_type<const volatile int>("int const volatile");
  check_type<volatile long const>("long const volatile");

  // Pointers and references
  check_type<int*>("int*");
  check_type<int**>("int**");
  check_type<int&>("int&");
  check_type<int&&>("int&&");
  check_type<int**&&>("int**&&");

  // Qualifiers
  check_type<const int*>("int const*");
  check_type<int* const>("int* const");
  check_type<volatile float const* volatile>("float const volatile* volatile");
  check_type<volatile char32_t &&>("char32_t volatile&&");

  // Arrays
  check_type<int[]>("int[]");
  check_type<int[10]>("int[10]");
  check_type<int[5][10]>("int[5][10]");
  check_type<int[][7]>("int[][7]");

  // Functions
  check_type<int(float)>("int(float)");
  check_type<int(*)(float, double)>("int(*)(float, double)");
  check_type<int(**)(float, double, ...)>("int(**)(float, double, ...)");
  check_type<int(&)(float, double)>("int(&)(float, double)");
  check_type<int(*&)(float, double)>("int(*&)(float, double)");
  check_type<auto(float, double) -> int>("int(float, double)");
  check_type<auto (*)(float) -> auto (*)(double) -> int>("int(*(*)(float))(double)");
  check_type<int(*(*)(float))(double)>("int(*(*)(float))(double)");
  check_type<int(*(float))(double)>("int(*(float))(double)");

  // Pointers-to-member
  check_type<int S::*>("int S::*");
  check_type<const int S::* volatile>("int const S::* volatile");
  check_type<float* (*)(double)>("float*(*)(double)");
  check_type<float* (S::*)(double)>("float* (S::*)(double)");
  check_type<float* (S::*)(double) const>("float* (S::*)(double) const");
  typedef int (S::* PMF_S)(float) volatile;
  typedef PMF_S(T::* PMF_T)(double) const;
  check_type<PMF_T>("int (S::* (T::*)(double) const)(float) volatile");
  check_type<int (S::*(T::*)(double) const)(float) volatile>("int (S::* (T::*)(double) const)(float) volatile");
  check_type<int S::* T::*>("int S::* T::*");
  check_type<const bool(S::* volatile)[10]>("bool const (S::* volatile)[10]");
  check_type<const bool S::* volatile[10]>("bool const S::* volatile[10]");

  // Complicated stuff
  typedef int Int10[10];
  check_type<int(*)[10]>("int(*)[10]");
  check_type<Int10*>("int(*)[10]");

  typedef int FuncA(float, double);
  typedef FuncA* FuncB(wchar_t);
  check_type<FuncB*&>("int(*(*&)(wchar_t))(float, double)");
  check_type<int(*(*&)(wchar_t))(float, double)>("int(*(*&)(wchar_t))(float, double)");

  typedef const int CI;
  typedef volatile CI VCI;
  typedef volatile int VI;
  typedef const VI CVI;
  check_type<CI>("int const");
  check_type<VCI>("int const volatile");
  check_type<VI>("int volatile");
  check_type<CVI>("int const volatile");
  check_type<const CI>("int const");

  typedef int AI[10];
  typedef const AI CAI;
  check_type<AI>("int[10]");
  check_type<CAI>("int const[10]");
  check_type<int const[10]>("int const[10]");

  check_type<E>("E");
  check_type<S::NestedEnum>("S::NestedEnum");
}

int globalVariable;

int globalFunc(float x);

int overloadedGlobalFunc(float x);

float overloadedGlobalFunc(int x);

template<typename T>
T variableTemplate;

auto vt = &variableTemplate<bool>;

namespace Outer {
  namespace Inner {
    template<typename T, typename U>
    int globalFunctionTemplate(T t, U u) {
      class LocalClass {
      public:
        T x;
        void MemberFuncOfLocalClass() { }
      };

      check_func(&LocalClass::MemberFuncOfLocalClass, "void (int Outer::Inner::globalFunctionTemplate<long, double>(long, double))::LocalClass::MemberFuncOfLocalClass()");

      {
        class LocalClassInBlock {
        public:
          U x;
          void MemberFuncOfLocalClassInBlock() { }
        };

        check_func(&LocalClassInBlock::MemberFuncOfLocalClassInBlock, "void (int Outer::Inner::globalFunctionTemplate<long, double>(long, double))::LocalClassInBlock::MemberFuncOfLocalClassInBlock()");
      }

      auto l = [](int x) { 
        struct LocalClassInLambda {
          void MemberFuncOfLocalClassInLambda() { }
        };
        check_func(&LocalClassInLambda::MemberFuncOfLocalClassInLambda, "void (int (int Outer::Inner::globalFunctionTemplate<long, double>(long, double))::(lambda [] type at line ?, col. ?)::operator()(int) const)::LocalClassInLambda::MemberFuncOfLocalClassInLambda()");
        return x; 
      };
      return 0;
    }
  }
}

struct GlobalStruct {
  int f;
  static float s[156];

  GlobalStruct MemberFunc(wchar_t);
  const GlobalStruct ConstMemberFunc(char) const;
  GlobalStruct volatile VolatileMemberFunc(char16_t) volatile;
  volatile GlobalStruct const ConstVolatileMemberFunc(char32_t) volatile const;

  static bool& StaticMemberFunc(float);
};

template<typename T, typename U>
struct ClassTemplate {
  T f;
  U g;
};

void sym_checks() {
  check_func(globalFunc, "int globalFunc(float)");
  check_func(static_cast<int (&)(float)>(overloadedGlobalFunc), "int overloadedGlobalFunc(float)");
  check_func(static_cast<float (&)(int)>(overloadedGlobalFunc), "float overloadedGlobalFunc(int)");
  check_func(Outer::Inner::globalFunctionTemplate<long, double>, "int Outer::Inner::globalFunctionTemplate<long, double>(long, double)");
  check_func(GlobalStruct::StaticMemberFunc, "bool& GlobalStruct::StaticMemberFunc(float)");
  check_func(&GlobalStruct::MemberFunc, "GlobalStruct GlobalStruct::MemberFunc(wchar_t)");
  check_func(&GlobalStruct::ConstMemberFunc, "GlobalStruct const GlobalStruct::ConstMemberFunc(char) const");
  check_func(&GlobalStruct::VolatileMemberFunc, "GlobalStruct volatile GlobalStruct::VolatileMemberFunc(char16_t) volatile");
  check_func(&GlobalStruct::ConstVolatileMemberFunc, "GlobalStruct const volatile GlobalStruct::ConstVolatileMemberFunc(char32_t) const volatile");

  check_var(globalVariable, "int globalVariable");
  check_var(variableTemplate<long double>, "long double variableTemplate<long double>");
  check_var(&GlobalStruct::f, "int GlobalStruct::f");
  check_var(GlobalStruct::s, "float GlobalStruct::s[156]");
  check_var(&ClassTemplate<short, signed char>::g, "signed char ClassTemplate<short, signed char>::g");
}
