template<typename T>
bool sometimesPointless(T param) {
  return param >= 0; // GOOD (FALSE POSITIVE: hypothetical instantiations are okay)
}

template<typename T>
bool alwaysPointless(T param) {
  unsigned int local = param;
  return local >= 0; // BAD (in all instantiations)
}

static int caller(int i) {
  return
      sometimesPointless<unsigned int>(i) ||
      alwaysPointless<unsigned int>(i) ||
      alwaysPointless<int>(i);
}
