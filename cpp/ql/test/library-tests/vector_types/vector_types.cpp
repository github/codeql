// semmle-extractor-options: --edg --clang --edg --clang_version --edg 30801
// Compilable with: clang --std=c++0x -msse4.1 vector_types.cpp
// (some bits also compilable with gcc)
int printf(...);

typedef float v4f __attribute__((vector_size(16)));
typedef char v16c __attribute__((vector_size(16)));

v4f rotate_left(v4f x) {
  // NB: Vector indexing is valid in GCC since 4.6.0
  return (v4f){ x[1], x[2], x[3], x[0] };
}

v4f cmp_eq_b(v4f lhs, v4f rhs)
{
  return (v4f)(((v16c)lhs) == ((v16c)rhs));
}

v4f cmp_lt_f(v4f lhs, v4f rhs)
{
  return lhs < rhs;
}

int main() {
  float values[] = {10.f, 20.f, 30.f, 40.f};
  auto v1 = *(v4f*)values;
  auto v2 = __builtin_ia32_dpps(v1, v1, 0xF1);
  __builtin_ia32_storeups(values, v2);
  printf("The dot product is %f\n", values[0]);
#if defined(__has_builtin) && __has_builtin(__builtin_shufflevector)
  auto v3 = __builtin_shufflevector(v1, v2, 3, 4);
  auto v4 = (double __attribute__((vector_size(16)))){ v3[0], v3[1] };
  auto v5 = __builtin_ia32_haddpd(v4, v4);
  double doubles[2];
  __builtin_ia32_storeupd(doubles, v5);
  printf("and 40 more is %f\n", doubles[1]);
#endif
  return 0;
}

v4f lax(v16c arg) {
  return arg;
}

typedef int v16i __attribute__((vector_size(16)));

void shift_left(v16i *dst, v16i *src, int n) {
  // We represent this shift as an operation on vector types, and the
  // right-hand side is a vector fill expression (i.e. a vector filled with n in
  // each element).
  *dst = *src << n;
}

typedef double vector4double __attribute__((__vector_size__(32)));
typedef float  vector4float  __attribute__((__vector_size__(16)));

vector4double convert_vector(vector4float vf) {
  return __builtin_convertvector(vf, vector4double);
}
