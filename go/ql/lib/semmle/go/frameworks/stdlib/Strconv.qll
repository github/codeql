/**
 * Provides classes modeling security-relevant aspects of the `strconv` package.
 */

import go

/** Provides models of commonly used functions in the `strconv` package. */
module Strconv {
  /** The `Atoi` function. */
  class Atoi extends IntegerParser::Range {
    Atoi() { this.hasQualifiedName("strconv", "Atoi") }

    override int getTargetBitSize() { result = 0 }

    override boolean isSigned() { result = true }
  }

  /** The `ParseInt` function. */
  class ParseInt extends IntegerParser::Range {
    ParseInt() { this.hasQualifiedName("strconv", "ParseInt") }

    override FunctionInput getTargetBitSizeInput() { result.isParameter(2) }

    override boolean isSigned() { result = true }
  }

  /** The `ParseUint` function. */
  class ParseUint extends IntegerParser::Range {
    ParseUint() { this.hasQualifiedName("strconv", "ParseUint") }

    override FunctionInput getTargetBitSizeInput() { result.isParameter(2) }

    override boolean isSigned() { result = false }
  }

  /**
   * The `IntSize` constant, that gives the size in bits of an `int` or
   * `uint` value on the current architecture (32 or 64).
   */
  class IntSize extends DeclaredConstant {
    IntSize() { this.hasQualifiedName("strconv", "IntSize") }
  }
}
