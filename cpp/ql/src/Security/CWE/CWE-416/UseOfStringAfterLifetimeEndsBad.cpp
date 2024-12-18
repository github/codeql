#include <string>
void work(const char*);

// BAD: the concatenated string is deallocated when `c_str` returns. So `work`
// is given a pointer to invalid memory.
void work_with_combined_string_bad(std::string s1, std::string s2) {
  const char* combined_string = (s1 + s2).c_str();
  work(combined_string);
}