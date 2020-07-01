#include <string>

const char* hello() {
  std::string str("hello");
  return str.c_str();  // BAD: returning a dangling pointer.
}
