/**
 * @id java/non-explicit-control-and-whitespace-chars-in-literals
 * @name Non-explicit control and whitespace characters
 * @description Non-explicit control and whitespace characters in literals make code more difficult
 *              to read and may lead to incorrect program behavior.
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 * @tags quality
 *       correctness
 *       maintainability
 *       readability
 */

import java

/**
 * A `Literal` that has a Unicode control character within its
 * literal value (as returned by `getLiteral()` member predicate).
 */
class ReservedUnicodeInLiteral extends Literal {
  private int indexStart;

  ReservedUnicodeInLiteral() {
    not this instanceof CharacterLiteral and
    exists(int codePoint |
      this.getLiteral().codePointAt(indexStart) = codePoint and
      (
        // Unicode C0 control characters
        codePoint < 32 and not codePoint in [9, 10, 12, 13]
        or
        codePoint = 127 // delete control character
        or
        codePoint = 8203 // zero-width space
      )
    )
  }

  /** Gets the starting index of the Unicode control sequence. */
  int getIndexStart() { result = indexStart }
}

from ReservedUnicodeInLiteral literal, int charIndex, int codePoint
where
  literal.getIndexStart() = charIndex and
  literal.getLiteral().codePointAt(charIndex) = codePoint and
  not literal.getEnclosingCallable() instanceof LikelyTestMethod and
  not literal.getFile().isKotlinSourceFile()
select literal,
  "Literal value contains control or non-printable whitespace character(s) starting with Unicode code point "
    + codePoint + " at index " + charIndex + "."
