struct C1 {
  static const int value = 5;
};

struct C2 {
  static const int value = 6;
};

template<typename T1, typename T2>
bool compareValues() {
  // Not all instantiations have T1 and T2 equal. Even if that's the case for
  // all instantiations in the program, there could still be more such
  // instantiations outside.
  return
    T1::value < T2::value || // GOOD
    T1::value < T1::value || // BAD [NOT DETECTED]
    C1::value < C1::value ; // BAD
}

bool callCompareValues() {
  return compareValues<C1, C2> || compareValues<C1, C1>();
}
