// BAD: on memory allocation error, the program terminates.
void badFunction(const int *source, std::size_t length) noexcept {
  int * dest = new int[length];
  std::memset(dest, 0, length);
// ..
}
// GOOD: memory allocation error will be handled.
void goodFunction(const int *source, std::size_t length) noexcept {
  try {
       int * dest = new int[length];
  } catch(std::bad_alloc) {
    // ...
  }
  std::memset(dest, 0, length);
// ..
}
// BAD: memory allocation error will not be handled.
void badFunction(const int *source, std::size_t length) noexcept {
  try {
       int * dest = new (std::nothrow) int[length];
  } catch(std::bad_alloc) {
    // ...
  }
  std::memset(dest, 0, length);
// ..
}
// GOOD: memory allocation error will be handled.
void goodFunction(const int *source, std::size_t length) noexcept {
  int * dest = new (std::nothrow) int[length];
  if (!dest) {
      return;
  }
  std::memset(dest, 0, length);
// ..
}
