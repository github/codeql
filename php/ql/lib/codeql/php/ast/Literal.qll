/**
 * Provides classes for PHP literal expressions.
 */

private import codeql.php.AST
private import internal.TreeSitter

/** A literal expression. */
class Literal extends Expr, @php_literal {
  override string getAPrimaryQlClass() { result = "Literal" }
}

/** An integer literal. */
class IntegerLiteral extends Literal, @php_token_integer {
  override string getAPrimaryQlClass() { result = "IntegerLiteral" }

  /** Gets the string representation of the integer value. */
  string getValue() { php_tokeninfo(this, _, result) }

  override string toString() { result = this.getValue() }
}

/** A float literal. */
class FloatLiteral extends Literal, @php_token_float {
  override string getAPrimaryQlClass() { result = "FloatLiteral" }

  string getValue() { php_tokeninfo(this, _, result) }

  override string toString() { result = this.getValue() }
}

/** A string literal. */
class StringLiteral extends Literal, @php_string__ {
  override string getAPrimaryQlClass() { result = "StringLiteral" }

  override string toString() { result = "\"...\"" }
}

/** An encapsed (interpolated) string. */
class EncapsedString extends Literal, @php_encapsed_string {
  override string getAPrimaryQlClass() { result = "EncapsedString" }

  /** Gets the i-th element (string content or interpolated expression). */
  AstNode getElement(int i) { php_encapsed_string_child(this, i, result) }

  /** Gets an element of this encapsed string. */
  AstNode getAnElement() { result = this.getElement(_) }

  override string toString() { result = "\"...\"" }
}

/** A heredoc string. */
class Heredoc extends Literal, @php_heredoc {
  override string getAPrimaryQlClass() { result = "Heredoc" }

  override string toString() { result = "<<<..." }
}

/** A nowdoc string. */
class Nowdoc extends Literal, @php_nowdoc {
  override string getAPrimaryQlClass() { result = "Nowdoc" }

  override string toString() { result = "<<<'...'" }
}

/** A boolean literal (`true` or `false`). */
class BooleanLiteral extends Literal, @php_token_boolean {
  override string getAPrimaryQlClass() { result = "BooleanLiteral" }

  string getValue() { php_tokeninfo(this, _, result) }

  /** Holds if this is the `true` literal. */
  predicate isTrue() { this.getValue().toLowerCase() = "true" }

  /** Holds if this is the `false` literal. */
  predicate isFalse() { this.getValue().toLowerCase() = "false" }

  override string toString() { result = this.getValue() }
}

/** A null literal. */
class NullLiteral extends Literal, @php_token_null {
  override string getAPrimaryQlClass() { result = "NullLiteral" }

  override string toString() { result = "null" }
}
