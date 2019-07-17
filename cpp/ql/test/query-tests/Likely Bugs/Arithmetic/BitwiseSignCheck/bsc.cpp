bool is_bit_set_v1(int x, int bitnum) {
  return (x & (1 << bitnum)) > 0; // BAD
}

bool is_bit_set_v2(int x, int bitnum) {
  return ((1 << bitnum) & x) > 0; // BAD
}

bool plain_wrong(int x, int bitnum) {
  return (x & (1 << bitnum)) >= 0; // ???
}

bool is_bit24_set(int x) {
  return (x & (1 << 24)) > 0; // GOOD (result will always be positive)
}

bool is_bit31_set_bad_v1(int x) {
  return (x & (1 << 31)) > 0; // BAD
}

bool is_bit31_set_bad_v2(int x) {
  return 0 < (x & (1 << 31)); // BAD [NOT DETECTED]
}

bool is_bit31_set_good(int x) {
  return (x & (1 << 31)) != 0; // GOOD (uses `!=`)
}

bool deliberately_checking_sign(int x, int y) {
  return (x & y) < 0; // GOOD (use of `<` implies the sign check is intended) [FALSE POSITIVE]
}
