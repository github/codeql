enum numbers {
  zero, one
};

static int is_one(int x) {
  switch(x) {
    case one: return one;
    default: return zero;
  }
}
// semmle-extractor-options: --microsoft
