// semmle-extractor-options: --edg --c++17

template<typename ...Args>
int sum(Args&&... args) {
  return (args + ...);
}

template<typename ...Args>
int product(Args&&... args) {
  return (... * args);
}

template<typename ...Args>
bool all(Args&&... args) {
  return (args && ... && true);
}

template<typename ...Args>
bool any(Args&&... args) {
  return (false || ... || args);
}

void f() {
  int x = sum(1, 2, 3, 4, 5);
  int y = product(2, 4, 6, 8);
  bool a = all(true, true, false, true);
  bool b = any(false, true, false, false);
}
