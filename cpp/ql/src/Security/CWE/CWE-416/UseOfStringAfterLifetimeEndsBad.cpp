#include <string>
void work(const char*);

void work_with_combined_string_bad(std::string s1, std::string s2) {
  const char* combined_string = (s1 + s2).c_str();
  work(combined_string);
}