// semmle-extractor-options: -std=c++23

constexpr bool test() {
    int x;
    if consteval {
        x = 1;
    } else {
        x = 2;
    }
    if consteval {
        x = 3;
    }
    return x;
}

struct ClassWithDestructor
{
  ClassWithDestructor();
  ClassWithDestructor(const char*);
  ~ClassWithDestructor();
  operator bool() const;
};

bool destruction_on_consteval() {
  if consteval {
    return true;
  } else {
    ClassWithDestructor cwd;
    return cwd;
  }
}

bool destruction_on_consteval2() {
  ClassWithDestructor cwd;
  if consteval {
    return true;
  } else {
    return cwd;
  }
}
