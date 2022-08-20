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

template <bool C, typename T = void>
struct enable_if {};

template <typename T>
struct enable_if<true, T> { typedef T type; };

template<typename T1, typename T2>
typename enable_if<T1::value <= T2::value, bool>::type constant_comparison() {
  return true;
}

struct Value0 {
  const static int value = 0;
};

void instantiation_with_pointless_comparison() {
  constant_comparison<Value0, Value0>(); // GOOD
}