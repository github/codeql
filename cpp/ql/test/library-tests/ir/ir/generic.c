#define describe(val) \
  _Generic((val), \
    int: "int", \
    default: "unknown" \
  )

const char *c11_generic()
{
  int i;

  return describe(i);
}

// semmle-extractor-options: -std=c11