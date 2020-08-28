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

void use_after_cast(unsigned char c)
{
  unsigned short c_times_2 = c + c;
  if ((unsigned char)c_times_2 == 0)
  {
    c_times_2;
  }
  c_times_2;
}

int ref_to_number(int &i, const int &ci, int &aliased) {
  int &alias = aliased; // no range analysis for either of the two aliased variables

  if (i >= 2)
    return i; // BUG: lower bound should be 2

  if (ci >= 2)
    return ci; // BUG: lower bound should be 2

  if (aliased >= 2)
    return aliased;

  if (alias >= 2)
    return alias;

  for (; i <= 12345; i++) {
    i; // BUG: upper bound should be deduced (but subject to widening)
  }

  return 0;
}
