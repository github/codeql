private import codeql.ruby.AST
private import internal.AST
private import internal.TreeSitter

/**
 * A control expression that can be any of the following:
 * - `case`
 * - `if`/`unless` (including expression-modifier variants)
 * - ternary-if (`?:`)
 * - `while`/`until` (including expression-modifier variants)
 * - `for`
 */
class ControlExpr extends Expr, TControlExpr { }

/**
 * A conditional expression: `if`/`unless` (including expression-modifier
 * variants), and ternary-if (`?:`) expressions.
 */
class ConditionalExpr extends ControlExpr, TConditionalExpr {
  /**
   * Gets the condition expression. For example, the result is `foo` in the
   * following:
   * ```rb
   * if foo
   *   bar = 1
   * end
   * ```
   */
  Expr getCondition() { none() }

  /**
   * Gets the branch of this conditional expression that is taken when the
   * condition evaluates to `cond`, if any.
   */
  Stmt getBranch(boolean cond) { none() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getCondition" and result = this.getCondition()
    or
    pred = "getBranch" and result = this.getBranch(_)
  }
}

/**
 * An `if` or `elsif` expression.
 * ```rb
 * if x
 *   a += 1
 * elsif y
 *   a += 2
 * end
 * ```
 */
class IfExpr extends ConditionalExpr, TIfExpr {
  final override string getAPrimaryQlClass() { result = "IfExpr" }

  /** Holds if this is an `elsif` expression. */
  predicate isElsif() { none() }

  /** Gets the 'then' branch of this `if`/`elsif` expression. */
  Stmt getThen() { none() }

  /**
   * Gets the `elsif`/`else` branch of this `if`/`elsif` expression, if any. In
   * the following example, the result is a `StmtSequence` containing `b`.
   * ```rb
   * if foo
   *   a
   * else
   *   b
   * end
   * ```
   * But there is no result for the following:
   * ```rb
   * if foo
   *   a
   * end
   * ```
   * There can be at most one result, since `elsif` branches nest. In the
   * following example, `ifExpr.getElse()` returns an `ElsifExpr`, and the
   * `else` branch is nested inside that. To get the `StmtSequence` for the
   * `else` branch, i.e. the one containing `c`, use
   * `getElse().(ElsifExpr).getElse()`.
   * ```rb
   * if foo
   *   a
   * elsif bar
   *   b
   * else
   *   c
   * end
   * ```
   */
  Stmt getElse() { none() }

  final override Stmt getBranch(boolean cond) {
    cond = true and result = this.getThen()
    or
    cond = false and result = this.getElse()
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getThen" and result = this.getThen()
    or
    pred = "getElse" and result = this.getElse()
  }
}

private class If extends IfExpr, TIf {
  private Ruby::If g;

  If() { this = TIf(g) }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  final override Stmt getThen() { toGenerated(result) = g.getConsequence() }

  final override Stmt getElse() { toGenerated(result) = g.getAlternative() }

  final override string toString() { result = "if ..." }
}

private class Elsif extends IfExpr, TElsif {
  private Ruby::Elsif g;

  Elsif() { this = TElsif(g) }

  final override predicate isElsif() { any() }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  final override Stmt getThen() { toGenerated(result) = g.getConsequence() }

  final override Stmt getElse() { toGenerated(result) = g.getAlternative() }

  final override string toString() { result = "elsif ..." }
}

/**
 * An `unless` expression.
 * ```rb
 * unless x == 0
 *   y /= x
 * end
 * ```
 */
class UnlessExpr extends ConditionalExpr, TUnlessExpr {
  private Ruby::Unless g;

  UnlessExpr() { this = TUnlessExpr(g) }

  final override string getAPrimaryQlClass() { result = "UnlessExpr" }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  /**
   * Gets the 'then' branch of this `unless` expression. In the following
   * example, the result is the `StmtSequence` containing `foo`.
   * ```rb
   * unless a == b then
   *   foo
   * else
   *   bar
   * end
   * ```
   */
  final Stmt getThen() { toGenerated(result) = g.getConsequence() }

