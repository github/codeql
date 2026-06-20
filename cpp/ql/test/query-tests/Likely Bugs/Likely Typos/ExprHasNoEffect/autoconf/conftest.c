#include "conftest.h"

int main2() {
  strlen(""); // GOOD: conftest files are ignored
  return 0;
}
