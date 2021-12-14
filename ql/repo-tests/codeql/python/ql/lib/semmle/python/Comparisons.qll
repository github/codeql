/**
 * Provides classes representing comparison operators.
 */

import python

/** A class representing the six comparison operators, ==, !=, <, <=, > and >=. */
class CompareOp extends int {
  CompareOp() { this in [1 .. 6] }

  /** Gets the logical inverse operator */
  CompareOp invert() {
    this = eq() and result = ne()
    or
    this = ne() and result = eq()
    or
    this = lt() and result = ge()
    or
    this = gt() and result = le()
    or
    this = le() and result = gt()
    or
    this = ge() and result = lt()
  }

  /** Gets the reverse operator (swapping the operands) */
  CompareOp reverse() {
    this = eq() and result = eq()
    or
    this = ne() and result = ne()
    or
    this = lt() and result = gt()
    or
    this = gt() and result = lt()
    or
    this = le() and result = ge()
    or
    this = ge() and result = le()
  }

  /** Gets the textual representation of `this`. */
  string repr() {
    this = eq() and result = "=="
    or
    this = ne() and result = "!="
    or
    this = lt() and result = "<"
    or
    this = gt() and result = ">"
    or
    this = le() and result = "<="
    or
    this = ge() and result = ">="
  }

  /** Holds if `op` is the `Cmpop` corresponding to `this`. */
  predicate forOp(Cmpop op) {
    op instanceof Eq and this = eq()
    or
    op instanceof NotEq and this = ne()
    or
    op instanceof Lt and this = lt()
    or
    op instanceof LtE and this = le()
    or
    op instanceof Gt and this = gt()
    or
    op instanceof GtE and this = ge()
  }

  /** Return this if isTrue is true, otherwise returns the inverse */
  CompareOp conditional(boolean isTrue) {
    result = this and isTrue = true
    or
    result = this.invert() and isTrue = false
  }
}

/** The `CompareOp` for "equals". */
CompareOp eq() { result = 1 }

/** The `CompareOp` for "not equals". */
CompareOp ne() { result = 2 }

/** The `CompareOp` for "less than". */
CompareOp lt() { result = 3 }

/** The `CompareOp` for "less than or equal to". */
CompareOp le() { result = 4 }

/** The `CompareOp` for "greater than". */
CompareOp gt() { result = 5 }

/** The `CompareOp` for "greater than or equal to". */
CompareOp ge() { result = 6 }

/* Workaround precision limits in floating point numbers */
bindingset[x]
private predicate ok_magnitude(float x) {
  x > -9007199254740992.0 and // -2**53
  x < 9007199254740992.0 // 2**53
}

bindingset[x, y]
private float add(float x, float y) {
  ok_magnitude(x) and
  ok_magnitude(y) and
  ok_magnitude(result) and
  result = x + y
}

bindingset[x, y]
private float sub(float x, float y) {
  ok_magnitude(x) and
  ok_magnitude(y) and
  ok_magnitude(result) and
  result = x - y
}

/** Normalise equality cmp into the form `left op right + k`. */
private predicate test(
  ControlFlowNode cmp, ControlFlowNode left, CompareOp op, ControlFlowNode right, float k
) {
  simple_test(cmp, left, op, right) and k = 0
  or
  add_test(cmp, left, op, right, k)
  or
  not_test(cmp, left, op, right, k)
  or
  subtract_test(cmp, left, op, right, k)
  or
  exists(float c | test(cmp, right, op.reverse(), left, c) and k = -c)
}

/** Various simple tests in left op right + k form. */
private predicate simple_test(CompareNode cmp, ControlFlowNode l, CompareOp cmpop, ControlFlowNode r) {
  exists(Cmpop op | cmp.operands(l, op, r) and cmpop.forOp(op))
}

private predicate add_test_left(
  CompareNode cmp, ControlFlowNode l, CompareOp op, ControlFlowNode r, float k
) {
  exists(BinaryExprNode lhs, float c, float x, Num n |
    lhs.getNode().getOp() instanceof Add and
    test(cmp, lhs, op, r, c) and
    x = n.getN().toFloat() and
    k = sub(c, x)
  |
    l = lhs.getLeft() and n = lhs.getRight().getNode()
    or
    l = lhs.getRight() and n = lhs.getLeft().getNode()
  )
}

