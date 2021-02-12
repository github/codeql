private import codeql_ruby.AST
private import internal.Expr

/**
 * An expression.
 *
 * This is the root QL class for all expressions.
 */
class Expr extends Stmt {
  override Expr::Range range;

  Expr() { this = range }
}

/**
 * A reference to the current object. For example:
 * - `self == other`
 * - `self.method_name`
 * - `def self.method_name ... end`
 */
class Self extends Expr, @token_self {
  override Self::Range range;

  final override string getAPrimaryQlClass() { result = "Self" }
}

/**
 * A literal.
 *
 * This is the QL root class for all literals.
 */
class Literal extends Expr {
  override Literal::Range range;

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
class StmtSequence extends Expr {
  override StmtSequence::Range range;

  override string getAPrimaryQlClass() { result = "StmtSequence" }

  /** Gets the `n`th statement in this sequence. */
  final Stmt getStmt(int n) { result = range.getStmt(n) }

  /** Gets a statement in this sequence. */
  final Stmt getAStmt() { result = this.getStmt(_) }

  /** Gets the last expression in this sequence, if any. */
  final Expr getLastExpr() { result = this.getStmt(this.getNumberOfStatements() - 1) }

  /** Gets the number of statements in this sequence. */
  final int getNumberOfStatements() { result = count(this.getAStmt()) }

  /** Holds if this sequence has no statements. */
  final predicate isEmpty() { this.getNumberOfStatements() = 0 }
}

/**
 * A sequence of statements representing the body of a method, class, module,
 * or do-block. That is, any body that may also include rescue/ensure/else
 * statements.
 */
class BodyStatement extends StmtSequence {
  override BodyStatement::Range range;

  /** Gets the `n`th rescue clause in this block. */
  final Rescue getRescue(int n) { result = range.getRescue(n) }

  /** Gets a rescue clause in this block. */
  final Rescue getARescue() { result = this.getRescue(_) }

  /** Gets the `else` clause in this block, if any. */
  final StmtSequence getElse() { result = range.getElse() }

  /** Gets the `ensure` clause in this block, if any. */
  final StmtSequence getEnsure() { result = range.getEnsure() }

  final predicate hasEnsure() { exists(this.getEnsure()) }
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
class ParenthesizedExpr extends StmtSequence, @parenthesized_statements {
  final override ParenthesizedExpr::Range range;

  final override string getAPrimaryQlClass() { result = "ParenthesizedExpr" }
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

/**
 * A rescue clause. For example:
 * ```rb
 * begin
 *   write_file
 * rescue StandardError => msg
 *   puts msg
 * end
 */
class Rescue extends Expr, @rescue {
  final override Rescue::Range range;

  /**
   * Gets the `n`th exception to match, if any. For example `FirstError` or `SecondError` in:
   * ```rb
   * begin
   *  do_something
   * rescue FirstError, SecondError => e
   *   handle_error(e)
   * end
   * ```
   */
  final Expr getException(int n) { result = range.getException(n) }

  /**
   * Gets an exception to match, if any. For example `FirstError` or `SecondError` in:
   * ```rb
   * begin
   *  do_something
   * rescue FirstError, SecondError => e
   *   handle_error(e)
   * end
   * ```
   */
  final Expr getAnException() { result = getException(_) }

  /**
   * Gets the variable to which to assign the matched exception, if any.
   * For example `err` in:
   * ```rb
   * begin
   *  do_something
   * rescue StandardError => err
   *   handle_error(err)
   * end
   * ```
   */
  final Expr getVariableExpr() { result = range.getVariableExpr() }

  /**
   * Gets the exception handler body.
   */
  final StmtSequence getBody() { result = range.getBody() }
}
