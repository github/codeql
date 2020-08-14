/// Adds its arguments (requires custom modeling in QL)
int custom_add_function(int a, int b);

int test_extensibility_add(int x) {
  if (x >= -10 && x <= 10) {
    int result = custom_add_function(x, 100);
    return result; // should be 90 .. 110
  }
}
