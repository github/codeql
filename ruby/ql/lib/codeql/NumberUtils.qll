/**
 * Provides predicates for working with numeric values and their string
 * representations.
 */

/**
 * Gets the integer value of `binary` when interpreted as binary. `binary` must
 * contain only the digits 0 and 1. For values greater than
 * 01111111111111111111111111111111 (2^31-1, the maximum value that `int` can
 * represent), there is no result.
 *
 * ```
 * "0"       => 0
 * "01"      => 1
 * "1010101" => 85
 * ```
 */
bindingset[binary]
int parseBinaryInt(string binary) {
  exists(string stripped | stripped = stripLeadingZeros(binary) |
    stripped.length() <= 31 and
    result >= 0 and
    result =
      sum(int index, string c, int digit |
        c = stripped.charAt(index) and
        digit = "01".indexOf(c)
      |
        twoToThe(stripped.length() - 1 - index) * digit
      )
  )
}

/**
 * Gets the integer value of `hex` when interpreted as hex. `hex` must be a
 * valid hexadecimal string. For values greater than 7FFFFFFF (2^31-1, the
 * maximum value that `int` can represent), there is no result.
 *
 * ```
 * "0"    => 0
 * "FF"   => 255
 * "f00d" => 61453
 * ```
 */
bindingset[hex]
int parseHexInt(string hex) {
  exists(string stripped | stripped = stripLeadingZeros(hex) |
    stripped.length() <= 8 and
    result >= 0 and
    result =
      sum(int index, string c |
        c = stripped.charAt(index)
      |
        sixteenToThe(stripped.length() - 1 - index) * toHex(c)
      )
  )
}

/**
 * Gets the integer value of `octal` when interpreted as octal. `octal` must be
 * a valid octal string containing only the digits 0-7. For values greater than
 * 17777777777 (2^31-1, the maximum value that `int` can represent), there is no
 * result.
 *
 * ```
 * "0"        => 0
 * "77"       => 63
 * "76543210" => 16434824
 * ```
 */
bindingset[octal]
int parseOctalInt(string octal) {
  exists(string stripped | stripped = stripLeadingZeros(octal) |
    stripped.length() <= 11 and
    result >= 0 and
    result =
      sum(int index, string c, int digit |
        c = stripped.charAt(index) and
        digit = "01234567".indexOf(c)
      |
        eightToThe(stripped.length() - 1 - index) * digit
      )
  )
}

/** Gets the integer value of the `hex` char. */
private int toHex(string hex) {
  hex = [0 .. 9].toString() and
  result = hex.toInt()
  or
  result = 10 and hex = ["a", "A"]
  or
  result = 11 and hex = ["b", "B"]
  or
  result = 12 and hex = ["c", "C"]
  or
  result = 13 and hex = ["d", "D"]
  or
  result = 14 and hex = ["e", "E"]
  or
  result = 15 and hex = ["f", "F"]
}

/**
 * Gets the value of 16 to the power of `n`. Holds only for `n` in the range
 * 0..7 (inclusive).
 */
int sixteenToThe(int n) {
  // 16**7 is the largest power of 16 that fits in an int.
  n in [0 .. 7] and result = 1.bitShiftLeft(4 * n)
}

/**
 * Gets the value of 8 to the power of `n`. Holds only for `n` in the range
 * 0..10 (inclusive).
 */
int eightToThe(int n) {
  // 8**10 is the largest power of 8 that fits in an int.
  n in [0 .. 10] and result = 1.bitShiftLeft(3 * n)
}

/**
 * Gets the value of 2 to the power of `n`. Holds only for `n` in the range
 * 0..30 (inclusive).
 */
int twoToThe(int n) { n in [0 .. 30] and result = 1.bitShiftLeft(n) }

/** Gets `s` with any leading "0" characters removed. */
bindingset[s]
private string stripLeadingZeros(string s) { result = s.regexpCapture("0*(.*)", 1) }
