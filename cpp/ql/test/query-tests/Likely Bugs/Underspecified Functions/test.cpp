void cpp_varargs(...);
void bar();

void test() {
  cpp_varargs(); // GOOD
  cpp_varargs(1); // GOOD
  __builtin_constant_p("something"); // GOOD: builtin
  
  // The following is marked "good" since we are not supposed
  // to analyze C++ files.
}