  /**
   * Gets the 'else' branch of this `unless` expression. In the following
   * example, the result is the `StmtSequence` containing `bar`.
   * ```rb
   * unless a == b then
   *   foo
   * else
   *   bar
   * end
   * ```
   */
  final Stmt getElse() { toGenerated(result) = g.getAlternative() }

  final override Expr getBranch(boolean cond) {
    cond = false and result = this.getThen()
    or
    cond = true and result = this.getElse()
  }

  final override string toString() { result = "unless ..." }

  override AstNode getAChild(string pred) {
    result = ConditionalExpr.super.getAChild(pred)
    or
    pred = "getThen" and result = this.getThen()
    or
    pred = "getElse" and result = this.getElse()
  }
}

/**
 * An expression modified using `if`.
 * ```rb
 * foo if bar
 * ```
 */
class IfModifierExpr extends ConditionalExpr, TIfModifierExpr {
  private Ruby::IfModifier g;

  IfModifierExpr() { this = TIfModifierExpr(g) }

  final override string getAPrimaryQlClass() { result = "IfModifierExpr" }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  final override Stmt getBranch(boolean cond) { cond = true and result = this.getBody() }

  /**
   * Gets the statement that is conditionally evaluated. In the following
   * example, the result is the `Expr` for `foo`.
   * ```rb
   * foo if bar
   * ```
   */
  final Stmt getBody() { toGenerated(result) = g.getBody() }

  final override string toString() { result = "... if ..." }

  override AstNode getAChild(string pred) {
    result = ConditionalExpr.super.getAChild(pred)
    or
    pred = "getBody" and result = this.getBody()
  }
}

/**
 * An expression modified using `unless`.
 * ```rb
 * y /= x unless x == 0
 * ```
 */
class UnlessModifierExpr extends ConditionalExpr, TUnlessModifierExpr {
  private Ruby::UnlessModifier g;

  UnlessModifierExpr() { this = TUnlessModifierExpr(g) }

  final override string getAPrimaryQlClass() { result = "UnlessModifierExpr" }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  final override Stmt getBranch(boolean cond) { cond = false and result = this.getBody() }

  /**
   * Gets the statement that is conditionally evaluated. In the following
   * example, the result is the `Expr` for `foo`.
   * ```rb
   * foo unless bar
   * ```
   */
  final Stmt getBody() { toGenerated(result) = g.getBody() }

  final override string toString() { result = "... unless ..." }

  override AstNode getAChild(string pred) {
    result = ConditionalExpr.super.getAChild(pred)
    or
    pred = "getBody" and result = this.getBody()
  }
}

/**
 * A conditional expression using the ternary (`?:`) operator.
 * ```rb
 * (a > b) ? a : b
 * ```
 */
class TernaryIfExpr extends ConditionalExpr, TTernaryIfExpr {
  private Ruby::Conditional g;

  TernaryIfExpr() { this = TTernaryIfExpr(g) }

  final override string getAPrimaryQlClass() { result = "TernaryIfExpr" }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  /** Gets the 'then' branch of this ternary if expression. */
  final Stmt getThen() { toGenerated(result) = g.getConsequence() }

  /** Gets the 'else' branch of this ternary if expression. */
  final Stmt getElse() { toGenerated(result) = g.getAlternative() }

  final override Stmt getBranch(boolean cond) {
    cond = true and result = this.getThen()
    or
    cond = false and result = this.getElse()
  }

  final override string toString() { result = "... ? ... : ..." }

  override AstNode getAChild(string pred) {
    result = ConditionalExpr.super.getAChild(pred)
    or
    pred = "getThen" and result = this.getThen()
    or
    pred = "getElse" and result = this.getElse()
  }
}

class CaseExpr extends ControlExpr, TCaseExpr {
  private Ruby::Case g;

