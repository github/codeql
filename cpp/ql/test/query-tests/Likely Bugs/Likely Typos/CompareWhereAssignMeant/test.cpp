class IntHolder {
private:
  int x;
public:
  IntHolder(int x_) {
    x = x_;
  }

  operator bool() {
    return x;
  }

  inline bool operator==(const IntHolder& other) {
    return x == other.x;
  }

  IntHolder& operator=(const IntHolder& other) {
    x = other.x;
    return *this;
  }
};

void f(void) {
    int i;

    i = 1;

    i == 1;

    i == 1, i == 2;

    i = i == 1, i == 2;

    i = (i == 1, i == 2);

    if (({ int x = 3; x == 3; })) {
        return;
    }
    if (({ int x = 3; x == 3; x; })) {
        return;
    }
    if (({ int x = 3; x == 3; x = 4; })) {
        return;
    }

    i != 1;

    IntHolder holder1(i);
    IntHolder holder2(i);
    holder1 = holder2;
    holder1 == holder2;
    if(holder1 = holder2) {
    }
    if(holder1 == holder1) {
    }
}

// This pattern is used to emulate C++20 concepts in a way that's very light on
// template syntax.
template<typename T1, typename T2>
auto sfinaeTrick(T1 x1, T2 x2) -> decltype(x1 == x2, bool()) { // GOOD
  return x1 == x2;
}
