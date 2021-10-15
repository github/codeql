
// This should be error-free

template<typename> struct S {
  ~S();
  static void operator delete(void*, int);
};
template<typename T> S<T>::~S() {}
template<typename T> void S<T>::operator delete(void*, int) {}

