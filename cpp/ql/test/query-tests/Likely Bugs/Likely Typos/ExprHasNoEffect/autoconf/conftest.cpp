#include "conftest.h"

int main4() {
  strlen(""); // GOOD: conftest files are ignored
  return 0;
}
