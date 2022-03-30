// The ASM statements are
// causing problems, because our SSA analysis does not notice that they
// might change the value of `x`. This was a latent bug that came out
// of the woodwork when we added support for statement expressions.

int printf(const char *format, ...);

int main() {
  unsigned int x = 0, y;
  y = 1;

  printf("x = %i y = %i\n", x, y); // 0, 1

  // exchange x and y
  asm volatile ( "xchg %0, %1\n"
                : "+r" (x), "+a" (y) // outputs (x and y)
                :
                :
                );

  printf("x = %i y = %i\n", x, y); // 1, 0 (but without analysing the ASM: unknown, unknown)

  return 0;
}
