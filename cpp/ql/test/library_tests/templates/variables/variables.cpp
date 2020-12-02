template<typename T>
constexpr T pi = T(3.141592653589793238462643383);

template<>
constexpr const char* pi<const char*> = "pi";

template<typename S, typename T>
constexpr S multi_arg = T(1) + S(2);

template<typename T>
T mutable_val = T(7);

struct Foo {
  template<typename T>
  static T bar;
};

template<typename T>
T Foo::bar = T(0);

int no_template = 9;

template<typename T>
void access_generically(T val) {
  T pi_t = pi<T>;
  mutable_val<T> = val;
  Foo::bar<T> = val;
  no_template = 123;
}

template<typename S, typename T>
void access_generically_multi() {
  S multi_arg_s = multi_arg<S, T>;
}

void access_concretely() {
  float pi_f = pi<float>;
  int   pi_i = pi<int>;

  float multi_arg_a = multi_arg<unsigned int, unsigned char>;
  int   multi_arg_b = multi_arg<int, char>;

  mutable_val<int> = 8;
  mutable_val<long> = 9;

  Foo::bar<short> = 1;
  Foo::bar<double> = 3.14;

  no_template = 234;
}

int main() {
  access_generically<float>(1.0f);
  access_generically<int>(1);
  access_generically_multi<short, long>();
  access_generically_multi<float, char>();
  access_concretely();
}