  CaseExpr() { this = TCaseExpr(g) }

  final override string getAPrimaryQlClass() { result = "CaseExpr" }

  /**
   * Gets the expression being compared, if any. For example, `foo` in the following example.
   * ```rb
   * case foo
   * when 0
   *   puts 'zero'
   * when 1
   *   puts 'one'
   * end
   * ```
   * There is no result for the following example:
   * ```rb
   * case
   * when a then 0
   * when b then 1
   * else        2
   * end
   * ```
   */
  final Expr getValue() { toGenerated(result) = g.getValue() }

  /**
   * Gets the `n`th branch of this case expression, either a `WhenExpr` or a
   * `StmtSequence`.
   */
  final Expr getBranch(int n) { toGenerated(result) = g.getChild(n) }

  /**
   * Gets a branch of this case expression, either a `WhenExpr` or an
   * `ElseExpr`.
   */
  final Expr getABranch() { result = this.getBranch(_) }

  /** Gets a `when` branch of this case expression. */
  final WhenExpr getAWhenBranch() { result = this.getABranch() }

  /** Gets the `else` branch of this case expression, if any. */
  final StmtSequence getElseBranch() { result = this.getABranch() }

  /**
   * Gets the number of branches of this case expression.
   */
  final int getNumberOfBranches() { result = count(this.getBranch(_)) }

  final override string toString() { result = "case ..." }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getValue" and result = this.getValue()
    or
    pred = "getBranch" and result = this.getBranch(_)
  }
}

/**
 * A `when` branch of a `case` expression.
 * ```rb
 * case
 * when a > b then x
 * end
 * ```
 */
class WhenExpr extends Expr, TWhenExpr {
  private Ruby::When g;

  WhenExpr() { this = TWhenExpr(g) }

  final override string getAPrimaryQlClass() { result = "WhenExpr" }

  /** Gets the body of this case-when expression. */
  final Stmt getBody() { toGenerated(result) = g.getBody() }

  /**
   * Gets the `n`th pattern (or condition) in this case-when expression. In the
   * following example, the 0th pattern is `x`, the 1st pattern is `y`, and the
   * 2nd pattern is `z`.
   * ```rb
   * case foo
   * when x, y, z
   *   puts 'x/y/z'
   * end
   * ```
   */
  final Expr getPattern(int n) { toGenerated(result) = g.getPattern(n).getChild() }

  /**
   * Gets a pattern (or condition) in this case-when expression.
   */
  final Expr getAPattern() { result = this.getPattern(_) }

  /**
   * Gets the number of patterns in this case-when expression.
   */
  final int getNumberOfPatterns() { result = count(this.getPattern(_)) }

  final override string toString() { result = "when ..." }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getBody" and result = this.getBody()
    or
    pred = "getPattern" and result = this.getPattern(_)
  }
}

/**
 * A loop. That is, a `for` loop, a `while` or `until` loop, or their
 * expression-modifier variants.
 */
class Loop extends ControlExpr, TLoop {
  /** Gets the body of this loop. */
  Stmt getBody() { none() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getBody" and result = this.getBody()
  }
}

/**
 * A loop using a condition expression. That is, a `while` or `until` loop, or
 * their expression-modifier variants.
 */
class ConditionalLoop extends Loop, TConditionalLoop {
  /** Gets the condition expression of this loop. */
  Expr getCondition() { none() }

  override AstNode getAChild(string pred) {
    result = Loop.super.getAChild(pred)
    or
    pred = "getCondition" and result = this.getCondition()
  }

  /** Holds if the loop body is entered when the condition is `condValue`. */
  predicate entersLoopWhenConditionIs(boolean condValue) { none() }
}

/**
 * A `while` loop.
 * ```rb
 * while a < b
 *   p a
 *   a += 2
 * end
 * ```
 */
class WhileExpr extends ConditionalLoop, TWhileExpr {
  private Ruby::While g;

