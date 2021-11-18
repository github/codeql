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
  }

  /** The `ParseInt` function. */
  class ParseInt extends IntegerParser::Range {
    ParseInt() { this.hasQualifiedName("strconv", "ParseInt") }

    override FunctionInput getTargetBitSizeInput() { result.isParameter(2) }
  }

  /** The `ParseUint` function. */
  class ParseUint extends IntegerParser::Range {
    ParseUint() { this.hasQualifiedName("strconv", "ParseUint") }

    override FunctionInput getTargetBitSizeInput() { result.isParameter(2) }
  }

  /**
   * The `IntSize` constant, that gives the size in bits of an `int` or
   * `uint` value on the current architecture (32 or 64).
   */
  class IntSize extends DeclaredConstant {
    IntSize() { this.hasQualifiedName("strconv", "IntSize") }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func AppendQuote(dst []byte, s string) []byte
      this.hasQualifiedName("strconv", "AppendQuote") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func AppendQuoteToASCII(dst []byte, s string) []byte
      this.hasQualifiedName("strconv", "AppendQuoteToASCII") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func AppendQuoteToGraphic(dst []byte, s string) []byte
      this.hasQualifiedName("strconv", "AppendQuoteToGraphic") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Quote(s string) string
      this.hasQualifiedName("strconv", "Quote") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func QuotedPrefix(s string) (string, error)
      this.hasQualifiedName("strconv", "QuotedPrefix") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func QuoteToASCII(s string) string
      this.hasQualifiedName("strconv", "QuoteToASCII") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func QuoteToGraphic(s string) string
      this.hasQualifiedName("strconv", "QuoteToGraphic") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Unquote(s string) (string, error)
      this.hasQualifiedName("strconv", "Unquote") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func UnquoteChar(s string, quote byte) (value rune, multibyte bool, tail string, err error)
      this.hasQualifiedName("strconv", "UnquoteChar") and
      (inp.isParameter(0) and outp.isResult(2))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
