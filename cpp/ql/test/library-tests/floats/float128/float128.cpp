typedef _Complex float __attribute__((mode(TC))) _Complex128; // [COMPILER ERROR AND ERROR-TYPE DUE TO __float128 BEING DISABLED]
typedef float __attribute__((mode(TF))) _Float128; // [COMPILER ERROR AND ERROR-TYPE DUE TO __float128 BEING DISABLED]

int main() {
  __float128 f = 1.0f;
  __float128 g = 2.0f;
  float h = f + g;
}

struct false_type {enum {value = 0};};
struct true_type {enum {value = 1};};

template<typename T> struct __is_floating_point_helper : public false_type { };
template<> struct __is_floating_point_helper<float> : public true_type { };
template<> struct __is_floating_point_helper<double> : public true_type { };
template<> struct __is_floating_point_helper<long double> : public true_type { };
template<> struct __is_floating_point_helper<__float128> : public true_type { };

long double id(long double d)
{
  return d;
}

__float128 id(__float128 q)
{
  return q;
}
// semmle-extractor-options: --expect_errors