  WhileExpr() { this = TWhileExpr(g) }

  final override string getAPrimaryQlClass() { result = "WhileExpr" }

  /** Gets the body of this `while` loop. */
  final override Stmt getBody() { toGenerated(result) = g.getBody() }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  /**
   * Holds if the loop body is entered when the condition is `condValue`. For
   * `while` loops, this holds when `condValue` is true.
   */
  final override predicate entersLoopWhenConditionIs(boolean condValue) { condValue = true }

  final override string toString() { result = "while ..." }
}

/**
 * An `until` loop.
 * ```rb
 * until a >= b
 *   p a
 *   a += 1
 * end
 * ```
 */
class UntilExpr extends ConditionalLoop, TUntilExpr {
  private Ruby::Until g;

  UntilExpr() { this = TUntilExpr(g) }

  final override string getAPrimaryQlClass() { result = "UntilExpr" }

  /** Gets the body of this `until` loop. */
  final override Stmt getBody() { toGenerated(result) = g.getBody() }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  /**
   * Holds if the loop body is entered when the condition is `condValue`. For
   * `until` loops, this holds when `condValue` is false.
   */
  final override predicate entersLoopWhenConditionIs(boolean condValue) { condValue = false }

  final override string toString() { result = "until ..." }
}

/**
 * An expression looped using the `while` modifier.
 * ```rb
 * foo while bar
 * ```
 */
class WhileModifierExpr extends ConditionalLoop, TWhileModifierExpr {
  private Ruby::WhileModifier g;

  WhileModifierExpr() { this = TWhileModifierExpr(g) }

  final override Stmt getBody() { toGenerated(result) = g.getBody() }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  /**
   * Holds if the loop body is entered when the condition is `condValue`. For
   * `while`-modifier loops, this holds when `condValue` is true.
   */
  final override predicate entersLoopWhenConditionIs(boolean condValue) { condValue = true }

  final override string getAPrimaryQlClass() { result = "WhileModifierExpr" }

  final override string toString() { result = "... while ..." }
}

/**
 * An expression looped using the `until` modifier.
 * ```rb
 * foo until bar
 * ```
 */
class UntilModifierExpr extends ConditionalLoop, TUntilModifierExpr {
  private Ruby::UntilModifier g;

  UntilModifierExpr() { this = TUntilModifierExpr(g) }

  final override Stmt getBody() { toGenerated(result) = g.getBody() }

  final override Expr getCondition() { toGenerated(result) = g.getCondition() }

  /**
   * Holds if the loop body is entered when the condition is `condValue`. For
   * `until`-modifier loops, this holds when `condValue` is false.
   */
  final override predicate entersLoopWhenConditionIs(boolean condValue) { condValue = false }

  final override string getAPrimaryQlClass() { result = "UntilModifierExpr" }

  final override string toString() { result = "... until ..." }
}

/**
 * A `for` loop.
 * ```rb
 * for val in 1..n
 *   sum += val
 * end
 * ```
 */
class ForExpr extends Loop, TForExpr {
  private Ruby::For g;

  ForExpr() { this = TForExpr(g) }

  final override string getAPrimaryQlClass() { result = "ForExpr" }

  /** Gets the body of this `for` loop. */
  final override StmtSequence getBody() { toGenerated(result) = g.getBody() }

  /** Gets the pattern representing the iteration argument. */
  final Pattern getPattern() { toGenerated(result) = g.getPattern() }

  /**
   * Gets the value being iterated over. In the following example, the result
   * is the expression `1..10`:
   * ```rb
   * for n in 1..10 do
   *   puts n
   * end
   * ```
   */
  final Expr getValue() { toGenerated(result) = g.getValue().getChild() }

  final override string toString() { result = "for ... in ..." }

  override AstNode getAChild(string pred) {
    result = Loop.super.getAChild(pred)
    or
    pred = "getPattern" and result = this.getPattern()
    or
    pred = "getValue" and result = this.getValue()
  }
}
