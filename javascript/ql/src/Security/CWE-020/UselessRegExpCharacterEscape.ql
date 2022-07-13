/**
 * @name Useless regular-expression character escape
 * @description Prepending a backslash to an ordinary character in a string
 *              does not have any effect, and may make regular expressions constructed from this string
 *              behave unexpectedly.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id js/useless-regexp-character-escape
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import javascript
import semmle.javascript.CharacterEscapes::CharacterEscapes

newtype TRegExpPatternMistake =
  /**
   * A character escape mistake in regular expression string `src`
   * for the character `char` at `index` in `rawStringNode`, explained
   * by `mistake`.
   */
  TIdentityEscapeInStringMistake(
    RegExpPatternSource src, string char, string mistake, AstNode rawStringNode, int index
  ) {
    char = getALikelyRegExpPatternMistake(src, mistake, rawStringNode, index)
  } or
  /**
   * A backslash-escaped 'b' at `index` of `rawStringNode` in the
   * regular expression string `src`, indicating intent to use the
   * word-boundary assertion '\b'.
   */
  TBackspaceInStringMistake(RegExpPatternSource src, AstNode rawStringNode, int index) {
    exists(string raw, string cooked |
      exists(StringLiteral lit | lit = rawStringNode |
        rawStringNode = src.asExpr() and
        raw = lit.getRawValue() and
        cooked = lit.getStringValue()
      )
      or
      exists(TemplateElement elem | elem = rawStringNode |
        rawStringNode = src.asExpr().(TemplateLiteral).getAnElement() and
        raw = elem.getRawValue() and
        cooked = elem.getStringValue()
      )
    |
      "b" = getAnEscapedCharacter(raw, index) and
      // except if the string is exactly \b
      cooked.length() != 1
    )
  }

/**
 * A character escape mistake in a regular expression string.
 *
 * Implementation note: the main purpose of this class is to associate an
 * exact character location with an alert message, in the name of
 * user-friendly alerts. The implementation can be simplified
 * significantly by only using the enclosing string location as the alert
 * location.
 */
class RegExpPatternMistake extends TRegExpPatternMistake {
  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(int srcStartcolumn, int srcEndcolumn, int index |
      index = getIndex() and
      getRawStringNode()
          .getLocation()
          .hasLocationInfo(filepath, startline, srcStartcolumn, endline, srcEndcolumn)
    |
      (
        if startline = endline
        then startcolumn = srcStartcolumn + index - 1 and endcolumn = srcStartcolumn + index
        else (
          startcolumn = srcStartcolumn and endcolumn = srcEndcolumn
        )
      )
    )
  }

  /** Gets a textual representation of this element. */
  string toString() { result = getMessage() }

  abstract AstNode getRawStringNode();

  abstract RegExpPatternSource getSrc();

  abstract int getIndex();

  abstract string getMessage();
}

/**
 * An identity-escaped character that indicates programmer intent to
 * do something special in a regular expression.
 */
class IdentityEscapeInStringMistake extends RegExpPatternMistake, TIdentityEscapeInStringMistake {
  RegExpPatternSource src;
  string char;
  string mistake;
  int index;
  AstNode rawStringNode;

  IdentityEscapeInStringMistake() {
    this = TIdentityEscapeInStringMistake(src, char, mistake, rawStringNode, index)
  }

  override string getMessage() {
    result = "'\\" + char + "' is equivalent to just '" + char + "', so the sequence " + mistake
  }

  override int getIndex() { result = index }

  override RegExpPatternSource getSrc() { result = src }

  override AstNode getRawStringNode() { result = rawStringNode }
}

/**
 * A backspace as '\b' in a regular expression string, indicating
 * programmer intent to use the word-boundary assertion '\b'.
 */
class BackspaceInStringMistake extends RegExpPatternMistake, TBackspaceInStringMistake {
  RegExpPatternSource src;
  int index;
  AstNode rawStringNode;

  BackspaceInStringMistake() { this = TBackspaceInStringMistake(src, rawStringNode, index) }

  override string getMessage() {
    result = "'\\b' is a backspace, and not a word-boundary assertion"
  }

  override int getIndex() { result = index }

  override RegExpPatternSource getSrc() { result = src }

  override AstNode getRawStringNode() { result = rawStringNode }
}

from RegExpPatternMistake mistake
select mistake, "The escape sequence " + mistake.getMessage() + " when it is used in a $@.",
  mistake.getSrc().getAParse(), "regular expression"
