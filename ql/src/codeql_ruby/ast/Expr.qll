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

  override string toString() { result = range.toString() }

  /** Gets the source text for this literal, if it is constant. */
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

/**
 * A string literal.
 * ```rb
 * 'hello'
 * "hello, #{name}"
 * ```
 * TODO: expand this minimal placeholder.
 */
class StringLiteral extends Literal, @string__ {
  final override StringLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "StringLiteral" }
}

/**
 * A symbol literal.
 * ```rb
 * :foo
 * :"foo bar"
 * :"foo bar #{baz}"
 * ```
 * TODO: expand this minimal placeholder.
 */
class SymbolLiteral extends Literal {
  final override SymbolLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "SymbolLiteral" }
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

/**
 * A scope resolution, typically used to access constants defined in a class or
 * module.
 * ```rb
 * Foo::Bar
 * ```
 */
class ScopeResolution extends Expr, @scope_resolution {
  final override ScopeResolution::Range range;

  final override string getAPrimaryQlClass() { result = "ScopeResolution" }

  final override string toString() { result = "...::" + this.getName() }

  /**
   * Gets the expression representing the scope, if any. In the following
   * example, the scope is the `Expr` for `Foo`:
   * ```rb
   * Foo::Bar
   * ```
   * However, in the following example, accessing the `Bar` constant in the
   * `Object` class, there is no result:
   * ```rb
   * ::Bar
   * ```
   */
  final Expr getScope() { result = range.getScope() }

  /**
   * Gets the name being resolved. For example, in `Foo::Bar`, the result is
   * `"Bar"`.
   */
  final string getName() { result = range.getName() }
}

/**
 * A pair expression. For example, in a hash:
 * ```rb
 * { foo: bar }
 * ```
 * Or a keyword argument:
 * ```rb
 * baz(qux: 1)
 * ```
 */
class Pair extends Expr, @pair {
  final override Pair::Range range;

  final override string getAPrimaryQlClass() { result = "Pair" }

  final override string toString() { result = "Pair" }

  /**
   * Gets the key expression of this pair. For example, the `SymbolLiteral`
   * representing the keyword `foo` in the following example:
   * ```rb
   * bar(foo: 123)
   * ```
   * Or the `StringLiteral` for `'foo'` in the following hash pair:
   * ```rb
   * { 'foo' => 123 }
   * ```
   */
  final Expr getKey() { result = range.getKey() }

  /**
   * Gets the value expression of this pair. For example, the `InteralLiteral`
   * 123 in the following hash pair:
   * ```rb
   * { 'foo' => 123 }
   * ```
   */
  final Expr getValue() { result = range.getValue() }
}
