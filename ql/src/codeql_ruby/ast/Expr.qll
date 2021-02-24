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
 * A sequence of expressions in the right-hand side of an assignment or
 * a `return`, `break` or `next` statement.
 * ```rb
 * x = 1, *items, 3, *more
 * return 1, 2
 * next *list
 * break **map
 * return 1, 2, *items, k: 5, **map
 * ```
 */
class ArgumentList extends Expr {
  override ArgumentList::Range range;

  override string getAPrimaryQlClass() { result = "ArgumentList" }
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
  final RescueClause getRescue(int n) { result = range.getRescue(n) }

  /** Gets a rescue clause in this block. */
  final RescueClause getARescue() { result = this.getRescue(_) }

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
class RescueClause extends Expr, @rescue {
  final override RescueClause::Range range;

  final override string getAPrimaryQlClass() { result = "RescueClause" }

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
  final LhsExpr getVariableExpr() { result = range.getVariableExpr() }

  /**
   * Gets the exception handler body.
   */
  final StmtSequence getBody() { result = range.getBody() }
}

/**
 * An expression with a `rescue` modifier. For example:
 * ```rb
 * contents = read_file rescue ""
 * ```
 */
class RescueModifierExpr extends Expr, @rescue_modifier {
  final override RescueModifierExpr::Range range;

  final override string getAPrimaryQlClass() { result = "RescueModifierExpr" }

  /**
   * Gets the body of this `RescueModifierExpr`.
   * ```rb
   * body rescue handler
   * ```
   */
  final Stmt getBody() { result = range.getBody() }

  /**
   * Gets the exception handler of this `RescueModifierExpr`.
   * ```rb
   * body rescue handler
   * ```
   */
  final Stmt getHandler() { result = range.getHandler() }
}

/**
 * A concatenation of string literals.
 *
 * ```rb
 * "foo" "bar" "baz"
 * ```
 */
class StringConcatenation extends Expr, @chained_string {
  final override StringConcatenation::Range range;

  final override string getAPrimaryQlClass() { result = "StringConcatenation" }

  /** Gets the `n`th string literal in this concatenation. */
  final StringLiteral getString(int n) { result = range.getString(n) }

  /** Gets a string literal in this concatenation. */
  final StringLiteral getAString() { result = this.getString(_) }

  /** Gets the number of string literals in this concatenation. */
  final int getNumberOfStrings() { result = count(this.getString(_)) }

  /**
   * Gets the result of concatenating all the string literals, if and only if
   * they do not contain any interpolations.
   *
   * For the following example, the result is `"foobar"`:
   *
   * ```rb
   * "foo" 'bar'
   * ```
   *
   * And for the following example, where one of the string literals includes
   * an interpolation, there is no result:
   *
   * ```rb
   * "foo" "bar#{ n }"
   * ```
   */
  final string getConcatenatedValueText() {
    forall(StringLiteral c | c = this.getString(_) | exists(c.getValueText())) and
    result =
      concat(string valueText, int i |
        valueText = this.getString(i).getValueText()
      |
        valueText order by i
      )
  }
}
