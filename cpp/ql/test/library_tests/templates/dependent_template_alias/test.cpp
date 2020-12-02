
template <typename>
using Z = int;

template <typename T, typename U = int>
struct Thing {
  int x;
};

template <typename T>
struct Thing<T, Z<typename T::Undefined>> {
  int y;
};

// Note that float::Undefined is an error, so this should match the primary
// template, not the partial specialization.
Thing<float> thing_float;

void f() {
  // If we incorrectly matched the partial specialization, this write to x would
  // be an error.
  thing_float.x = 1;
}

// Now, a type that actually does define Undefined
struct S {
  using Undefined = int;
};

// S::Undefined is okay, so this should match the partial specialization.
Thing<S> thing_s;

void g() {
  // If we incorrectly matched the primary template, this write to y would be an
  // error.
  thing_s.y = 1;
}
