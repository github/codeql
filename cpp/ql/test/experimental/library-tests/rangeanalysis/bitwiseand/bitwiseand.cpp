typedef unsigned char uint8_t;
typedef signed char int8_t;
typedef unsigned uint32_t;
typedef signed long long int64_t;

void test_assign_operator(uint8_t x) {
  x &= 7; // [0 .. 7]
}

void test_non_negative_const(uint8_t x) {
  uint8_t unsigned_const = 7;

  // Non-negative range operand and non-negative constant. The operands are promoted
  // to signed ints.
  x & 0; // [0 .. 0]
  x & 7; // [0 .. 7]
  x & unsigned_const; // [0 .. 7]

  // This tests what happens when both arguments are promoted to `unsigned int` instead
  // of `int`, and when the constant is larger than the max bound
  x & 0xFFFFFFFF; // [0 .. 255]
}

void test_non_const(uint8_t a, uint8_t b, uint32_t c, uint32_t d) {
  if (b <= 100) {
    // `a` and `b` are promoted to signed ints, meaning neither the range analysis library
    // nor this extension handle it
    a & b; // [-2147483648 .. 2147483647]
  }
  if (d <= 100) {
    // Handled by the range analysis library
    c & d; // [0 .. 100]
  }
}

void test_negative_operand(uint8_t x, int8_t y) {
  uint8_t unsigned_const = 7;
  int8_t signed_const = -7;

  // The right operand can be negative
  x & -7; // [-2147483648 .. 2147483647]
  x & signed_const; // [-2147483648 .. 2147483647]
  x & y; // [-2147483648 .. 2147483647]

  // The left operand can be negative
  y & 7; // [-2147483648 .. 2147483647]
  y & unsigned_const; // [-2147483648 .. 2147483647]
  y & 0xFFFFFFFF; // [0 .. 4294967295]
  (int64_t)y & 0xFFFFFFFF; // [-9223372036854776000 .. 9223372036854776000]
  y & x; // [-2147483648 .. 2147483647]

  // Both can be negative
  y & -7; // [-2147483648 .. 2147483647]
  y & signed_const; // [-2147483648 .. 2147483647]
  signed_const & -7; // [-2147483648 .. 2147483647]
  signed_const & y; // [-2147483648 .. 2147483647]
  -7 & y; // [-2147483648 .. 2147483647]
  -7 & signed_const; // [-2147483648 .. 2147483647]
}
