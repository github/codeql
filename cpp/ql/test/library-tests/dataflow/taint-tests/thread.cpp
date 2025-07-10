#include "stl.h"

int source();
void sink(int);

struct S {
  int x;
};

void thread_function_1(S* s) {
  sink(s->x); // $ ir
}

void thread_function_2(S s) {
  sink(s.x); // $ ir
}

void thread_function_3(S* s, int y) {
  sink(s->x); // $ ir
  sink(y); // clean
}

void test_thread() {
  S s;
  s.x = source();
  std::thread t1(thread_function_1, &s);
  std::thread t2(thread_function_2, s);
  std::thread t3(thread_function_3, &s, 42);

  std::thread t4([](S* p) {
    sink(p->x); // $ ir
  }, &s);
}