private predicate add_test_right(
  CompareNode cmp, ControlFlowNode l, CompareOp op, ControlFlowNode r, float k
) {
  exists(BinaryExprNode rhs, float c, float x, Num n |
    rhs.getNode().getOp() instanceof Add and
    test(cmp, l, op, rhs, c) and
    x = n.getN().toFloat() and
    k = add(c, x)
  |
    r = rhs.getLeft() and n = rhs.getRight().getNode()
    or
    r = rhs.getRight() and n = rhs.getLeft().getNode()
  )
}

/*
 * left + x op right + c => left op right + (c-x)
 *   left op (right + x) + c => left op right + (c+x)
 */

private predicate add_test(
  CompareNode cmp, ControlFlowNode l, CompareOp op, ControlFlowNode r, float k
) {
  add_test_left(cmp, l, op, r, k)
  or
  add_test_right(cmp, l, op, r, k)
}

private predicate subtract_test_left(
  CompareNode cmp, ControlFlowNode l, CompareOp op, ControlFlowNode r, float k
) {
  exists(BinaryExprNode lhs, float c, float x, Num n |
    lhs.getNode().getOp() instanceof Sub and
    test(cmp, lhs, op, r, c) and
    l = lhs.getLeft() and
    n = lhs.getRight().getNode() and
    x = n.getN().toFloat()
  |
    k = add(c, x)
  )
}

private predicate subtract_test_right(
  CompareNode cmp, ControlFlowNode l, CompareOp op, ControlFlowNode r, float k
) {
  exists(BinaryExprNode rhs, float c, float x, Num n |
    rhs.getNode().getOp() instanceof Sub and
    test(cmp, l, op, rhs, c) and
    r = rhs.getRight() and
    n = rhs.getLeft().getNode() and
    x = n.getN().toFloat()
  |
    k = sub(c, x)
  )
}

/*
 * left - x op right + c => left op right + (c+x)
 *   left op (right - x) + c => left op right + (c-x)
 */

private predicate subtract_test(
  CompareNode cmp, ControlFlowNode l, CompareOp op, ControlFlowNode r, float k
) {
  subtract_test_left(cmp, l, op, r, k)
  or
  subtract_test_right(cmp, l, op, r, k)
}

private predicate not_test(
  UnaryExprNode u, ControlFlowNode l, CompareOp op, ControlFlowNode r, float k
) {
  u.getNode().getOp() instanceof Not and
  test(u.getOperand(), l, op.invert(), r, k)
}

/**
 * A comparison which can be simplified to the canonical form `x OP y + k` where `x` and `y` are `ControlFlowNode`s,
 * `k` is a floating point constant and `OP` is one of `<=`, `>`, `==` or `!=`.
 */
class Comparison extends ControlFlowNode {
  Comparison() { test(this, _, _, _, _) }

  /** Whether this condition tests `l op r + k` */
  predicate tests(ControlFlowNode l, CompareOp op, ControlFlowNode r, float k) {
    test(this, l, op, r, k)
  }

  /** Whether this condition tests `l op k` */
  predicate tests(ControlFlowNode l, CompareOp op, float k) {
    exists(ControlFlowNode r, float x, float c | test(this, l, op, r, c) |
      x = r.getNode().(Num).getN().toFloat() and
      k = add(c, x)
    )
  }

  /*
   * The following predicates determine whether this test, when its result is `thisIsTrue`,
   * is equivalent to the predicate `v OP k` or `v1 OP v2 + k`.
   * For example, the test `x <= y` being false, is equivalent to the predicate `x > y`.
   */

  private predicate equivalentToEq(boolean thisIsTrue, SsaVariable v, float k) {
    this.tests(v.getAUse(), eq().conditional(thisIsTrue), k)
  }

  private predicate equivalentToNotEq(boolean thisIsTrue, SsaVariable v, float k) {
    this.tests(v.getAUse(), ne().conditional(thisIsTrue), k)
  }

  private predicate equivalentToLt(boolean thisIsTrue, SsaVariable v, float k) {
    this.tests(v.getAUse(), lt().conditional(thisIsTrue), k)
  }

