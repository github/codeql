long f(int a, int b, int c) {
  // A builtin from the builtin_functions_file.
  int i1 = __builtin_foobar(a);

  // A builtin that's not in the file, but the extractor should handle, given the
  // --gnu_version flag we pass in.
  int i2;
  __builtin_add_overflow(a, b, &i2);

  // A builtin that would normally be defined by the extractor with a type
  // expecting it to be called like this:
  //void* x = __builtin_malloc(a);
  // But we override the type in the builtin_functions_file so it's called like
  // this:
  float f1, f2;
  f1 = __builtin_malloc(a, b, c, &f2);

  return 42;
}
// semmle-extractor-options: --gnu_version 50100 --edg --builtin_functions_file --edg ${testdir}/builtins.txt
