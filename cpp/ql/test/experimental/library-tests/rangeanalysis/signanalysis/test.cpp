template <typename T>
class vector {
public:
  T& operator[](int);
  const T& operator[](int) const;
};

int test1(vector<int> vec, int b) {
  int x = -1;
  if (b) {
    x = vec[3];
  }
  return x;
}

// Regression test for ODASA-6013.
int test2(int x) {
  int x0 = static_cast<char>(x);
  return x0;
}

// Tests for conversion to bool
bool test3(bool b, int x, int y) {
  // The purpose the assignments to `x` below is to generate a lot of
  // potential upper and lower bounds for `x`, so that the logic in
  // boolConversionLowerBound and boolConversionUpperBound gets exercized.
  if (y == 0) {
    x = 0;
  }
  if (y == -1) {
    x = -1;
  }
  if (y == 1) {
    x = 1;
  }
  if (y == -128) {
    x = -128;
  }
  if (y == 128) {
    x = 128;
  }
  if (y == -1024) {
    x = -1024;
  }
  if (y == 1024) {
    x = 1024;
  }

  int t = 0;

  if (x == 0) {
    bool xb = (bool)x; // (bool)x == false
    t += (int)xb;
  }

  if (x > 0) {
    bool xb = (bool)x; // (bool)x == true
    t += (int)xb;
  }

  if (x < 0) {
    bool xb = (bool)x; // (bool)x == true
    t += (int)xb;
  }

  bool xb = (bool)x; // Value of (bool)x is unknown.
  t += (int)xb;

  return b || (bool)t;
}