  private predicate equivalentToLtEq(boolean thisIsTrue, SsaVariable v, float k) {
    this.tests(v.getAUse(), le().conditional(thisIsTrue), k)
  }

  private predicate equivalentToGt(boolean thisIsTrue, SsaVariable v, float k) {
    this.tests(v.getAUse(), gt().conditional(thisIsTrue), k)
  }

  private predicate equivalentToGtEq(boolean thisIsTrue, SsaVariable v, float k) {
    this.tests(v.getAUse(), ge().conditional(thisIsTrue), k)
  }

  private predicate equivalentToEq(boolean thisIsTrue, SsaVariable v1, SsaVariable v2, float k) {
    this.tests(v1.getAUse(), eq().conditional(thisIsTrue), v2.getAUse(), k)
  }

  private predicate equivalentToNotEq(boolean thisIsTrue, SsaVariable v1, SsaVariable v2, float k) {
    this.tests(v1.getAUse(), ne().conditional(thisIsTrue), v2.getAUse(), k)
  }

  private predicate equivalentToLt(boolean thisIsTrue, SsaVariable v1, SsaVariable v2, float k) {
    this.tests(v1.getAUse(), lt().conditional(thisIsTrue), v2.getAUse(), k)
  }

  private predicate equivalentToLtEq(boolean thisIsTrue, SsaVariable v1, SsaVariable v2, float k) {
    this.tests(v1.getAUse(), le().conditional(thisIsTrue), v2.getAUse(), k)
  }

  private predicate equivalentToGt(boolean thisIsTrue, SsaVariable v1, SsaVariable v2, float k) {
    this.tests(v1.getAUse(), gt().conditional(thisIsTrue), v2.getAUse(), k)
  }

  private predicate equivalentToGtEq(boolean thisIsTrue, SsaVariable v1, SsaVariable v2, float k) {
    this.tests(v1.getAUse(), ge().conditional(thisIsTrue), v2.getAUse(), k)
  }

