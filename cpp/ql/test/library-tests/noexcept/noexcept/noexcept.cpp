
class T {
};

void swap1(T &lhs, T &rhs);
void swap2(T &lhs, T &rhs) noexcept;
void swap3(T &lhs, T &rhs) noexcept(true);

int f(void) {
    return noexcept(1+2);
}

#include "box.h"

void g() {
  box(12);
  box(13.4f);
  box("hello");
}
