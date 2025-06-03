template<typename Ty>
class Cl {
  // Foo
  void foo(void) {
  }

  // Bar
  template<class Ar>
  void bar(void) {
  }
};


template <typename T>
class Derived : public T {
  // using T::member
  using T::member;

  // using T::nested::member
  using T::nested::member;
};

template <typename T>
class Base {
  // using T::member
  using T::member;
};