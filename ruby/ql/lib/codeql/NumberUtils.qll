/**
 * Provides predicates for working with numeric values and their string
 * representations.
 */

/**
 * Gets the integer value of `hex` when interpreted as hex. `hex` must be a
 * valid hexadecimal string and, for integer-wrapping reasons, no longer than 6
 * digits.
 *
 * ```
 * "0"    => 0
 * "FF"   => 255
 * "f00d" => 61453
 * ```
 */
bindingset[hex]
int parseHexInt(string hex) {
  hex.length() <= 6 and
  result =
    sum(int index, string c |
      c = hex.charAt(index)
    |
      sixteenToThe(hex.length() - 1 - index) * toHex(c)
    )
}

/**
 * Gets the integer value of `octal` when interpreted as octal. `octal` must be
 * a valid octal string and, for integer-wrapping reasons, no longer than 10
 * digits.
 *
 * ```
 * "0"        => 0
 * "77"       => 63
 * "76543210" => 16434824
 * ```
 */
bindingset[octal]
int parseOctalInt(string octal) {
  octal.length() <= 10 and
  result =
    sum(int index, string c |
      c = octal.charAt(index)
    |
      eightToThe(octal.length() - 1 - index) * toOctal(c)
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

/** Gets the integer value of the `octal` char. */
private int toOctal(string octal) {
  octal = "0" and result = 0
  or
  octal = "1" and result = 1
  or
  octal = "2" and result = 2
  or
  octal = "3" and result = 3
  or
  octal = "4" and result = 4
  or
  octal = "5" and result = 5
  or
  octal = "6" and result = 6
  or
  octal = "7" and result = 7
}

/** Gets the value of 16 to the power of `n`. */
int sixteenToThe(int n) {
  // 16**7 is the largest power of 16 that fits in an int.
  n in [0 .. 7] and result = 1.bitShiftLeft(4 * n)
}

/** Gets the value of 8 to the power of `n`. */
int eightToThe(int n) {
  // 8**10 is the largest power of 8 that fits in an int.
  n in [0 .. 10] and result = 1.bitShiftLeft(3 * n)
}
