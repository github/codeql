private import codeql.ruby.AST
private import codeql.ruby.CFG
private import internal.AST
private import internal.Constant
private import internal.Expr
private import internal.TreeSitter

/**
 * An expression.
 *
 * This is the root QL class for all expressions.
 */
class Expr extends Stmt, TExpr {
  /** Gets the constant value of this expression, if any. */
  ConstantValue getConstantValue() { result = getConstantValueExpr(this) }
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
class ArgumentList extends Expr, TArgumentList {
  private Ruby::AstNode g;

  ArgumentList() { this = TArgumentList(g) }

  /** Gets the `i`th element in this argument list. */
  Expr getElement(int i) {
    toGenerated(result) in [
        g.(Ruby::ArgumentList).getChild(i), g.(Ruby::RightAssignmentList).getChild(i)
      ]
  }

  final override string getAPrimaryQlClass() { result = "ArgumentList" }

  final override string toString() { result = "..., ..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getElement" and result = this.getElement(_)
  }
}

private class LhsExpr_ =
  TVariableAccess or TTokenConstantAccess or TScopeResolutionConstantAccess or TMethodCall or
      TDestructuredLhsExpr or TConstantWriteAccessSynth;

/**
 * A "left-hand-side" (LHS) expression. An `LhsExpr` can occur on the left-hand side of
 * operator assignments (`AssignOperation`), on the left-hand side of assignments
 * (`AssignExpr`), as patterns in for loops (`ForExpr`), and as exception variables
 * in `rescue` clauses (`RescueClause`).
 *
 * An `LhsExpr` can be a simple variable, a constant, a call, or an element reference:
 *
 * ```rb
 * var = 1
 * var += 1
 * E = 1
 * foo.bar = 1
 * foo[0] = 1
 * rescue E => var
 * ```
 */
class LhsExpr extends Expr, LhsExpr_ {
  LhsExpr() { lhsExpr(this) }

  /** Gets a variable used in (or introduced by) this LHS. */
  Variable getAVariable() { result = this.(VariableAccess).getVariable() }
}

/**
 * A "left-hand-side" (LHS) expression of a destructured assignment.
 *
 * Examples:
 * ```rb
 * a, self.b = value
 * (a, b), c[3] = value
 * a, b, *rest, c, d = value
 * ```
 */
class DestructuredLhsExpr extends LhsExpr, TDestructuredLhsExpr {
  override string getAPrimaryQlClass() { result = "DestructuredLhsExpr" }

  private DestructuredLhsExprImpl getImpl() { result = toGenerated(this) }

  private Ruby::AstNode getChild(int i) { result = this.getImpl().getChildNode(i) }

  /** Gets the `i`th element in this destructured LHS. */
  final Expr getElement(int i) {
    exists(Ruby::AstNode c | c = this.getChild(i) |
      toGenerated(result) = c.(Ruby::RestAssignment).getChild()
      or
      toGenerated(result) = c
    )
  }

  /** Gets an element in this destructured LHS. */
  final Expr getAnElement() { result = this.getElement(_) }

  /**
   * Gets the index of the element with the `*` marker on it, if it exists.
   * In the example below the index is `2`.
   * ```rb
   * a, b, *rest, c, d = value
   * ```
   */
  final int getRestIndex() { result = this.getImpl().getRestIndex() }

  override Variable getAVariable() {
    result = this.getElement(_).(VariableWriteAccess).getVariable()
    or
    result = this.getElement(_).(DestructuredLhsExpr).getAVariable()
  }

  override string toString() { result = "(..., ...)" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getElement" and result = this.getElement(_)
  }
}

/** A sequence of expressions. */
class StmtSequence extends Expr, TStmtSequence {
  override string getAPrimaryQlClass() { result = "StmtSequence" }

  /** Gets the `n`th statement in this sequence. */
  Stmt getStmt(int n) { none() }

  /** Gets a statement in this sequence. */
  final Stmt getAStmt() { result = this.getStmt(_) }

  /** Gets the last statement in this sequence, if any. */
  final Stmt getLastStmt() { result = this.getStmt(this.getNumberOfStatements() - 1) }

  /** Gets the number of statements in this sequence. */
  final int getNumberOfStatements() { result = count(this.getAStmt()) }

  /** Holds if this sequence has no statements. */
  final predicate isEmpty() { this.getNumberOfStatements() = 0 }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getStmt" and result = this.getStmt(_)
  }
}

/**
 * A sequence of statements representing the body of a method, class, module,
 * or do-block. That is, any body that may also include rescue/ensure/else
 * statements.
 */
class BodyStmt extends StmtSequence, TBodyStmt {
  final override Stmt getStmt(int n) {
    toGenerated(result) =
      rank[n + 1](Ruby::AstNode node, int i |
        node = getBodyStmtChild(this, i) and
        not node instanceof Ruby::Else and
        not node instanceof Ruby::Rescue and
        not node instanceof Ruby::Ensure
      |
        node order by i
      )
  }

