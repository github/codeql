namespace std {
  template<class T> T&& move(T& t) noexcept; // simplified signature
}

struct Base { int x; };
struct Derived : Base { int y; };

int accept_base(Base &base);

struct ContainsDerived {
    Derived d_;

    int f() {
        return accept_base(d_);
    }
};

void accept_int_rvref(int &&rvref);
void accept_intptr_const_lvref(int *const &rvref);
void accept_intptr_rvref(int *&&rvref);

void call_with_int_rvref() {
    int i;
    accept_int_rvref(std::move(i));
    accept_intptr_rvref(&i);
    accept_intptr_const_lvref(&i);
}

void accept_address(int *ptr);

void pass_address(int i) {
  accept_address(&i);

  accept_address(i ? &i : nullptr);
  accept_address(&*&*&i);
  accept_address(&(++i));
  accept_address(&(i |= 1));
  accept_address(&(i += 1) + 1);

  int &iref = i;
  // This takes the address of `i`, not `iref`.
  accept_address(&iref);
}


int lambdas(int captured) {
  auto f1 = [&] { captured++; }; // capture has location "file://:0:0:0:0"
  f1();
  auto f2 = [&captured] { captured++; };
  f2();
  return captured;
}


void arrays(int i) {
  int a[8] = { i, i+1, i+2 };
  accept_address(&a[0] + sizeof(a)/sizeof(*a));
  accept_address(a);
}

void nonexamples(int *ptr, int &ref) {
  if (--(*ptr) == 0) {
    nonexamples(&*ptr, ref);
  }
}


namespace std {
  template<typename T>
  constexpr T *addressof(T &obj) noexcept {
    return __builtin_addressof(obj);
  }
}

void use_std_addressof() {
  int x = 0;
  int *y = std::addressof(x) + *std::addressof(x);
}

// semmle-extractor-options: --clang
