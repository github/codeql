/**
 * This module provides a hand-modifiable wrapper around the generated class `LiteralExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LiteralExpr

/**
 * INTERNAL: This module contains the customizable definition of `LiteralExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A literal expression. For example:
   * ```rust
   * 42;
   * 42.0;
   * "Hello, world!";
   * b"Hello, world!";
   * 'x';
   * b'x';
   * r"Hello, world!";
   * true;
   * ```
   */
  class LiteralExpr extends Generated::LiteralExpr {
    override string toStringImpl() { result = this.getTrimmedText() }

    override string toAbbreviatedString() { result = this.getTrimmedText() }

    /**
     * Get the text of this literal, trimmed with `...` if it is too long.
     *
     * INTERNAL: Do not use.
     */
    string getTrimmedText() {
      exists(string v |
        v = this.getTextValue() and
        if v.length() > 30 then result = v.substring(0, 30) + "..." else result = v
      )
    }
  }

  /**
   * A [character literal][1]. For example:
   *
   * ```rust
   * 'x';
   * ```
   *
   * [1]: https://doc.rust-lang.org/reference/tokens.html#character-literals
   */
  class CharLiteralExpr extends LiteralExpr {
    CharLiteralExpr() { this.getTextValue().regexpMatch("'.*'") }

    override string getAPrimaryQlClass() { result = "CharLiteralExpr" }
  }

  /**
   * A [string literal][1]. For example:
   *
   * ```rust
   * "Hello, world!";
   * ```
   *
   * [1]: https://doc.rust-lang.org/reference/tokens.html#string-literals
   */
  class StringLiteralExpr extends LiteralExpr {
    StringLiteralExpr() { this.getTextValue().regexpMatch("r?#*\".*\"#*") }

    override string getAPrimaryQlClass() { result = "StringLiteralExpr" }
  }

  /**
   * A number literal.
   */
  abstract class NumberLiteralExpr extends LiteralExpr { }

  // https://doc.rust-lang.org/reference/tokens.html#integer-literals
  private module IntegerLiteralRegexs {
    bindingset[s]
    string paren(string s) { result = "(" + s + ")" }

    string integerLiteral() {
      result =
        paren(paren(decLiteral()) + "|" + paren(binLiteral()) + "|" + paren(octLiteral()) + "|" +
              paren(hexLiteral())) + paren(suffix()) + "?"
    }

    private string suffix() { result = "u8|i8|u16|i16|u32|i32|u64|i64|u128|i128|usize|isize" }

    string decLiteral() { result = decDigit() + "(" + decDigit() + "|_)*" }

    string binLiteral() {
      result = "0b(" + binDigit() + "|_)*" + binDigit() + "(" + binDigit() + "|_)*"
    }

    string octLiteral() {
      result = "0o(" + octDigit() + "|_)*" + octDigit() + "(" + octDigit() + "|_)*"
    }

    string hexLiteral() {
      result = "0x(" + hexDigit() + "|_)*" + hexDigit() + "(" + hexDigit() + "|_)*"
    }

    string decDigit() { result = "[0-9]" }

    string binDigit() { result = "[01]" }

    string octDigit() { result = "[0-7]" }

    string hexDigit() { result = "[0-9a-fA-F]" }
  }

  /**
   * An [integer literal][1]. For example:
   *
   * ```rust
   * 42;
   * ```
   *
   * [1]: https://doc.rust-lang.org/reference/tokens.html#integer-literals
   */
  class IntegerLiteralExpr extends NumberLiteralExpr {
    IntegerLiteralExpr() { this.getTextValue().regexpMatch(IntegerLiteralRegexs::integerLiteral()) }

    /**
     * Get the suffix of this integer literal, if any.
     *
     * For example, `42u8` has the suffix `u8`.
     */
    string getSuffix() {
      exists(string s, string reg |
        s = this.getTextValue() and
        reg = IntegerLiteralRegexs::integerLiteral() and
        result = s.regexpCapture(reg, 13)
      )
    }

    override string getAPrimaryQlClass() { result = "IntegerLiteralExpr" }
  }

  // https://doc.rust-lang.org/reference/tokens.html#floating-point-literals
  private module FloatLiteralRegexs {
    private import IntegerLiteralRegexs

    string floatLiteral() {
      result =
        paren(decLiteral() + "\\.") + "|" + paren(floatLiteralSuffix1()) + "|" +
          paren(floatLiteralSuffix2())
    }

    string floatLiteralSuffix1() {
      result = decLiteral() + "\\." + decLiteral() + paren(suffix()) + "?"
    }

    string floatLiteralSuffix2() {
      result =
        decLiteral() + paren("\\." + decLiteral()) + "?" + paren(exponent()) + paren(suffix()) + "?"
    }

    string integerSuffixLiteral() {
      result =
        paren(paren(decLiteral()) + "|" + paren(binLiteral()) + "|" + paren(octLiteral()) + "|" +
              paren(hexLiteral())) + paren(suffix())
    }

    private string suffix() { result = "f32|f64" }

    string exponent() {
      result = "(e|E)(\\+|-)?(" + decDigit() + "|_)*" + decDigit() + "(" + decDigit() + "|_)*"
    }
  }

  /**
   * A [floating-point literal][1]. For example:
   *
   * ```rust
   * 42.0;
   * ```
   *
   * [1]: https://doc.rust-lang.org/reference/tokens.html#floating-point-literals
   */
  class FloatLiteralExpr extends NumberLiteralExpr {
    FloatLiteralExpr() {
      this.getTextValue()
          .regexpMatch(IntegerLiteralRegexs::paren(FloatLiteralRegexs::floatLiteral()) + "|" +
              IntegerLiteralRegexs::paren(FloatLiteralRegexs::integerSuffixLiteral())) and
      // E.g. `0x01_f32` is an integer, not a float
      not this instanceof IntegerLiteralExpr
    }

    /**
     * Get the suffix of this floating-point literal, if any.
     *
     * For example, `42.0f32` has the suffix `f32`.
     */
    string getSuffix() {
      exists(string s, string reg, int group |
        reg = FloatLiteralRegexs::floatLiteralSuffix1() and
        group = 3
        or
        reg = FloatLiteralRegexs::floatLiteralSuffix2() and
        group = 9
        or
        reg = FloatLiteralRegexs::integerSuffixLiteral() and
        group = 13
      |
        s = this.getTextValue() and
        result = s.regexpCapture(reg, group)
      )
    }

    override string getAPrimaryQlClass() { result = "FloatLiteralExpr" }
  }

  /**
   * A Boolean literal. Either `true` or `false`.
   */
  class BooleanLiteralExpr extends LiteralExpr {
    BooleanLiteralExpr() { this.getTextValue() = ["false", "true"] }

    override string getAPrimaryQlClass() { result = "BooleanLiteralExpr" }
  }
}
