namespace staticlocals {

int g() {
    return 1;
}

int h() {
    return 1;
}

void f() {
    static int i = g(), j = h();
    static int k = g();
    ;
}

constexpr int addOne(int x) {
  return x + 1;
}

struct C {
  constexpr C() { }
};

void f2() {
    constexpr int two = 2;
    static int i = addOne(two);
    static int j = addOne(2);
    static C c{};
}

template<typename T>
struct Sizeof {
  enum sizeof_enum { value = sizeof(T) };
};

template<typename T>
void f3() {
  static int i = Sizeof<T>::value;
}

template void f3<int>();

}
