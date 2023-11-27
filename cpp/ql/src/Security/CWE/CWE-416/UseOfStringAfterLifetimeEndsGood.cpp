#include <string>
void work(const char*);

void work_with_combined_string_good(std::string s1, std::string s2) {
  auto combined_string = s1 + s2;
  work(combined_string.c_str());
}