
class F {
    public:
};

typedef int (F::* FMethod) (int prefix);
typedef int F::* FData;

struct piecewise_construct_t {
};

struct index {
};

class tuple {
};

template<unsigned long __i, typename... _Elements>
  void get(tuple __t);

template<class T>
struct S {
  T second;

  S(piecewise_construct_t, tuple __second) : S(__second, index()) {
  }

  template<unsigned long... uls>
  S(tuple t, index) : second(get<uls>(t)...) {
  }
};

void f() {
    S<FMethod>* x;
    x = new S<FMethod>(piecewise_construct_t(), tuple());
}

void g() {
    S<FData>* x;
    x = new S<FData>(piecewise_construct_t(), tuple());
}

