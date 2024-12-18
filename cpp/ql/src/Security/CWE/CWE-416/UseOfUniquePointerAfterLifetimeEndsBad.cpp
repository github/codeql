#include <memory>
std::unique_ptr<T> getUniquePointer();
void work(const T*);

// BAD: the unique pointer is deallocated when `get` returns. So `work`
// is given a pointer to invalid memory.
void work_with_unique_ptr_bad() {
  const T* combined_string = getUniquePointer().get();
  work(combined_string);
}