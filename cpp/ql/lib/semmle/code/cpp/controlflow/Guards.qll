/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 */

import cpp
import semmle.code.cpp.controlflow.BasicBlocks
import semmle.code.cpp.controlflow.SSA
import semmle.code.cpp.controlflow.Dominance

/**
 * A Boolean condition that guards one or more basic blocks. This includes
 * operands of logical operators but not switch statements.
 */
class GuardCondition extends Expr {
  GuardCondition() { is_condition(this) }

  /**
   * Holds if this condition controls `block`, meaning that `block` is only
   * entered if the value of this condition is `testIsTrue`.
   *
   * Illustration:
   *
   * ```
   * [                    (testIsTrue)                        ]
   * [             this ----------------succ ---- controlled  ]
   * [               |                    |                   ]
   * [ (testIsFalse) |                     ------ ...         ]
   * [             other                                      ]
   * ```
   *
   * The predicate holds if all paths to `controlled` go via the `testIsTrue`
   * edge of the control-flow graph. In other words, the `testIsTrue` edge
   * must dominate `controlled`. This means that `controlled` must be
   * dominated by both `this` and `succ` (the target of the `testIsTrue`
   * edge). It also means that any other edge into `succ` must be a back-edge
   * from a node which is dominated by `succ`.
   *
   * The short-circuit boolean operations have slightly surprising behavior
   * here: because the operation itself only dominates one branch (due to
   * being short-circuited) then it will only control blocks dominated by the
   * true (for `&&`) or false (for `||`) branch.
   */
  cached
  predicate controls(BasicBlock controlled, boolean testIsTrue) {
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    this.controlsBlock(controlled, testIsTrue)
    or
    exists(BinaryLogicalOperation binop, GuardCondition lhs, GuardCondition rhs |
      this = binop and
      lhs = binop.getLeftOperand() and
      rhs = binop.getRightOperand() and
      lhs.controls(controlled, testIsTrue) and
      rhs.controls(controlled, testIsTrue)
    )
    or
    exists(GuardCondition ne, GuardCondition operand |
      this = operand and
      operand = ne.(NotExpr).getOperand() and
      ne.controls(controlled, testIsTrue.booleanNot())
    )
  }

