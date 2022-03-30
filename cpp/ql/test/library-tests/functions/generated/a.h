struct Base {
  Base() {}
  ~Base() {}
};

struct A : Base {
  /* Because of Base() and ~Base(), the extractor generates A() and ~A() here, but it
   * only generates them on-demand, and they don't appear in the source sequence list.
   */
};
