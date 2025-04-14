#define NULL ((void *)0)

namespace std {
struct nothrow_t {};
typedef unsigned long size_t;

class exception {};
class bad_alloc : public exception {};

extern const std::nothrow_t nothrow;
} // namespace std

using namespace std;

void *operator new(std::size_t);
void *operator new[](std::size_t);
void *operator new(std::size_t, const std::nothrow_t &) noexcept;
void *operator new[](std::size_t, const std::nothrow_t &) noexcept;

void bad_new_in_condition() {
  if (!(new int)) { // BAD
    return;
  }
}

void foo(int**);

void bad_new_missing_exception_handling() {
  int *p1 = new int[100]; // BAD
  if (p1 == 0)
    return;

  int *p2 = new int[100]; // BAD
  if (!p2)
    return;

  int *p3 = new int[100]; // BAD
  if (p3 == NULL)
    return;

  int *p4 = new int[100]; // BAD
  if (p4 == nullptr)
    return;

  int *p5 = new int[100]; // BAD
  if (p5) {} else return;

  int *p6;
  p6 = new int[100]; // BAD
  if (p6 == 0) return;

  int *p7;
  p7 = new int[100]; // BAD
  if (!p7)
    return;

  int *p8;
  p8 = new int[100]; // BAD
  if (p8 == NULL)
    return;

  int *p9;
  p9 = new int[100]; // BAD
  if (p9 != nullptr) {
  } else
    return;

  int *p10;
  p10 = new int[100]; // BAD
  if (p10 != 0) {
  }

  int *p11;
  do {
    p11 = new int[100]; // BAD
  } while (!p11);

  int* p12 = new int[100];
  foo(&p12);
  if(p12) {} else return; // GOOD: p12 is probably modified in foo, so it's
                          // not the return value of the new that's checked.

  int* p13 = new int[100];
  foo(&p13);
  if(!p13) {
      return;
  } else { }; // GOOD: same as above.
}

void bad_new_nothrow_in_exception_body() {
  try {
    new (std::nothrow) int[100];           // BAD
    int *p1 = new (std::nothrow) int[100]; // BAD

    int *p2;
    p2 = new (std::nothrow) int[100]; // BAD
  } catch (const std::bad_alloc &) {
  }
}

void good_new_has_exception_handling() {
  try {
    int *p1 = new int[100]; // GOOD
  } catch (...) {
  }
}

void good_new_handles_nullptr() {
  int *p1 = new (std::nothrow) int[100]; // GOOD
  if (p1 == nullptr)
    return;

  int *p2;
  p2 = new (std::nothrow) int[100]; // GOOD
  if (p2 == nullptr)
    return;

  int *p3;
  p3 = new (std::nothrow) int[100]; // GOOD
  if (p3 != nullptr) {
  }

  int *p4;
  p4 = new (std::nothrow) int[100]; // GOOD
  if (p4) {
  } else
    return;

  int *p5;
  p5 = new (std::nothrow) int[100]; // GOOD
  if (p5 != nullptr) {
  } else
    return;

  if (new (std::nothrow) int[100] == nullptr)
    return; // GOOD
}

// ---

void* operator new(std::size_t count, void*) noexcept;
void* operator new[](std::size_t count, void*) noexcept;

struct Foo {
  Foo() noexcept;
  Foo(int);

  operator bool();
};

struct Bar {
  Bar();

  operator bool();
};

void bad_placement_new_with_exception_handling() {
  char buffer[1024];

  try { new (buffer) Foo; } // BAD (placement new should not fail)
  catch (...) {  }
}

void good_placement_new_with_exception_handling() {
  char buffer[1024];

  try { new (buffer) Foo(42); } // GOOD: Foo constructor might throw
  catch (...) {  }

  try { new (buffer) Bar; } // GOOD: Bar constructor might throw
  catch (...) {  }
}

template<typename F> F *test_template_platement_new() {
  char buffer[1024];

  try {
    return new (buffer) F; // GOOD: `F` constructor might throw (when `F` is `Bar`)
  } catch (...) {
    return 0;
  }
}

void test_template_platement_new_caller() {
  test_template_platement_new<Foo>();
  test_template_platement_new<Bar>();
}

// ---

int unknown_value_without_exceptions() noexcept;

void may_throw() {
  if(unknown_value_without_exceptions()) {
    throw "bad luck exception!";
  }
}

void unknown_code_that_may_throw(int*);
void unknown_code_that_will_not_throw(int*) noexcept;

void calls_throwing_code(int* p) {
  if(unknown_value_without_exceptions()) unknown_code_that_may_throw(p);
}

void calls_non_throwing(int* p) {
  if (unknown_value_without_exceptions()) unknown_code_that_will_not_throw(p);
}

void good_new_with_throwing_call() {
  try {
    int* p1 = new(std::nothrow) int; // GOOD
    may_throw();
  } catch(...) {  }

  try {
    int* p2 = new(std::nothrow) int; // GOOD
    Foo f(10);
  } catch(...) {  }

  try {
    int* p3 = new(std::nothrow) int; // GOOD
    calls_throwing_code(p3);
  } catch(...) {  }
}

void bad_new_with_nonthrowing_call() {
  try {
    int* p1 = new(std::nothrow) int; // BAD
    calls_non_throwing(p1);
  } catch(...) {  }

  try {
    int* p2 = new(std::nothrow) int; // GOOD: boolean conversion constructor might throw
    Foo f;
    if(f) { }
  } catch(...) {  }
}

void bad_new_catch_baseclass_of_bad_alloc() {
  try {
    int* p = new(std::nothrow) int; // BAD
  } catch(const std::exception&) { }
}

void good_new_catch_exception_in_assignment() {
  int* p;
  try {
    p = new int; // GOOD
  } catch(const std::bad_alloc&) { }
}

void good_new_catch_exception_in_conversion() {
  try {
    long* p = (long*) new int; // GOOD
  } catch(const std::bad_alloc&) { }
}

// The 'n' parameter is just to distinquish it from the overload further up in this file.
void *operator new(std::size_t, int n, const std::nothrow_t &);

void test_operator_new_without_exception_spec() {
  int* p = new(42, std::nothrow) int; // GOOD
  if(p == nullptr) {}
}

namespace std {
  void *memset(void *s, int c, size_t n);
}

// from the qhelp:
namespace qhelp {
  // BAD: the allocation will throw an unhandled exception
  // instead of returning a null pointer.
  void bad1(std::size_t length) noexcept {
    int* dest = new int[length];
    if(!dest) {
      return;
    }
    std::memset(dest, 0, length);
    // ...
  }

  // BAD: the allocation won't throw an exception, but
  // instead return a null pointer.
  void bad2(std::size_t length) noexcept {
    try {
      int* dest = new(std::nothrow) int[length];
      std::memset(dest, 0, length);
      // ...
    } catch(std::bad_alloc&) {
      // ...
    }
  }

  // GOOD: the allocation failure is handled appropriately.
  void good1(std::size_t length) noexcept {
    try {
      int* dest = new int[length];
      std::memset(dest, 0, length);
      // ...
    } catch(std::bad_alloc&) {
      // ...
    }
  }

  // GOOD: the allocation failure is handled appropriately.
  void good2(std::size_t length) noexcept {
    int* dest = new(std::nothrow) int[length];
    if(!dest) {
      return;
    }
    std::memset(dest, 0, length);
    // ...
  }
}
