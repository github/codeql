#include "conftest.h"

int main5() {
  strlen(""); // GOOD: conftest files are ignored
  return 0;
}