  /**
   * Whether the result of this comparison being `thisIsTrue` implies that the result of `that` is `isThatTrue`.
   * In other words, does the predicate that is equivalent to the result of `this` being `thisIsTrue`
   * imply the predicate that is equivalent to the result of `that` being `thatIsTrue`.
   * For example, assume that there are two tests, which when normalised have the form `x < y` and `x > y + 1`.
   * Then the test `x < y` having a true result, implies that the test `x > y + 1` will have a false result.
   * (`x < y` having a false result implies nothing about `x > y + 1`)
   */
  predicate impliesThat(boolean thisIsTrue, Comparison that, boolean thatIsTrue) {
    /* `v == k` => `v == k` */
    exists(SsaVariable v, float k1, float k2 |
      this.equivalentToEq(thisIsTrue, v, k1) and
      that.equivalentToEq(thatIsTrue, v, k2) and
      eq(k1, k2)
      or
      this.equivalentToNotEq(thisIsTrue, v, k1) and
      that.equivalentToNotEq(thatIsTrue, v, k2) and
      eq(k1, k2)
    )
    or
    exists(SsaVariable v, float k1, float k2 |
      /* `v < k1` => `v != k2` iff k1 <= k2 */
      this.equivalentToLt(thisIsTrue, v, k1) and
      that.equivalentToNotEq(thatIsTrue, v, k2) and
      le(k1, k2)
      or
      /* `v <= k1` => `v != k2` iff k1 < k2 */
      this.equivalentToLtEq(thisIsTrue, v, k1) and
      that.equivalentToNotEq(thatIsTrue, v, k2) and
      lt(k1, k2)
      or
      /* `v > k1` => `v != k2` iff k1 >= k2 */
      this.equivalentToGt(thisIsTrue, v, k1) and
      that.equivalentToNotEq(thatIsTrue, v, k2) and
      ge(k1, k2)
      or
      /* `v >= k1` => `v != k2` iff k1 > k2 */
      this.equivalentToGtEq(thisIsTrue, v, k1) and
      that.equivalentToNotEq(thatIsTrue, v, k2) and
      gt(k1, k2)
    )
    or
    exists(SsaVariable v, float k1, float k2 |
      /* `v < k1` => `v < k2` iff k1 <= k2 */
      this.equivalentToLt(thisIsTrue, v, k1) and
      that.equivalentToLt(thatIsTrue, v, k2) and
      le(k1, k2)
      or
      /* `v < k1` => `v <= k2` iff k1 <= k2 */
      this.equivalentToLt(thisIsTrue, v, k1) and
      that.equivalentToLtEq(thatIsTrue, v, k2) and
      le(k1, k2)
      or
      /* `v <= k1` => `v < k2` iff k1 < k2 */
      this.equivalentToLtEq(thisIsTrue, v, k1) and
      that.equivalentToLt(thatIsTrue, v, k2) and
      lt(k1, k2)
      or
      /* `v <= k1` => `v <= k2` iff k1 <= k2 */
      this.equivalentToLtEq(thisIsTrue, v, k1) and
      that.equivalentToLtEq(thatIsTrue, v, k2) and
      le(k1, k2)
    )
    or
    exists(SsaVariable v, float k1, float k2 |
      /* `v > k1` => `v >= k2` iff k1 >= k2 */
      this.equivalentToGt(thisIsTrue, v, k1) and
      that.equivalentToGt(thatIsTrue, v, k2) and
      ge(k1, k2)
      or
      /* `v > k1` => `v >= k2` iff k1 >= k2 */
      this.equivalentToGt(thisIsTrue, v, k1) and
      that.equivalentToGtEq(thatIsTrue, v, k2) and
      ge(k1, k2)
      or
      /* `v >= k1` => `v > k2` iff k1 > k2 */
      this.equivalentToGtEq(thisIsTrue, v, k1) and
      that.equivalentToGt(thatIsTrue, v, k2) and
      gt(k1, k2)
      or
      /* `v >= k1` => `v >= k2` iff k1 >= k2 */
      this.equivalentToGtEq(thisIsTrue, v, k1) and
      that.equivalentToGtEq(thatIsTrue, v, k2) and
      ge(k1, k2)
    )
    or
    exists(SsaVariable v1, SsaVariable v2, float k |
      /* `v1 == v2 + k` => `v1 == v2 + k` */
      this.equivalentToEq(thisIsTrue, v1, v2, k) and
      that.equivalentToEq(thatIsTrue, v1, v2, k)
      or
      this.equivalentToNotEq(thisIsTrue, v1, v2, k) and
      that.equivalentToNotEq(thatIsTrue, v1, v2, k)
    )
    or
    exists(SsaVariable v1, SsaVariable v2, float k1, float k2 |
      /* `v1 < v2 + k1` => `v1 != v2 + k2` iff k1 <= k2 */
      this.equivalentToLt(thisIsTrue, v1, v2, k1) and
      that.equivalentToNotEq(thatIsTrue, v1, v2, k2) and
      le(k1, k2)
      or
      /* `v1 <= v2 + k1` => `v1 != v2 + k2` iff k1 < k2 */
      this.equivalentToLtEq(thisIsTrue, v1, v2, k1) and
      that.equivalentToNotEq(thatIsTrue, v1, v2, k2) and
      lt(k1, k2)
      or
      /* `v1 > v2 + k1` => `v1 != v2 + k2` iff k1 >= k2 */
      this.equivalentToGt(thisIsTrue, v1, v2, k1) and
      that.equivalentToNotEq(thatIsTrue, v1, v2, k2) and
      ge(k1, k2)
      or
      /* `v1 >= v2 + k1` => `v1 != v2 + k2` iff k1 > k2 */
      this.equivalentToGtEq(thisIsTrue, v1, v2, k1) and
      that.equivalentToNotEq(thatIsTrue, v1, v2, k2) and
      gt(k1, k2)
    )
    or
    exists(SsaVariable v1, SsaVariable v2, float k1, float k2 |
      /* `v1 <= v2 + k1` => `v1 <= v2 + k2` iff k1 <= k2 */
      this.equivalentToLtEq(thisIsTrue, v1, v2, k1) and
      that.equivalentToLtEq(thatIsTrue, v1, v2, k2) and
      le(k1, k2)
      or
      /* `v1 < v2 + k1` => `v1 <= v2 + k2` iff k1 <= k2 */
      this.equivalentToLt(thisIsTrue, v1, v2, k1) and
      that.equivalentToLtEq(thatIsTrue, v1, v2, k2) and
      le(k1, k2)
      or
      /* `v1 <= v2 + k1` => `v1 < v2 + k2` iff k1 < k2 */
      this.equivalentToLtEq(thisIsTrue, v1, v2, k1) and
      that.equivalentToLt(thatIsTrue, v1, v2, k2) and
      lt(k1, k2)
      or
      /* `v1 <= v2 + k1` => `v1 <= v2 + k2` iff k1 <= k2 */
      this.equivalentToLtEq(thisIsTrue, v1, v2, k1) and
      that.equivalentToLtEq(thatIsTrue, v1, v2, k2) and
      le(k1, k2)
    )
    or
    exists(SsaVariable v1, SsaVariable v2, float k1, float k2 |
      /* `v1 > v2 + k1` => `v1 > v2 + k2` iff k1 >= k2 */
      this.equivalentToGt(thisIsTrue, v1, v2, k1) and
      that.equivalentToGt(thatIsTrue, v1, v2, k2) and
      ge(k1, k2)
      or
      /* `v1 > v2 + k1` => `v2 >= v2 + k2` iff k1 >= k2 */
      this.equivalentToGt(thisIsTrue, v1, v2, k1) and
      that.equivalentToGtEq(thatIsTrue, v1, v2, k2) and
      ge(k1, k2)
      or
      /* `v1 >= v2 + k1` => `v2 > v2 + k2` iff k1 > k2 */
      this.equivalentToGtEq(thisIsTrue, v1, v2, k1) and
      that.equivalentToGt(thatIsTrue, v1, v2, k2) and
      gt(k1, k2)
      or
      /* `v1 >= v2 + k1` => `v2 >= v2 + k2` iff k1 >= k2 */
      this.equivalentToGtEq(thisIsTrue, v1, v2, k1) and
      that.equivalentToGtEq(thatIsTrue, v1, v2, k2) and
      ge(k1, k2)
    )
  }
}

