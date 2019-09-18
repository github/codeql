/**
 * Provides basic arithmetic operations that have no result if their result
 * would overflow a 32-bit two's complement integer.
 */

/**
 * Gets the value of the maximum representable integer.
 */
int maxValue() { result = 2147483647 }

/**
 * Gets the value of the minimum representable integer.
 */
int minValue() { result = -2147483648 }

/**
 * Holds if the value `f` is within the range of representable integers.
 */
bindingset[f]
pragma[inline]
private predicate isRepresentable(float f) { f >= minValue() and f <= maxValue() }

/**
 * Returns `a + b`. If the addition overflows, there is no result.
 */
bindingset[a, b]
int add(int a, int b) {
  isRepresentable(a.(float) + b.(float)) and
  result = a + b
}

/**
 * Returns `a - b`. If the subtraction overflows, there is no result.
 */
bindingset[a, b]
int sub(int a, int b) {
  isRepresentable(a.(float) - b.(float)) and
  result = a - b
}

/**
 * Returns `a * b`. If the multiplication overflows, there is no result. If
 * either input is not given, and the other input is non-zero, there is no
 * result.
 */
bindingset[a, b]
int mul(int a, int b) {
  a = 0 and
  result = 0
  or
  b = 0 and
  result = 0
  or
  isRepresentable(a.(float) * b.(float)) and
  result = a * b
}

/**
 * Returns `a / b`. If the division overflows, there is no result.
 */
bindingset[a, b]
int div(int a, int b) {
  b != 0 and
  (a != minValue() or b != -1) and
  result = a / b
}

/** Returns `a == b`. */
bindingset[a, b]
int compareEQ(int a, int b) { if a = b then result = 1 else result = 0 }

/** Returns `a != b`. */
bindingset[a, b]
int compareNE(int a, int b) { if a != b then result = 1 else result = 0 }

/** Returns `a < b`. */
bindingset[a, b]
int compareLT(int a, int b) { if a < b then result = 1 else result = 0 }

/** Returns `a > b`. */
bindingset[a, b]
int compareGT(int a, int b) { if a > b then result = 1 else result = 0 }

/** Returns `a <= b`. */
bindingset[a, b]
int compareLE(int a, int b) { if a <= b then result = 1 else result = 0 }

/** Returns `a >= b`. */
bindingset[a, b]
int compareGE(int a, int b) { if a >= b then result = 1 else result = 0 }

/**
 * Returns `-a`. If the negation would overflow, there is no result.
 */
bindingset[a]
int neg(int a) {
  a != minValue() and
  result = -a
}
