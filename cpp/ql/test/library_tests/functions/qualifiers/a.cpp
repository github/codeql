
// This example highlighted a bug in extracting routine type qualifiers.

template <typename A, typename B>
struct S {
  void f(A (B::*)() const);
};

