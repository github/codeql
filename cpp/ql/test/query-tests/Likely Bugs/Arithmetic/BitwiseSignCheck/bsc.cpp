bool is_bit_set_v1(int x, int bitnum) {
  return (x & (1 << bitnum)) > 0;
}

bool is_bit_set_v2(int x, int bitnum) {
  return ((1 << bitnum) & x) > 0;
}

bool plain_wrong(int x, int bitnum) {
  return (x & (1 << bitnum)) >= 0;
}

bool is_bit24_set(int x) {
  return (x & (1 << 24)) > 0;
}
