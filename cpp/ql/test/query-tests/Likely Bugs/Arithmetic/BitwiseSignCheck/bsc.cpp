bool is_bit_set_v1(int x, int bitnum) {
  return (x & (1 << bitnum)) > 0; // BAD
}

bool is_bit_set_v2(int x, int bitnum) {
  return ((1 << bitnum) & x) > 0; // BAD
}

bool plain_wrong(int x, int bitnum) {
  return (x & (1 << bitnum)) >= 0; // GOOD (testing for `>= 0` is the logical negation of `< 0`, a negativity test)
}

bool is_bit24_set(int x) {
  return (x & (1 << 24)) > 0; // GOOD (result will always be positive)
}

bool is_bit31_set_bad_v1(int x) {
  return (x & (1 << 31)) > 0; // BAD
}

bool is_bit31_set_bad_v2(int x) {
  return 0 < (x & (1 << 31)); // BAD
}

bool is_bit31_set_good(int x) {
  return (x & (1 << 31)) != 0; // GOOD (uses `!=`)
}

bool deliberately_checking_sign(int x, int y) {
  return (x & y) < 0; // GOOD (testing for negativity rather the positivity implies that signed values are being considered intentionally by the developer)
}

bool deliberately_checking_sign2(int x, int y) {
  return (x & y) >= 0; // GOOD (testing for `>= 0` is the logical negation of `< 0`, a negativity test)
}

bool is_bit_set_v3(int x, int bitnum) {
  return (x & (1 << bitnum)) <= 0; // GOOD (testing for `<= 0` is the logical negation of `> 0`, a positivity test, but the way it's written suggests the developer considers the value to be signed)
}

bool is_bit_set_v4(int x, int bitnum) {
  return (x & (1 << bitnum)) >= 1; // BAD [NOT DETECTED]
}
