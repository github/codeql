import cpp

class IntValue = int;

/**
 * Returns the value of the maximum representable integer.
 */
int maxValue() {
  result = 2147483647
}

/**
 * Returns the value of the minimum representable integer.
 */
int minValue() {
  result = -2147483647
}

/**
 * Returns a value representing an unknown integer.
 */
IntValue unknown() {
  result = -2147483648
}

/**
 * Holds if `n` has a known value.
 */
bindingset[n]
predicate hasValue(IntValue n) {
  n != unknown()
}

/**
 * Holds if the value `f` is within the range of representable integers.
 */
pragma[inline]
bindingset[f]
private predicate isRepresentable(float f) {
  (f >= minValue()) and (f <= maxValue())
}

/**
 * Gets the value of `n`. Holds only if `n` has a known value.
 */
bindingset[n]
int getValue(IntValue n) {
  hasValue(n) and result = n
}

/**
 * Returns `a + b`. If either input is unknown, or if the addition overflows,
 * the result is unknown.
 */
bindingset[a, b]
IntValue add(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) and isRepresentable((float)a + (float)b) then
    result = a + b
  else
    result = unknown()
}

/**
 * Returns `a - b`. If either input is unknown, or if the subtraction overflows,
 * the result is unknown.
 */
bindingset[a, b]
IntValue sub(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) and isRepresentable((float)a - (float)b) then
    result = a - b
  else
    result = unknown()
}

/**
 * Returns `a * b`. If the multiplication overflows, the result is unknown. If
 * either input is unknown and the other input is non-zero, the result is
 * unknown.
 */
bindingset[a, b]
IntValue mul(IntValue a, IntValue b) {
  if (a = 0) or (b = 0) then
    result = 0
  else if hasValue(a) and hasValue(b) and isRepresentable((float)a * (float)b) then
    result = a * b
  else
    result = unknown()
}

/**
 * Returns `a / b`. If either input is unknown, or if `b` is zero, the result is
 * unknown.
 */
bindingset[a, b]
IntValue div(IntValue a, IntValue b) {
  // Normally, integer division has to worry about overflow for INT_MIN/-1.
  // However, since we use INT_MIN to represent an unknown value anyway, we only
  // have to worry about division by zero.
  if hasValue(a) and hasValue(b) and (b != 0) then
    result = a / b
  else
    result = unknown()
}

/**
 * Returns `a == b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareEQ(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) then (
    if a = b then
      result = 1
    else
      result = 0
  )
  else
    result = unknown()
}

/**
 * Returns `a != b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareNE(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) then (
    if a != b then
      result = 1
    else
      result = 0
  )
  else
    result = unknown()
}

/**
 * Returns `a < b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareLT(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) then (
    if a < b then
      result = 1
    else
      result = 0
  )
  else
    result = unknown()
}

/**
 * Returns `a > b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareGT(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) then (
    if a > b then
      result = 1
    else
      result = 0
  )
  else
    result = unknown()
}

/**
 * Returns `a <= b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareLE(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) then (
    if a <= b then
      result = 1
    else
      result = 0
  )
  else
    result = unknown()
}

/**
 * Returns `a >= b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareGE(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) then (
    if a >= b then
      result = 1
    else
      result = 0
  )
  else
    result = unknown()
}

/**
 * Return `-a`. If `a` is unknown, the result is unknown.
 */
bindingset[a]
IntValue neg(IntValue a) {
  result = -a  // -INT_MIN = INT_MIN, so this preserves unknown
}
