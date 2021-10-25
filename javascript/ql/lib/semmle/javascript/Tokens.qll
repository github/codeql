/**
 * Provides classes for working with the token-based representation of JavaScript programs.
 */

import javascript

/**
 * A token occurring in a piece of JavaScript source code.
 *
 * Examples:
 *
 * ```
 * x
 * /\w+/
 * 12.3
 * ;
 * ```
 */
class Token extends Locatable, @token {
  override Location getLocation() { hasLocation(this, result) }

  /** Gets the toplevel syntactic structure to which this token belongs. */
  TopLevel getTopLevel() { tokeninfo(this, _, result, _, _) }

  /** Gets the index of the token inside its toplevel structure. */
  int getIndex() { tokeninfo(this, _, _, result, _) }

  /** Gets the source text of this token. */
  string getValue() { tokeninfo(this, _, _, _, result) }

  /** Gets the token following this token inside the same toplevel structure, if any. */
  Token getNextToken() {
    this.getTopLevel() = result.getTopLevel() and
    this.getIndex() + 1 = result.getIndex()
  }

  /** Gets the token preceding this token inside the same toplevel structure, if any. */
  Token getPreviousToken() { result.getNextToken() = this }

  override string toString() { result = getValue() }
}

/** An end-of-file token. */
class EOFToken extends Token, @token_eof { }

/**
 * A null literal token.
 *
 * Example:
 *
 * ```
 * null
 * ```
 */
class NullLiteralToken extends Token, @token_null_literal { }

/**
 * A Boolean literal token.
 *
 * Examples:
 *
 * ```
 * true
 * false
 * ```
 */
class BooleanLiteralToken extends Token, @token_boolean_literal { }

/**
 * A numeric literal token.
 *
 * Examples:
 *
 * ```
 * 1
 * 2.3
 * ```
 */
class NumericLiteralToken extends Token, @token_numeric_literal { }

/**
 * A string literal token.
 *
 * Examples:
 *
 * ```
 * "hello"
 * 'world!'
 * ```
 */
class StringLiteralToken extends Token, @token_string_literal { }

/**
 * A regular expression literal token.
 *
 * Example:
 *
 * ```
 * /\w+/
 * ```
 */
class RegularExpressionToken extends Token, @token_regular_expression { }

/**
 * An identifier token.
 *
 * Example:
 *
 * ```
 * x
 * ```
 */
class IdentifierToken extends Token, @token_identifier { }

/**
 * A keyword token.
 *
 * Examples:
 *
 * ```
 * function
 * this
 * ```
 */
class KeywordToken extends Token, @token_keyword { }

/**
 * A punctuator token.
 *
 * Examples:
 *
 * ```
 * ;
 * +
 * ```
 */
class PunctuatorToken extends Token, @token_punctuator { }
