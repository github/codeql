// semmle-extractor-options: --expect_errors
template <typename T>
void report_type_via_error(T&& t) {
  static_assert(sizeof(T) == 0, "");
}

static void foo() {
  int i;
  double d;
  report_type_via_error(i);
  report_type_via_error(d);
}

