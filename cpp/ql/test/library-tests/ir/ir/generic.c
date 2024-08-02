#define describe(val) \
  _Generic((val), \
    int: "int", \
    default: "unknown" \
  )

const char *c11_generic_1()
{
  int i;

  return describe(i);
}

void enk_c11_generic_2(unsigned int x, int y) {
  unsigned int r;
  r = _Generic(r, unsigned int: x, int: y) + 1;

  unsigned int s;
  s = x + 1;
}

// semmle-extractor-options: -std=c11