/* Work around differences in floating-point comparisons between Python and QL */
private predicate is_zero(float x) {
  x = 0.0
  or
  x = -0.0
}

bindingset[x, y]
private predicate lt(float x, float y) { if is_zero(x) then y > 0 else x < y }

bindingset[x, y]
private predicate eq(float x, float y) { if is_zero(x) then is_zero(y) else x = y }

bindingset[x, y]
private predicate gt(float x, float y) { lt(y, x) }

bindingset[x, y]
private predicate le(float x, float y) { lt(x, y) or eq(x, y) }

bindingset[x, y]
private predicate ge(float x, float y) { lt(y, x) or eq(x, y) }

/**
 * A basic block which terminates in a condition, splitting the subsequent control flow,
 * in which the condition is an instance of `Comparison`
 */
class ComparisonControlBlock extends ConditionBlock {
  ComparisonControlBlock() { this.getLastNode() instanceof Comparison }

  /** Whether this conditional guard determines that, in block `b`, `l == r + k` if `eq` is true, or `l != r + k` if `eq` is false, */
  predicate controls(ControlFlowNode l, CompareOp op, ControlFlowNode r, float k, BasicBlock b) {
    exists(boolean control |
      this.controls(b, control) and this.getTest().tests(l, op, r, k) and control = true
      or
      this.controls(b, control) and this.getTest().tests(l, op.invert(), r, k) and control = false
    )
  }

  /** Whether this conditional guard determines that, in block `b`, `l == r + k` if `eq` is true, or `l != r + k` if `eq` is false, */
  predicate controls(ControlFlowNode l, CompareOp op, float k, BasicBlock b) {
    exists(boolean control |
      this.controls(b, control) and this.getTest().tests(l, op, k) and control = true
      or
      this.controls(b, control) and this.getTest().tests(l, op.invert(), k) and control = false
    )
  }

  Comparison getTest() { this.getLastNode() = result }

  /** Whether this conditional guard implies that, in block `b`,  the result of `that` is `thatIsTrue` */
  predicate impliesThat(BasicBlock b, Comparison that, boolean thatIsTrue) {
    exists(boolean controlSense |
      this.controls(b, controlSense) and
      this.getTest().impliesThat(controlSense, that, thatIsTrue)
    )
  }
}
