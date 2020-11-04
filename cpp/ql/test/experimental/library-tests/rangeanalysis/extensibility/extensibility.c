/// Adds its arguments (has custom modeling in QL)
int custom_add_function(int a, int b);

int test_extensibility_add(int x) {
  if (x >= -10 && x <= 10) {
    int result = custom_add_function(x, 100);
    return result; // 90 .. 110
  }
}

int test_overridability_sub(int x) {
  int result = x - (unsigned char)x; // Returns 0 due to custom modeling for this test being deliberately wrong
  return result; // 0
}

void test_parameter_override(int magic_name_at_most_10, int magic_name_at_most_20) {
  magic_name_at_most_10;
  magic_name_at_most_20;
}
