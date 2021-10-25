template<typename T>
bool sometimesPointless(T param) {
  return param <= 0xFFFF; // GOOD (hypothetical instantiations are okay)
}

template<typename T>
bool alwaysPointless(T param) {
  short local = param;
  return local <= 0xFFFF; // BAD (in all instantiations)
}

static int caller(int i) {
  return
      sometimesPointless<short>(i) ||
      alwaysPointless<short>(i) ||
      alwaysPointless<int>(i);
}
