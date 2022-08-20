/**
 * Support for integer intervals.
 * An interval is represented as by its inclusive lower bound, `start`, and its exclusive upper bound, `end`.
 * Either or both of `start` and `end` may have an unknown value.
 */

import Overlap
private import IntegerConstant

/**
 * Gets the overlap relationship between the definition interval [`defStart`, `defEnd`) and the use interval
 * [`useStart`, `useEnd`).
 */
bindingset[defStart, defEnd, useStart, useEnd]
Overlap getOverlap(IntValue defStart, IntValue defEnd, IntValue useStart, IntValue useEnd) {
  if isEQ(defStart, useStart) and isEQ(defEnd, useEnd)
  then result instanceof MustExactlyOverlap
  else
    if isLE(defStart, useStart) and isGE(defEnd, useEnd)
    then result instanceof MustTotallyOverlap
    else (
      not isLE(defEnd, useStart) and
      not isGE(defStart, useEnd) and
      result instanceof MayPartiallyOverlap
    )
}

/**
 * Gets a string representation of the interval [`start`, `end`).
 */
bindingset[start, end]
string getIntervalString(IntValue start, IntValue end) {
  // We represent an interval has half-open, so print it as "[start..end)".
  result = "[" + bitsToBytesAndBits(start) + ".." + bitsToBytesAndBits(end) + ")"
}
