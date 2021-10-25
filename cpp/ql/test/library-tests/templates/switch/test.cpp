
// A regression test for a bug extracting the enum constants in a template
// class.

template <class>
class C {
  enum { foo, bar, baz } delim;
  void f();
};

template <class T>
void C<T>::f() {
  switch (delim) {
    case bar:
      break;
    case baz:
      break;
    case foo:
      break;
  }
}

template class C<int>;
