private import codeql_ruby.AST
private import codeql_ruby.CFG
private import internal.Expr
private import internal.Variable
private import codeql_ruby.controlflow.internal.ControlFlowGraphImpl

/**
 * An expression.
 *
 * This is the root QL class for all expressions.
 */
class Expr extends AstNode {
  Expr::Range range;

  Expr() { this = range }

  /** Gets a control-flow node for this expression, if any. */
  CfgNodes::AstCfgNode getAControlFlowNode() { result.getNode() = this }

  /** Gets the control-flow scope of this expression, if any. */
  CfgScope getCfgScope() { result = getCfgScope(this) }

  /** Gets the variable scope that this expression belongs to. */
  VariableScope getVariableScope() { result = enclosingScope(this) }

  /** Gets the enclosing callable, if any. */
  Callable getEnclosingCallable() { result = this.getCfgScope() }
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

  override string getAPrimaryQlClass() { result = "ExprSequence" }

  override string toString() {
    exists(int c | c = this.getNumberOfExpressions() |
      c = 0 and result = ";"
      or
      c = 1 and result = this.getExpr(0).toString()
      or
      c > 1 and result = "...; ..."
    )
  }

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
 * A sequence of expressions representing the body of a method, class, module,
 * or do-block. That is, any body that may also include rescue/ensure/else
 * statements.
 */
class BodyStatement extends ExprSequence {
  override BodyStatement::Range range;
}

/**
 * A parenthesized expression sequence, typically containing a single expression:
 * ```rb
 * (x + 1)
 * ```
 * However, they can also contain multiple expressions (the value of the parenthesized
 * expression is the last expression):
 * ```rb
 * (foo; bar)
 * ```
 * or even an empty sequence (value is `nil`):
 * ```rb
 * ()
 * ```
 */
class ParenthesizedExpr extends ExprSequence, @parenthesized_statements {
  final override ParenthesizedExpr::Range range;

  final override string getAPrimaryQlClass() { result = "ParenthesizedExpr" }

  final override string toString() {
    exists(int c | c = this.getNumberOfExpressions() |
      c = 0 and result = "()"
      or
      c > 0 and result = "(" + ExprSequence.super.toString() + ")"
    )
  }
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