  /** Holds if (determined by this guard) `left < right + k` evaluates to `isLessThan` if this expression evaluates to `testIsTrue`. */
  cached
  predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    compares_lt(this, left, right, k, isLessThan, testIsTrue)
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `left >= right + k`.
   */
  cached
  predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(boolean testIsTrue |
      compares_lt(this, left, right, k, isLessThan, testIsTrue) and this.controls(block, testIsTrue)
    )
  }

  /** Holds if (determined by this guard) `left == right + k` evaluates to `areEqual` if this expression evaluates to `testIsTrue`. */
  cached
  predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    compares_eq(this, left, right, k, areEqual, testIsTrue)
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`.
   */
  cached
  predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean areEqual) {
    exists(boolean testIsTrue |
      compares_eq(this, left, right, k, areEqual, testIsTrue) and this.controls(block, testIsTrue)
    )
  }

  /**
   * Holds if this condition controls `block`, meaning that `block` is only
   * entered if the value of this condition is `testIsTrue`. This helper
   * predicate does not necessarily hold for binary logical operations like
   * `&&` and `||`. See the detailed explanation on predicate `controls`.
   */
  private predicate controlsBlock(BasicBlock controlled, boolean testIsTrue) {
    exists(BasicBlock thisblock | thisblock.contains(this) |
      exists(BasicBlock succ |
        testIsTrue = true and succ = this.getATrueSuccessor()
        or
        testIsTrue = false and succ = this.getAFalseSuccessor()
      |
        bbDominates(succ, controlled) and
        forall(BasicBlock pred | pred.getASuccessor() = succ |
          pred = thisblock or bbDominates(succ, pred) or not reachable(pred)
        )
      )
    )
  }
}

private predicate is_condition(Expr guard) {
  guard.isCondition()
  or
  is_condition(guard.(BinaryLogicalOperation).getAnOperand())
  or
  exists(NotExpr cond | is_condition(cond) and cond.getOperand() = guard)
}

/*
 * Simplification of equality expressions:
 * Simplify conditions in the source to the canonical form l op r + k.
 */

/**
 * Holds if `left == right + k` is `areEqual` given that test is `testIsTrue`.
 *
 * Beware making mistaken logical implications here relating `areEqual` and `testIsTrue`.
 */
private predicate compares_eq(
  Expr test, Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue
) {
  /* The simple case where the test *is* the comparison so areEqual = testIsTrue xor eq. */
  exists(boolean eq | simple_comparison_eq(test, left, right, k, eq) |
    areEqual = true and testIsTrue = eq
    or
    areEqual = false and testIsTrue = eq.booleanNot()
  )
  or
  logical_comparison_eq(test, left, right, k, areEqual, testIsTrue)
  or
  /* a == b + k => b == a - k */
  exists(int mk | k = -mk | compares_eq(test, right, left, mk, areEqual, testIsTrue))
  or
  complex_eq(test, left, right, k, areEqual, testIsTrue)
  or
  /* (x is true => (left == right + k)) => (!x is false => (left == right + k)) */
  exists(boolean isFalse | testIsTrue = isFalse.booleanNot() |
    compares_eq(test.(NotExpr).getOperand(), left, right, k, areEqual, isFalse)
  )
}

/**
 * If `test => part` and `part => left == right + k` then `test => left == right + k`.
 * Similarly for the case where `test` is false.
 */
private predicate logical_comparison_eq(
  BinaryLogicalOperation test, Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue
) {
  exists(boolean partIsTrue, Expr part | test.impliesValue(part, partIsTrue, testIsTrue) |
    compares_eq(part, left, right, k, areEqual, partIsTrue)
  )
}

/** Rearrange various simple comparisons into `left == right + k` form. */
private predicate simple_comparison_eq(
  ComparisonOperation cmp, Expr left, Expr right, int k, boolean areEqual
) {
  left = cmp.getLeftOperand() and
  cmp.getOperator() = "==" and
  right = cmp.getRightOperand() and
  k = 0 and
  areEqual = true
  or
  left = cmp.getLeftOperand() and
  cmp.getOperator() = "!=" and
  right = cmp.getRightOperand() and
  k = 0 and
  areEqual = false
}

private predicate complex_eq(
  ComparisonOperation cmp, Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue
) {
  sub_eq(cmp, left, right, k, areEqual, testIsTrue)
  or
  add_eq(cmp, left, right, k, areEqual, testIsTrue)
}

// left - x == right + c => left == right + (c+x)
// left == (right - x) + c => left == right + (c-x)
private predicate sub_eq(
  ComparisonOperation cmp, Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue
) {
  exists(SubExpr lhs, int c, int x |
    compares_eq(cmp, lhs, right, c, areEqual, testIsTrue) and
    left = lhs.getLeftOperand() and
    x = int_value(lhs.getRightOperand()) and
    k = c + x
  )
  or
  exists(SubExpr rhs, int c, int x |
    compares_eq(cmp, left, rhs, c, areEqual, testIsTrue) and
    right = rhs.getLeftOperand() and
    x = int_value(rhs.getRightOperand()) and
    k = c - x
  )
}

// left + x == right + c => left == right + (c-x)
// left == (right + x) + c => left == right + (c+x)
private predicate add_eq(
  ComparisonOperation cmp, Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue
) {
  exists(AddExpr lhs, int c, int x |
    compares_eq(cmp, lhs, right, c, areEqual, testIsTrue) and
    (
      left = lhs.getLeftOperand() and x = int_value(lhs.getRightOperand())
      or
      left = lhs.getRightOperand() and x = int_value(lhs.getLeftOperand())
    ) and
    k = c - x
  )
  or
  exists(AddExpr rhs, int c, int x |
    compares_eq(cmp, left, rhs, c, areEqual, testIsTrue) and
    (
      right = rhs.getLeftOperand() and x = int_value(rhs.getRightOperand())
      or
      right = rhs.getRightOperand() and x = int_value(rhs.getLeftOperand())
    ) and
    k = c + x
  )
}

/*
 * Simplification of inequality expressions:
 * Simplify conditions in the source to the canonical form l < r + k.
 */

/** Holds if `left < right + k` evaluates to `isLt` given that test is `testIsTrue`. */
private predicate compares_lt(
  Expr test, Expr left, Expr right, int k, boolean isLt, boolean testIsTrue
) {
  /* In the simple case, the test is the comparison, so isLt = testIsTrue */
  simple_comparison_lt(test, left, right, k) and isLt = true and testIsTrue = true
  or
  simple_comparison_lt(test, left, right, k) and isLt = false and testIsTrue = false
  or
  logical_comparison_lt(test, left, right, k, isLt, testIsTrue)
  or
  complex_lt(test, left, right, k, isLt, testIsTrue)
  or
  /* (not (left < right + k)) => (left >= right + k) */
  exists(boolean isGe | isLt = isGe.booleanNot() |
    compares_ge(test, left, right, k, isGe, testIsTrue)
  )
  or
  /* (x is true => (left < right + k)) => (!x is false => (left < right + k)) */
  exists(boolean isFalse | testIsTrue = isFalse.booleanNot() |
    compares_lt(test.(NotExpr).getOperand(), left, right, k, isLt, isFalse)
  )
}

/** `(a < b + k) => (b > a - k) => (b >= a + (1-k))` */
private predicate compares_ge(
  Expr test, Expr left, Expr right, int k, boolean isGe, boolean testIsTrue
) {
  exists(int onemk | k = 1 - onemk | compares_lt(test, right, left, onemk, isGe, testIsTrue))
}

/**
 * If `test => part` and `part => left < right + k` then `test => left < right + k`.
 * Similarly for the case where `test` evaluates false.
 */
private predicate logical_comparison_lt(
  BinaryLogicalOperation test, Expr left, Expr right, int k, boolean isLt, boolean testIsTrue
) {
  exists(boolean partIsTrue, Expr part | test.impliesValue(part, partIsTrue, testIsTrue) |
    compares_lt(part, left, right, k, isLt, partIsTrue)
  )
}

/** Rearrange various simple comparisons into `left < right + k` form. */
private predicate simple_comparison_lt(ComparisonOperation cmp, Expr left, Expr right, int k) {
  left = cmp.getLeftOperand() and
  cmp.getOperator() = "<" and
  right = cmp.getRightOperand() and
  k = 0
  or
  left = cmp.getLeftOperand() and
  cmp.getOperator() = "<=" and
  right = cmp.getRightOperand() and
  k = 1
  or
  right = cmp.getLeftOperand() and
  cmp.getOperator() = ">" and
  left = cmp.getRightOperand() and
  k = 0
  or
  right = cmp.getLeftOperand() and
  cmp.getOperator() = ">=" and
  left = cmp.getRightOperand() and
  k = 1
}

private predicate complex_lt(
  ComparisonOperation cmp, Expr left, Expr right, int k, boolean isLt, boolean testIsTrue
) {
  sub_lt(cmp, left, right, k, isLt, testIsTrue)
  or
  add_lt(cmp, left, right, k, isLt, testIsTrue)
}

// left - x < right + c => left < right + (c+x)
// left < (right - x) + c => left < right + (c-x)
private predicate sub_lt(
  ComparisonOperation cmp, Expr left, Expr right, int k, boolean isLt, boolean testIsTrue
) {
  exists(SubExpr lhs, int c, int x |
    compares_lt(cmp, lhs, right, c, isLt, testIsTrue) and
    left = lhs.getLeftOperand() and
    x = int_value(lhs.getRightOperand()) and
    k = c + x
  )
  or
  exists(SubExpr rhs, int c, int x |
    compares_lt(cmp, left, rhs, c, isLt, testIsTrue) and
    right = rhs.getLeftOperand() and
    x = int_value(rhs.getRightOperand()) and
    k = c - x
  )
}

// left + x < right + c => left < right + (c-x)
// left < (right + x) + c => left < right + (c+x)
private predicate add_lt(
  ComparisonOperation cmp, Expr left, Expr right, int k, boolean isLt, boolean testIsTrue
) {
  exists(AddExpr lhs, int c, int x |
    compares_lt(cmp, lhs, right, c, isLt, testIsTrue) and
    (
      left = lhs.getLeftOperand() and x = int_value(lhs.getRightOperand())
      or
      left = lhs.getRightOperand() and x = int_value(lhs.getLeftOperand())
    ) and
    k = c - x
  )
  or
  exists(AddExpr rhs, int c, int x |
    compares_lt(cmp, left, rhs, c, isLt, testIsTrue) and
    (
      right = rhs.getLeftOperand() and x = int_value(rhs.getRightOperand())
      or
      right = rhs.getRightOperand() and x = int_value(rhs.getLeftOperand())
    ) and
    k = c + x
  )
}

/** The `int` value of integer constant expression. */
private int int_value(Expr e) {
  e.getUnderlyingType() instanceof IntegralType and
  result = e.getValue().toInt()
}

/** An `SsaDefinition` with an additional predicate `isLt`. */
class GuardedSsa extends SsaDefinition {
  /** Holds if this `SsaDefinition` is guarded such that `this(var) < gt + k` is `testIsTrue` in `block`. */
  predicate isLt(StackVariable var, Expr gt, int k, BasicBlock block, boolean testIsTrue) {
    exists(Expr luse, GuardCondition test | this.getAUse(var) = luse |
      test.ensuresLt(luse, gt, k, block, testIsTrue)
    )
  }
}
