template<class T>
void CallDestructor(T x, T *y) {
  x.T::~T();
  y->T::~T();
}

void Vacuous(int i) {
  // An int doesn't have a destructor, but we get to call it anyway through a
  // template.
  CallDestructor(i, &i);
}
