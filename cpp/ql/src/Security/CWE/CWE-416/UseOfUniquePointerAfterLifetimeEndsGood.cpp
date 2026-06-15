#include <memory>
std::unique_ptr<T> getUniquePointer();
void work(const T*);

// GOOD: the unique pointer outlives the call to `work`. So the pointer
// obtainted from `get` is valid.
void work_with_unique_ptr_good() {
  auto combined_string = getUniquePointer();
  work(combined_string.get());
}