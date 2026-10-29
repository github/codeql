
template<int n1>
void fn1(void) {
    int i = n1;
}

template<int n2>
void fn2(void) {
    int i = n2;
}

void fn2call(void) {
    fn2<5>();
}

template<typename T3>
void fn3(void) {
    T3 i = 1;
}

template<typename T4>
void fn4(void) {
    T4 i = 1;
}

void fn4call(void) {
    fn4<unsigned int>();
}

template<typename TX1>
class clX {
    typedef int TX3;
    void f(TX3 m);
};

template<typename TX2>
void clX<TX2>::f(TX3 n) {
}

template <template <typename T> class Tmpl>
struct TemplateSel {
  template <typename T>
  struct Bind {
    typedef Tmpl<T> type;
  };
};

