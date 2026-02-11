// semmle-extractor-options: -std=c++17

namespace std { typedef unsigned long size_t; }

void* operator new  ( std::size_t count, void* ptr );

namespace placement_new {
  struct HasTwoArgCtor {
    int x;
    HasTwoArgCtor(int a, int b);
  };

  template<typename T, typename... Args>
  void make(T *ptr, Args&&... args) {
    ::new((void *)ptr) HasTwoArgCtor(args...);
  }

  void make_HasTwoArgCtor(HasTwoArgCtor *p) {
    make(p, 1, 2);
  }
}
