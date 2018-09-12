/**
 * Provides classes for working with guarded expressions.
 */

import csharp
private import BasicBlocks
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.commons.StructuralComparison::Internal
private import semmle.code.csharp.frameworks.System

/** An expression that accesses/calls a declaration. */
class AccessOrCallExpr extends Expr {
  AccessOrCallExpr() {
    exists(getDeclarationTarget(this))
  }

  /** Gets the target of this expression. */
  Declaration getTarget() {
    result = getDeclarationTarget(this)
  }

  /**
   * Gets the (non-trivial) SSA definition corresponding to the longest
   * qualifier chain of this expression, if any.
   *
   * This includes the case where this expression is itself an access to an
   * SSA definition.
   *
   * Examples:
   *
   * ```
   * x.Foo.Bar();   // SSA qualifier: SSA definition for `x.Foo`
   * x.Bar();       // SSA qualifier: SSA definition for `x`
   * x.Foo().Bar(); // SSA qualifier: SSA definition for `x`
   * x;             // SSA qualifier: SSA definition for `x`
   * ```
   */
  Ssa::Definition getSsaQualifier() {
    result = getSsaQualifier(this)
  }

  /**
   * Holds if this expression has an SSA qualifier.
   */
  predicate hasSsaQualifier() {
    exists(getSsaQualifier())
  }
}

private Declaration getDeclarationTarget(Expr e) {
  e = any(AssignableRead ar | result = ar.getTarget()) or
  result = e.(Call).getTarget()
}

private Ssa::Definition getSsaQualifier(Expr e) {
  e = getATrackedRead(result)
  or
  not e = getATrackedRead(_) and
  result = getSsaQualifier(e.(QualifiableExpr).getQualifier())
}

private AssignableRead getATrackedRead(Ssa::Definition def) {
  result = def.getARead() and
  not def instanceof Ssa::ImplicitUntrackedDefinition
}

/**
 * A guarded expression.
 *
 * A guarded expression is an access or a call that is reached only
 * when a conditional containing a structurally equal expression
 * evaluates to one of `true` or `false`.
 *
 * For example, the property call `x.Field.Property` on line 3 is
 * guarded in
 *
 * ```
 * string M(C x) {
 *   if (x.Field.Property != null)
 *     return x.Field.Property.ToString();
 *   return "";
 * }
 * ```
 *
 * There is no guarantee, in general, that the two structurally equal
 * expressions will evaluate to the same value at run-time. For instance,
 * in the following example, the null-guard on `stack` on line 2 is an actual
 * guard, whereas the null-guard on `stack.Pop()` on line 4 is not (invoking
 * `Pop()` twice on a stack does not yield the same result):
 *
 * ```
 * string M(Stack<object> stack) {
 *   if (stack == null)
 *     return "";
 *   if (stack.Pop() != null)         // stack is not null
 *     return stack.Pop().ToString(); // stack.Pop() might be null
 *   return "";
 * }
 * ```
 *
 * However, in case one of the expressions accesses an SSA definition in its
 * left-most qualifier, then so must the other (accessing the same SSA
 * definition).
 */
class GuardedExpr extends AccessOrCallExpr {
  GuardedExpr() {
    Internal::isGuardedBy(this, _, _, _)
  }

  /**
   * Holds if this expression is guarded by expression `cond`, which must
   * evaluate to `b`. The expression `e` is a sub expression of `cond`
   * that is structurally equal to this expression.
   *
   * In case this expression or `e` accesses an SSA variable in its
   * left-most qualifier, then so must the other (accessing the same SSA
   * variable).
   */
  predicate isGuardedBy(Expr cond, Expr e, boolean b) {
    Internal::isGuardedBy(this, cond, e, b)
  }
}

/**
 * A nullness guarded expression.
 *
 * A nullness  guarded expression is an access or a call that is reached only
 * when a nullness condition containing a structurally equal expression
 * evaluates to one of `null` or non-`null`.
 *
 * For example, the second access to `x` is only evaluated when `x` is null
 * in
 *
 * ```
 * string M(string x) => x ?? x;
 * ```
 */
class NullnessGuardedExpr extends AccessOrCallExpr {
  NullnessGuardedExpr() {
    Internal::isGuardedByNullness(this, _, _)
  }

  /**
   * Holds if this expression is guarded by expression `cond`, which must
   * evaluate to `b`. The expression `e` is a sub expression of `cond`
   * that is structurally equal to this expression.
   *
   * In case this expression or `e` accesses an SSA variable in its
   * left-most qualifier, then so must the other (accessing the same SSA
   * variable).
   */
  predicate isGuardedBy(Expr e, boolean isNull) {
    Internal::isGuardedByNullness(this, e, isNull)
  }
}