  /** Gets the `n`th rescue clause in this block. */
  final RescueClause getRescue(int n) {
    result =
      rank[n + 1](RescueClause node, int i |
        toGenerated(node) = getBodyStmtChild(this, i)
      |
        node order by i
      )
  }

  /** Gets a rescue clause in this block. */
  final RescueClause getARescue() { result = this.getRescue(_) }

  /** Gets the `else` clause in this block, if any. */
  final StmtSequence getElse() {
    result = unique(Else s | toGenerated(s) = getBodyStmtChild(this, _))
  }

  /** Gets the `ensure` clause in this block, if any. */
  final StmtSequence getEnsure() {
    result = unique(Ensure s | toGenerated(s) = getBodyStmtChild(this, _))
  }

  /** Holds if this block has an `ensure` block. */
  final predicate hasEnsure() { exists(this.getEnsure()) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getRescue" and result = this.getRescue(_)
    or
    pred = "getElse" and result = this.getElse()
    or
    pred = "getEnsure" and result = this.getEnsure()
  }
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
class ParenthesizedExpr extends StmtSequence, TParenthesizedExpr {
  private Ruby::ParenthesizedStatements g;

  ParenthesizedExpr() { this = TParenthesizedExpr(g) }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string getAPrimaryQlClass() { result = "ParenthesizedExpr" }

  final override string toString() { result = "( ... )" }
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
class Pair extends Expr, TPair {
  private Ruby::Pair g;

  Pair() { this = TPair(g) }

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
  final Expr getKey() { toGenerated(result) = g.getKey() }

  /**
   * Gets the value expression of this pair. For example, the `IntegerLiteral`
   * 123 in the following hash pair:
   * ```rb
   * { 'foo' => 123 }
   * ```
   */
  final Expr getValue() {
    toGenerated(result) = g.getValue() or
    synthChild(this, 0, result)
  }

  final override string toString() { result = "Pair" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getKey" and result = this.getKey()
    or
    pred = "getValue" and result = this.getValue()
  }
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
class RescueClause extends Expr, TRescueClause {
  private Ruby::Rescue g;

  RescueClause() { this = TRescueClause(g) }

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
  final Expr getException(int n) { toGenerated(result) = g.getExceptions().getChild(n) }

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
  final Expr getAnException() { result = this.getException(_) }

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
  final LhsExpr getVariableExpr() { toGenerated(result) = g.getVariable().getChild() }

  /**
   * Gets the exception handler body.
   */
  final StmtSequence getBody() { toGenerated(result) = g.getBody() }

  final override string toString() { result = "rescue ..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getException" and result = this.getException(_)
    or
    pred = "getVariableExpr" and result = this.getVariableExpr()
    or
    pred = "getBody" and result = this.getBody()
  }
}

/**
 * An expression with a `rescue` modifier. For example:
 * ```rb
 * contents = read_file rescue ""
 * ```
 */
class RescueModifierExpr extends Expr, TRescueModifierExpr {
  private Ruby::RescueModifier g;

  RescueModifierExpr() { this = TRescueModifierExpr(g) }

  final override string getAPrimaryQlClass() { result = "RescueModifierExpr" }

  /**
   * Gets the body of this `RescueModifierExpr`.
   * ```rb
   * body rescue handler
   * ```
   */
  final Stmt getBody() { toGenerated(result) = g.getBody() }

  /**
   * Gets the exception handler of this `RescueModifierExpr`.
   * ```rb
   * body rescue handler
   * ```
   */
  final Stmt getHandler() { toGenerated(result) = g.getHandler() }

  final override string toString() { result = "... rescue ..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getBody" and result = this.getBody()
    or
    pred = "getHandler" and result = this.getHandler()
  }
}

/**
 * A concatenation of string literals.
 *
 * ```rb
 * "foo" "bar" "baz"
 * ```
 */
class StringConcatenation extends Expr, TStringConcatenation {
  private Ruby::ChainedString g;

  StringConcatenation() { this = TStringConcatenation(g) }

  final override string getAPrimaryQlClass() { result = "StringConcatenation" }

  /** Gets the `n`th string literal in this concatenation. */
  final StringLiteral getString(int n) { toGenerated(result) = g.getChild(n) }

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
    forall(StringLiteral c | c = this.getString(_) |
      exists(c.getConstantValue().getStringlikeValue())
    ) and
    result =
      concat(string valueText, int i |
        valueText = this.getString(i).getConstantValue().getStringlikeValue()
      |
        valueText order by i
      )
  }

  final override string toString() { result = "\"...\" \"...\"" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getString" and result = this.getString(_)
  }
}
