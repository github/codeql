/**
 * Provides predicates for manipulating integer constants that are tracked by constant folding and
 * similar analyses.
 */

/**
 * An alias used to represent the constant value of an integer, if one can be determined. If no
 * single constant value can be determined, or if the constant value is out of the representable
 * range, it will be represented as the special value `unknown()`. This allows `IntValue` to be used
 * in contexts where there must always be a value for the `IntValue`, even if no constant value is
 * known.
 */
class IntValue = int;

/**
 * Returns the value of the maximum representable integer.
 */
int maxValue() { result = 2147483647 }

/**
 * Returns the value of the minimum representable integer.
 */
int minValue() { result = -2147483647 }

/**
 * Returns a value representing an unknown integer.
 */
IntValue unknown() { result = -2147483648 }

/**
 * Holds if `n` has a known value.
 */
bindingset[n]
predicate hasValue(IntValue n) { n != unknown() }

/**
 * Returns a string representation of `n`. If `n` does not have a known value, the result is "??".
 */
bindingset[n]
string intValueToString(IntValue n) { if hasValue(n) then result = n.toString() else result = "??" }

/**
 * Holds if the value `f` is within the range of representable integers.
 */
bindingset[f]
pragma[inline]
private predicate isRepresentable(float f) { f >= minValue() and f <= maxValue() }

/**
 * Gets the value of `n`. Holds only if `n` has a known value.
 */
bindingset[n]
int getValue(IntValue n) { hasValue(n) and result = n }

/**
 * Returns `a + b`. If either input is unknown, or if the addition overflows,
 * the result is unknown.
 */
bindingset[a, b]
IntValue add(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) and isRepresentable(a.(float) + b.(float))
  then result = a + b
  else result = unknown()
}

/**
 * Returns `a - b`. If either input is unknown, or if the subtraction overflows,
 * the result is unknown.
 */
bindingset[a, b]
IntValue sub(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b) and isRepresentable(a.(float) - b.(float))
  then result = a - b
  else result = unknown()
}

/**
 * Returns `a * b`. If the multiplication overflows, the result is unknown. If
 * either input is unknown and the other input is non-zero, the result is
 * unknown.
 */
bindingset[a, b]
IntValue mul(IntValue a, IntValue b) {
  if a = 0 or b = 0
  then result = 0
  else
    if hasValue(a) and hasValue(b) and isRepresentable(a.(float) * b.(float))
    then result = a * b
    else result = unknown()
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
  if hasValue(a) and hasValue(b) and b != 0 then result = a / b else result = unknown()
}

/**
 * Returns `a == b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareEQ(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b)
  then if a = b then result = 1 else result = 0
  else result = unknown()
}

/**
 * Returns `a != b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareNE(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b)
  then if a != b then result = 1 else result = 0
  else result = unknown()
}

/**
 * Returns `a < b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareLT(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b)
  then if a < b then result = 1 else result = 0
  else result = unknown()
}

/**
 * Returns `a > b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareGT(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b)
  then if a > b then result = 1 else result = 0
  else result = unknown()
}

/**
 * Returns `a <= b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareLE(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b)
  then if a <= b then result = 1 else result = 0
  else result = unknown()
}

/**
 * Returns `a >= b`. If either input is unknown, the result is unknown.
 */
bindingset[a, b]
IntValue compareGE(IntValue a, IntValue b) {
  if hasValue(a) and hasValue(b)
  then if a >= b then result = 1 else result = 0
  else result = unknown()
}

/**
 * Return `-a`. If `a` is unknown, the result is unknown.
 */
bindingset[a]
IntValue neg(IntValue a) {
  result = -a // -INT_MIN = INT_MIN, so this preserves unknown
}

/**
 * Holds if `a` is equal to `b`. Does not hold if either `a` or `b` is unknown.
 */
bindingset[a, b]
predicate isEQ(IntValue a, IntValue b) { hasValue(a) and hasValue(b) and a = b }

/**
 * Holds if `a` is not equal to `b`. Does not hold if either `a` or `b` is unknown.
 */
bindingset[a, b]
predicate isNE(IntValue a, IntValue b) { hasValue(a) and hasValue(b) and a != b }

/**
 * Holds if `a` is less than `b`. Does not hold if either `a` or `b` is unknown.
 */
bindingset[a, b]
predicate isLT(IntValue a, IntValue b) { hasValue(a) and hasValue(b) and a < b }

/**
 * Holds if `a` is less than or equal to `b`. Does not hold if either `a` or `b` is unknown.
 */
bindingset[a, b]
predicate isLE(IntValue a, IntValue b) { hasValue(a) and hasValue(b) and a <= b }

/**
 * Holds if `a` is greater than `b`. Does not hold if either `a` or `b` is unknown.
 */
bindingset[a, b]
predicate isGT(IntValue a, IntValue b) { hasValue(a) and hasValue(b) and a > b }

/**
 * Holds if `a` is greater than or equal to `b`. Does not hold if either `a` or `b` is unknown.
 */
bindingset[a, b]
predicate isGE(IntValue a, IntValue b) { hasValue(a) and hasValue(b) and a >= b }

/**
 * Converts the bit count in `bits` to a byte count and a bit count in the form
 * "bytes:bits". If `bits` represents an integer number of bytes, the ":bits" section is omitted.
 * If `bits` does not have a known value, the result is "?".
 */
bindingset[bits]
string bitsToBytesAndBits(IntValue bits) {
  exists(int bytes, int leftoverBits |
    hasValue(bits) and
    bytes = bits / 8 and
    leftoverBits = bits % 8 and
    if leftoverBits = 0 then result = bytes.toString() else result = bytes + ":" + leftoverBits
  )
  or
  not hasValue(bits) and result = "?"
}

/**
 * Gets a printable string for a bit offset with possibly unknown value.
 */
bindingset[bitOffset]
string getBitOffsetString(IntValue bitOffset) {
  if hasValue(bitOffset)
  then
    if bitOffset >= 0
    then result = "+" + bitsToBytesAndBits(bitOffset)
    else result = "-" + bitsToBytesAndBits(neg(bitOffset))
  else result = "+?"
}
