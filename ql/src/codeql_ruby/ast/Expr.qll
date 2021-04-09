private import codeql_ruby.AST
private import internal.AST
private import internal.TreeSitter

/**
 * An expression.
 *
 * This is the root QL class for all expressions.
 */
class Expr extends Stmt, TExpr { }

/**
 * A reference to the current object. For example:
 * - `self == other`
 * - `self.method_name`
 * - `def self.method_name ... end`
 */
class Self extends Expr, TSelf {
  final override string getAPrimaryQlClass() { result = "Self" }

  final override string toString() { result = "self" }
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
  private Generated::AstNode g;

  ArgumentList() { this = TArgumentList(g) }

  /** Gets the `i`th element in this argument list. */
  Expr getElement(int i) {
    toGenerated(result) in [
        g.(Generated::ArgumentList).getChild(i), g.(Generated::RightAssignmentList).getChild(i)
      ]
  }

  final override string getAPrimaryQlClass() { result = "ArgumentList" }

  final override string toString() { result = "..., ..." }

  final override AstNode getAChild(string pred) {
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

  override AstNode getAChild(string pred) { pred = "getStmt" and result = this.getStmt(_) }
}

private class Then extends StmtSequence, TThen {
  private Generated::Then g;

  Then() { this = TThen(g) }

  override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "then ..." }
}

private class Else extends StmtSequence, TElse {
  private Generated::Else g;

  Else() { this = TElse(g) }

  override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "else ..." }
}

private class Do extends StmtSequence, TDo {
  private Generated::Do g;

  Do() { this = TDo(g) }

  override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "do ..." }
}

private class Ensure extends StmtSequence, TEnsure {
  private Generated::Ensure g;

  Ensure() { this = TEnsure(g) }

  override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "ensure ..." }
}

/**
 * A sequence of statements representing the body of a method, class, module,
 * or do-block. That is, any body that may also include rescue/ensure/else
 * statements.
 */
class BodyStmt extends StmtSequence, TBodyStmt {
  // Not defined by dispatch, as it should not be exposed
  private Generated::AstNode getChild(int i) {
    result = any(Generated::Method g | this = TMethodDeclaration(g)).getChild(i)
    or
    result = any(Generated::SingletonMethod g | this = TSingletonMethod(g)).getChild(i)
    or
    exists(Generated::Lambda g | this = TLambda(g) |
      result = g.getBody().(Generated::DoBlock).getChild(i) or
      result = g.getBody().(Generated::Block).getChild(i)
    )
    or
    result = any(Generated::DoBlock g | this = TDoBlock(g)).getChild(i)
    or
    result = any(Generated::Program g | this = TToplevel(g)).getChild(i) and
    not result instanceof Generated::BeginBlock
    or
    result = any(Generated::Class g | this = TClassDeclaration(g)).getChild(i)
    or
    result = any(Generated::SingletonClass g | this = TSingletonClass(g)).getChild(i)
    or
    result = any(Generated::Module g | this = TModuleDeclaration(g)).getChild(i)
    or
    result = any(Generated::Begin g | this = TBeginExpr(g)).getChild(i)
  }

  final override Stmt getStmt(int n) {
    result =
      rank[n + 1](AstNode node, int i |
        toGenerated(node) = this.getChild(i) and
        not node instanceof Else and
        not node instanceof RescueClause and
        not node instanceof Ensure
      |
        node order by i
      )
  }

  /** Gets the `n`th rescue clause in this block. */
  final RescueClause getRescue(int n) {
    result =
      rank[n + 1](RescueClause node, int i | toGenerated(node) = getChild(i) | node order by i)
  }

  /** Gets a rescue clause in this block. */
  final RescueClause getARescue() { result = this.getRescue(_) }

  /** Gets the `else` clause in this block, if any. */
  final StmtSequence getElse() { result = unique(Else s | toGenerated(s) = getChild(_)) }

  /** Gets the `ensure` clause in this block, if any. */
  final StmtSequence getEnsure() { result = unique(Ensure s | toGenerated(s) = getChild(_)) }

  final predicate hasEnsure() { exists(this.getEnsure()) }

  override AstNode getAChild(string pred) {
    result = StmtSequence.super.getAChild(pred)
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
  private Generated::ParenthesizedStatements g;

  ParenthesizedExpr() { this = TParenthesizedExpr(g) }

  final override string getAPrimaryQlClass() { result = "ParenthesizedExpr" }

  final override string toString() { result = "( ... )" }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }
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
  private Generated::Pair g;

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
   * Gets the value expression of this pair. For example, the `InteralLiteral`
   * 123 in the following hash pair:
   * ```rb
   * { 'foo' => 123 }
   * ```
   */
  final Expr getValue() { toGenerated(result) = g.getValue() }

  final override string toString() { result = "Pair" }

  override AstNode getAChild(string pred) {
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
  private Generated::Rescue g;

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

  override AstNode getAChild(string pred) {
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
  private Generated::RescueModifier g;

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

  override AstNode getAChild(string pred) {
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
  private Generated::ChainedString g;

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
    forall(StringLiteral c | c = this.getString(_) | exists(c.getValueText())) and
    result =
      concat(string valueText, int i |
        valueText = this.getString(i).getValueText()
      |
        valueText order by i
      )
  }

  final override string toString() { result = "\"...\" \"...\"" }

  override AstNode getAChild(string pred) { pred = "getString" and result = this.getString(_) }
}
