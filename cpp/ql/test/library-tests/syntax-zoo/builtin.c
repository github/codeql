// semmle-extractor-options: --clang --clang_version 30500

#define vector(elcount, type)  __attribute__((vector_size((elcount)*sizeof(type)))) type

int builtin(int x, int y) {
  int acc;

  acc += __builtin_choose_expr(0, x+0, y);

  __builtin_assume(x != 42);

  acc += (int)__builtin_readcyclecounter();

  vector(4, int) vec = { 0, 1, 2, 3 };
  vector(4, int) vec2 = __builtin_shufflevector(vec, vec, 3+0, 2, 1, 0);

  // Clang extension causes trap import errors, at least in 1.18
  (void)__builtin_convertvector(vec, short __attribute__((__vector_size__(8))));

  acc += __builtin_bitreverse32(x+0);
  acc += __builtin_rotateleft32(x+1, y);
  acc += __builtin_rotateright32(x+1, y);

  if (y == 42) {
    __builtin_unreachable();
  }

  if (__builtin_unpredictable(acc == 1)) {
    return acc;
  }

  static int staticint = 0;

  acc += __sync_swap(&staticint, x);

  // There's a whole class of "Multiprecision Arithmetic Builtins" in Clang.
  // This is just one example.
  unsigned int carry_out;
  acc += __builtin_addc(x+0, y, 1, &carry_out);

  // There's a whole class of "Checked Arithmetic Builtins" in Clang. This is
  // just one example.
  __builtin_add_overflow(x+1, (long)y, &staticint);

  acc += __builtin_canonicalize(0.7 + 0.7);

  if (__builtin_memchr("Hello", 'e', 5)) {
	acc++;
  }

  acc += __atomic_fetch_min(&staticint, x+y, 0);

  static _Atomic int atomic_int;
  acc += __c11_atomic_load(&atomic_int, 0);

  return acc;
}
