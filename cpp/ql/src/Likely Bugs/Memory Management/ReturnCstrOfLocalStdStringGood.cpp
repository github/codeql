#include <string>

std::string hello() {
  std::string str("hello");
  return str;  // GOOD: returning a std::string is safe.
}
