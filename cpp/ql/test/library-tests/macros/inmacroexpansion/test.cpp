
#define CLASS_DECL class S{int i; void f(void) { int j; return; } };

CLASS_DECL

#define FUNCTION_DECL void f1() { int k; }

FUNCTION_DECL

#define VARIABLE_DECL int v1 = 1;

VARIABLE_DECL

#define TYPE_DECL_1 typedef int t1;

TYPE_DECL_1

#define TYPE_DECL_2 using t2 = int;

TYPE_DECL_2

#define NAMESPACE_DECL namespace ns { int v2; }

NAMESPACE_DECL

#define USING_NAMESPACE using namespace ns;

#define ENUM_CONSTANT enum_element

enum class enum_class { ENUM_CONSTANT };

#define USING_ENUM using enum enum_class;

USING_ENUM

#define STATIC_ASSERT static_assert(1 == 1, "");

STATIC_ASSERT

#define ATTRIBUTE [[nodiscard("reason1")]]

ATTRIBUTE
int f2();

#define ATTRIBUTE_ARG "reason2"

[[nodiscard(ATTRIBUTE_ARG)]]
int f3();

#define TYPE int

TYPE v3 = 1;

#define DERIVATION : public S

class T DERIVATION {};

#define FRIEND friend int f3();

class U {
  FRIEND
};

#define NAME_QUAL_1 ns::

#define NAME_QUAL_2 ns

#define LOCAL_VAR m

void f4() {
    NAME_QUAL_1 v2;
    NAME_QUAL_2 :: v2;
    int LOCAL_VAR = 42;
    auto l = [LOCAL_VAR]() { return m; };
    l();
}

#define ID(x) x
#define NESTED(x) ID(x)
int v4 = NESTED(1);

// semmle-extractor-options: -std=c++20
