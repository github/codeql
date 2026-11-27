#include "../format-suggestions.h"

void microsoft_format_suggestions(const char *narrow, const wchar_t *wide) {
  printf("%S", narrow);  // Suggest %s in the Microsoft model.
  printf("%hs", wide);   // Suggest %ls in the Microsoft model.
}
