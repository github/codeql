void c_api(const char*);

void bad_call_c_api() {
  // BAD: the memory returned by `c_str()` is freed when the temporary string is destroyed
  const char* p = std::string("hello").c_str();
  c_api(p);
}

void good_call_c_api() {
  // GOOD: the "hello" string outlives the pointer returned by `c_str()`, so it's safe to pass it to `c_api()`
  std::string hello("hello");
  const char* p = hello.c_str();
  c_api(p);
}
