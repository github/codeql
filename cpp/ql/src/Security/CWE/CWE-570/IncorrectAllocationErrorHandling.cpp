// BAD: the allocation will throw an unhandled exception
// instead of returning a null pointer.
void bad1(std::size_t length) noexcept {
  int* dest = new int[length];
  if(!dest) {
    return;
  }
  std::memset(dest, 0, length);
  // ...
}

// BAD: the allocation won't throw an exception, but
// instead return a null pointer.
void bad2(std::size_t length) noexcept {
  try {
    int* dest = new(std::nothrow) int[length];
    std::memset(dest, 0, length);
    // ...
  } catch(std::bad_alloc&) {
    // ...
  }
}

// GOOD: the allocation failure is handled appropriately.
void good1(std::size_t length) noexcept {
  try {
    int* dest = new int[length];
    std::memset(dest, 0, length);
    // ...
  } catch(std::bad_alloc&) {
    // ...
  }
}

// GOOD: the allocation failure is handled appropriately.
void good2(std::size_t length) noexcept {
  int* dest = new int[length];
  if(!dest) {
    return;
  }
  std::memset(dest, 0, length);
  // ...
}
