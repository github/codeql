private import codeql_ruby.AST
private import internal.Expr

/**
 * An expression.
 *
 * This is the root QL class for all expressions.
 */
class Expr extends AstNode {
  Expr::Range range;

  Expr() { this = range }
}

/**
 * A literal.
 *
 * This is the QL root class for all literals.
 */
class Literal extends Expr {
  override Literal::Range range;

  override string toString() { result = this.getValueText() }

  /** Gets the source text for this literal. */
  final string getValueText() { result = range.getValueText() }
}

/**
 * An integer literal.
 * ```rb
 * x = 123
 * y = 0xff
 * ```
 */
class IntegerLiteral extends Literal, @token_integer {
  final override IntegerLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "IntegerLiteral" }
}

/** A `nil` literal. */
class NilLiteral extends Literal, @token_nil {
  final override NilLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "NilLiteral" }
}

/**
 * A Boolean literal.
 * ```rb
 * true
 * false
 * TRUE
 * FALSE
 * ```
 */
class BooleanLiteral extends Literal, BooleanLiteral::DbUnion {
  final override BooleanLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "BooleanLiteral" }

  /** Holds if the Boolean literal is `true` or `TRUE`. */
  predicate isTrue() { range.isTrue() }

  /** Holds if the Boolean literal is `false` or `FALSE`. */
  predicate isFalse() { range.isFalse() }
}

// TODO: expand this. It's a minimal placeholder so we can test `=~` and `!~`.
class RegexLiteral extends Literal, @regex {
  final override RegexLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "RegexLiteral" }
}

/** A sequence of expressions. */
class ExprSequence extends Expr {
  override ExprSequence::Range range;

  final override string getAPrimaryQlClass() { result = "ExprSequence" }

  final override string toString() { result = "...; ..." }

  /** Gets the `n`th expression in this sequence. */
  final Expr getExpr(int n) { result = range.getExpr(n) }

  /** Gets an expression in this sequence. */
  final Expr getAnExpr() { result = this.getExpr(_) }

  /** Gets the last expression in this sequence, if any. */
  final Expr getLastExpr() { result = this.getExpr(this.getNumberOfExpressions() - 1) }

  /** Gets the number of expressions in this sequence. */
  final int getNumberOfExpressions() { result = count(this.getAnExpr()) }

  /** Holds if this sequence has no expressions. */
  final predicate isEmpty() { this.getNumberOfExpressions() = 0 }
}
