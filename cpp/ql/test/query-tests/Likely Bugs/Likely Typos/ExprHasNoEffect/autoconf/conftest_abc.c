#include "conftest.h"

int main1() {
  strlen(""); // BAD: not a `conftest` file, as `conftest` is not directly followed by the extension or a sequence of numbers.
  return 0;
}