/** An expression guarded by a `null` check. */
class NullGuardedExpr extends AccessOrCallExpr {
  NullGuardedExpr() {
    exists(Expr cond, Expr sub, boolean b |
      this.(GuardedExpr).isGuardedBy(cond, sub, b) |
      // Comparison with `null`, for example `x != null`
      exists(ComparisonTest ct, ComparisonKind ck |
        ct.getExpr() = cond and
        ct.getAnArgument() = Internal::getNullEquivParent*(sub) and
        ct.getAnArgument() instanceof NullLiteral and
        ck = ct.getComparisonKind() |
        ck.isEquality() and b = false
        or
        ck.isInequality() and b = true
      )
      or
      // Comparison with a non-`null` value, for example `x?.Length > 0`
      exists(ComparisonTest ct, ComparisonKind ck, Type t |
        ct.getExpr() = cond and
        ct.getAnArgument() = Internal::getNullEquivParent*(sub) and
        sub.getType() = t and
        (t instanceof RefType or t instanceof NullableType) and
        Internal::nonNullValue(ct.getAnArgument()) and
        ck = ct.getComparisonKind() |
        if ck.isInequality() then b = false else b = true
      )
      or
      // Call to `string.IsNullOrEmpty()`
      exists(MethodCall mc |
        mc = cond and
        mc.getTarget() = any(SystemStringClass c).getIsNullOrEmptyMethod() and
        mc.getArgument(0) = sub and
        b = false
      )
    )
    or
    this.(NullnessGuardedExpr).isGuardedBy(_, false)
  }
}

private module Internal {
  private cached module Cached {
    cached predicate isGuardedBy(AccessOrCallExpr guarded, Expr cond, AccessOrCallExpr e, boolean b) {
      exists(BasicBlock bb |
        controls(cond, e, bb, b) and
        bb = guarded.getAControlFlowNode().getBasicBlock() and
        exists(ConditionOnExprComparisonConfig c | c.same(e, guarded)) |
        not guarded.hasSsaQualifier() and not e.hasSsaQualifier()
        or
        guarded.getSsaQualifier() = e.getSsaQualifier()
      )
    }

    cached predicate isGuardedByNullness(AccessOrCallExpr guarded, AccessOrCallExpr e, boolean isNull) {
      exists(BasicBlock bb |
        controlsNullness(e, bb, isNull) and
        bb = guarded.getAControlFlowNode().getBasicBlock() and
        exists(ConditionOnExprComparisonConfig c | c.same(e, guarded)) |
        not guarded.hasSsaQualifier() and not e.hasSsaQualifier()
        or
        guarded.getSsaQualifier() = e.getSsaQualifier()
      )
    }
  }
  import Cached

  /**
   * Gets the parent expression of `e` which is `null` iff `e` is null,
   * if any. For example, `result = x?.y` and `e = x`, or `result = x + 1`
   * and `e = x`.
   */
  Expr getNullEquivParent(Expr e) {
    exists(QualifiableExpr qe |
      result = qe and
      qe.getQualifier() = e and
      qe.isConditional() |
      qe.(FieldAccess).getTarget().getType() instanceof ValueType or
      qe.(Call).getTarget().getReturnType() instanceof ValueType
    )
    or
    // In C#, `null + 1` has type `int?` with value `null`
    exists(BinaryArithmeticOperation bao, Expr o |
      result = bao and
      bao.getAnOperand() = e and
      bao.getAnOperand() = o and
      nonNullValue(o) and
      e != o
    )
  }

  /** Holds if expression `e` is a non-`null` value. */
  predicate nonNullValue(Expr e) {
    e.stripCasts() = any(Expr s | s.hasValue() and not s instanceof NullLiteral)
  }

  /**
   * Holds if basic block `bb` only is reached when `cond` evaluates to `b`.
   * SSA qualified expression `e` is a sub expression of `cond`.
   */
  private predicate controls(Expr cond, AccessOrCallExpr e, BasicBlock bb, boolean b) {
    exists(ConditionBlock cb | cb.controlsSubCond(bb, _, cond, b)) and
    cond.getAChildExpr*() = e
  }

  /**
   * Holds if basic block `bb` only is reached when `e` evaluates to `null`
   * (`isNull = true`) or when `e` evaluates to non-`null` (`isNull = false`).
   */
  private predicate controlsNullness(Expr e, BasicBlock bb, boolean isNull) {
    exists(ConditionBlock cb |
      cb.controlsNullness(bb, isNull) |
      e = cb.getLastNode().getElement()
    )
  }

  /**
   * A helper class for calculating structurally equal access/call expressions.
   */
  private class ConditionOnExprComparisonConfig extends InternalStructuralComparisonConfiguration {
    ConditionOnExprComparisonConfig() {
      this = "ConditionOnExprComparisonConfig"
    }

    override predicate candidate(Element x, Element y) {
      exists(BasicBlock bb, Declaration d |
        candidateAux(x, d, bb) and
        y = any(AccessOrCallExpr e | e.getAControlFlowNode().getBasicBlock() = bb and e.getTarget() = d)
      )
    }

    /**
     * Holds if access/call expression `e` (targeting declaration `target`)
     * is a sub expression of a condition that controls whether basic block
     * `bb` is reached.
     */
    pragma [noinline] // predicate folding for proper join-order
    private predicate candidateAux(AccessOrCallExpr e, Declaration target, BasicBlock bb) {
      (controls(_, e, bb, _) or controlsNullness(e, bb, _)) and
      target = e.getTarget()
    }
  }
}
