
template <typename T>
void templateFunc1(T x, T y, T z) {
  if (x < y < z) {} // BAD (though dubious as we can imagine other instantiations using an overloaded `operator<`)
  if (x < y && y < z) {} // GOOD
};

template <typename T>
void templateFunc2(T x, T y, T z) {
  if (x < y < z) {} // GOOD (used with an overloaded `operator<`)
  if (x < y && y < z) {} // GOOD
};

struct myStruct {
  operator bool() {
    return true;
  }

  myStruct operator<(myStruct &other) {
    return other; // non-standard `operator<` behaviour
  }
};

int main() {
  int x = 3;
  myStruct y;
 
  templateFunc1(x, x, x);
  templateFunc2(y, y, y);

  return 0;
}
