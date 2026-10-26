typedef signed char int8_t;
typedef short int16_t;
typedef int int32_t;
typedef long int64_t;

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long uint64_t;

extern uint8_t value_known_at_runtime8();

void testLShiftOperator() {
  uint8_t unsigned_const1 = 7;
  uint8_t unsigned_const2(7);
  uint8_t unsigned_const3{7};
  int8_t signed_const = -7;
  uint8_t x = value_known_at_runtime8();
  int8_t y = (int8_t)value_known_at_runtime8();
  uint8_t z = value_known_at_runtime8();

  // An assign left shift operator. Note that no promotion occurs here
  z <<= 2;  // [0, 255]
  if (z <= 60) {
    z <<= 2;  // [0, 240]
  }

  // A normal shift
  x << 2;  // [0, 1020]

  // Possible to exceed the maximum size
  x << 25;  // [-2147483648, 2147483648]

  // Undefined behavior
  x << 34;  // [-2147483648, 2147483648]

  // A normal shift by a constant in a variable
  x << unsigned_const1;  // [0, 32640]
  x << unsigned_const2;  // [0, 32640]
  x << unsigned_const3;  // [0, 32640]

  // Negative shifts are undefined
  x << signed_const;  // [-2147483648, 2147483648]

  // Now the left operand is a constant
  1 << unsigned_const1;  // [128, 128]

  // x could be large enough to cause undefined behavior
  1 << x;  // [-2147483648, 2147483647]
  if (x < 8) {
    // x is now constrained so the shift is defined
    1 << x;  // [1, 128]
  }

  // We don't support shifting negative values (and some of these are undefined
  // anyway)
  y << 2;                // [-2147483648, 2147483647]
  y << 25;               // [-2147483648, 2147483648]
  y << 34;               // [-2147483648, 2147483648]
  y << unsigned_const1;  // [-2147483648, 2147483647]
  y << signed_const;     // [-2147483648, 2147483648]

  // Negative shifts are undefined
  1 << signed_const;  // [-2147483648, 2147483648]

  // We don't handle cases where the shift range could be negative
  1 << y;  // [-2147483648, 2147483648]
  if (y >= 0 && y < 8) {
    // The shift range is now positive
    1 << y;  // [1, 128]
  }

  if (x > 0 and x < 2 and y > 0 and x < 2) {
    // We don't support shifts where neither operand is a constant at the moment
    x << y;  // [-2147483648, 2147483648]
    y << x;  // [-2147483648, 2147483648]
  }
}

void testRShiftOperator() {
  uint8_t unsigned_const1 = 2;
  uint8_t unsigned_const2(2);
  uint8_t unsigned_const3{2};
  int8_t signed_const = -2;
  uint8_t x = value_known_at_runtime8();
  int8_t y = (int8_t)value_known_at_runtime8();
  uint8_t z = value_known_at_runtime8();

  // An assign right shift operator. Note that no promotion occurs here
  z >>= 2;  // [0, 63]
  if (z <= 60) {
    z >>= 2;  // [0, 15]
  }

  // A normal shift
  x >> 2;  // [0, 63]

  // Possible to exceed the maximum size
  x >> 25;  // [0, 0]

  // Undefined behavior, but this case is handled by the SimpleRangeAnalysis
  // library and sets the the bounds to [0, 0], which is fine
  x >> 34;  // [0, 0]

  // A normal shift by a constant in a variable
  x >> unsigned_const1;  // [0, 63]
  x >> unsigned_const2;  // [0, 63]
  x >> unsigned_const3;  // [0, 63]

  // Negative shifts are undefined
  x >> signed_const;  // [-2147483648, 2147483648]

  // Now the left operand is a constant
  128 >> unsigned_const1;  // [32, 32]

  // x could be large enough to cause undefined behavior
  128 >> x;  // [-2147483648, 2147483647]
  if (x < 3) {
    // x is now constrained so the shift is defined
    128 >> x;  // [32, 128]
  }

  // We don't support shifting negative values, but the SimpleRangeAnalysis
  // library handles the first three cases even though they're implementation
  // defined or undefined behavior (TODO: Check ideone)
  y >> 2;   // [-2147483648, 2147483647] (Default is [-32, 31])
  y >> 25;  // -2147483648, 2147483647] (Default is [-1, 0])
  y >> 34;  // [-1, 0] (My code doesn't touch this, so default code is used)
  y >> unsigned_const1;  // [-2147483648, 2147483647]
  y >> signed_const;     // [-2147483648, 2147483648]

  // Negative shifts are undefined
  128 >> signed_const;  // [-2147483648, 2147483648]

  // We don't handle cases where the shift range could be negative
  128 >> y;  // [-2147483648, 2147483648]
  if (y >= 0 && y < 3) {
    // The shift range is now positive
    128 >> y;  // [32, 128]
  }

  if (x > 0 and x < 2 and y > 0 and x < 2) {
    // We don't support shifts where neither operand is a constant at the moment
    x >> y;  // [-2147483648, 2147483648]
    y >> x;  // [-2147483648, 2147483648]
  }
}
