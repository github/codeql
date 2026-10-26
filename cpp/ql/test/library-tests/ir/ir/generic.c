void c11_generic_test_with_load(unsigned int x, int y) {
  unsigned int r;
  r = _Generic(r, unsigned int: x, int: y) + 1;
}

#define describe(val) \
  _Generic((val), \
    int: "int", \
    default: "unknown" \
  )

const char *c11_generic_test_with_constant_and_macro()
{
  int i;

  return describe(i);
}

const char *c11_generic_test_with_constant_and_no_macro()
{
  int i;

  return _Generic(i, int: "int", default: "unknown");
}

void c11_generic_test_test_with_cast(int y) {
  unsigned int r;
  r = _Generic(r, unsigned int: (unsigned int)y, int: y);
}

// semmle-extractor-options: -std=c11
