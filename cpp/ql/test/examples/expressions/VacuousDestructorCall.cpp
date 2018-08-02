template<class T>
void v(T x, T *y) {
  x.T::~T();
  y->T::~T();
}

void f(int i) {
  // An int doesn't have a destructor, but we get to call it anyway through a
  // template.
  v(i, &i);
}
