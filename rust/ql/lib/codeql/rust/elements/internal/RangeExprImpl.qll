/**
 * This module provides a hand-modifiable wrapper around the generated class `RangeExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RangeExpr

/**
 * INTERNAL: This module contains the customizable definition of `RangeExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A range expression. For example:
   * ```rust
   * let x = 1..=10;
   * let x = 1..10;
   * let x = 10..;
   * let x = ..10;
   * let x = ..=10;
   * let x = ..;
   * ```
   */
  class RangeExpr extends Generated::RangeExpr {
    override string toString() { result = concat(int i | | this.toStringPart(i) order by i) }

    private string toStringPart(int index) {
      index = 0 and result = this.getStartAbbreviation()
      or
      index = 1 and result = this.getOperatorName()
      or
      index = 2 and result = this.getEndAbbreviation()
    }

    private string getStartAbbreviation() {
      exists(string abbr |
        abbr = this.getStart().toAbbreviatedString() and
        if abbr = "..." then result = "... " else result = abbr
      )
    }

    private string getEndAbbreviation() {
      exists(string abbr |
        abbr = this.getEnd().toAbbreviatedString() and
        if abbr = "..." then result = " ..." else result = abbr
      )
    }
  }
}
