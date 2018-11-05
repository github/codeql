/**
 * Provides classes for working with guarded expressions.
 */

import csharp
private import ControlFlow::SuccessorTypes
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.commons.StructuralComparison::Internal
private import semmle.code.csharp.controlflow.BasicBlocks
private import semmle.code.csharp.controlflow.Completion
private import semmle.code.csharp.frameworks.System

/** An abstract value. */
abstract class AbstractValue extends TAbstractValue {
  /** Holds if taking the `s` branch out of `cfe` implies that `e` has this value. */
  abstract predicate branchImplies(ControlFlowElement cfe, ConditionalSuccessor s, Expr e);

  /** Gets a textual representation of this abstract value. */
  abstract string toString();
}

/** Provides different types of `AbstractValues`s. */
module AbstractValues {
  /** A Boolean value. */
  class BooleanValue extends AbstractValue, TBooleanValue {
    /** Gets the underlying Boolean value. */
    boolean getValue() { this = TBooleanValue(result) }

    override predicate branchImplies(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) {
      s.(BooleanSuccessor).getValue() = this.getValue() and
      exists(BooleanCompletion c |
        s.matchesCompletion(c) |
        c.isValidFor(cfe) and
        e = cfe
      )
    }

    override string toString() { result = this.getValue().toString() }
  }

  /** A value that is either `null` or non-`null`. */
  class NullValue extends AbstractValue, TNullValue {
    /** Holds if this value represents `null`. */
    predicate isNull() { this = TNullValue(true) }

    override predicate branchImplies(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) {
      this = TNullValue(s.(NullnessSuccessor).getValue()) and
      exists(NullnessCompletion c |
        s.matchesCompletion(c) |
        c.isValidFor(cfe) and
        e = cfe
      )
    }

    override string toString() {
      if this.isNull() then result = "null" else result = "non-null"
    }
  }

  /** A value that represents match or non-match against a specific `case` statement. */
  class MatchValue extends AbstractValue, TMatchValue {
    /** Gets the case statement. */
    CaseStmt getCaseStmt() { this = TMatchValue(result, _) }

    /** Holds if this value represents a match. */
    predicate isMatch() { this = TMatchValue(_, true) }

    override predicate branchImplies(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) {
      this = TMatchValue(_, s.(MatchingSuccessor).getValue()) and
      exists(MatchingCompletion c, SwitchStmt ss, CaseStmt cs |
        s.matchesCompletion(c) |
        c.isValidFor(cfe) and
        switchMatching(ss, cs, cfe) and
        e = ss.getCondition() and
        cs = this.getCaseStmt()
      )
    }

    override string toString() {
      exists(string s |
        s = this.getCaseStmt().toString() |
        if this.isMatch() then result = "match " + s else result = "non-match " + s
      )
    }
  }

  /** A value that represents an empty or non-empty collection. */
  class EmptyCollectionValue extends AbstractValue, TEmptyCollectionValue {
    /** Holds if this value represents an empty collection. */
    predicate isEmpty() { this = TEmptyCollectionValue(true) }

    override predicate branchImplies(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) {
      this = TEmptyCollectionValue(s.(EmptinessSuccessor).getValue()) and
      exists(EmptinessCompletion c, ForeachStmt fs |
        s.matchesCompletion(c) |
        c.isValidFor(cfe) and
        foreachEmptiness(fs, cfe) and
        e = fs.getIterableExpr()
      )
    }

    override string toString() {
      if this.isEmpty() then result = "empty" else result = "non-empty"
    }
  }
}
private import AbstractValues

/**
 * An expression that evaluates to a value that can be dereferenced. That is,
 * an expression that may evaluate to `null`.
 */
class DereferenceableExpr extends Expr {
  DereferenceableExpr() {
    exists(Expr e, Type t |
      // There is currently a bug in the extractor: the type of `x?.Length` is
      // incorrectly `int`, while it should have been `int?`. We apply
      // `getNullEquivParent()` as a workaround
      this = getNullEquivParent*(e) and
      t = e.getType() |
      t instanceof NullableType
      or
      t instanceof RefType
    )
  }

  /**
   * Gets an expression that directly tests whether this expression is `null`.
   *
   * If the returned expression evaluates to `v`, then this expression is
   * guaranteed to be `null` if `isNull` is true, and non-`null` if `isNull` is
   * false.
   *
   * For example, if the expression `x != null` evaluates to `true` then the
   * expression `x` is guaranteed to be non-`null`.
   */
  private Expr getABooleanNullCheck(BooleanValue v, boolean isNull) {
    exists(boolean branch |
      branch = v.getValue() |
      // Comparison with `null`, for example `x != null`
      exists(ComparisonTest ct, ComparisonKind ck, NullLiteral nl |
        ct.getExpr() = result and
        ct.getAnArgument() = this and
        ct.getAnArgument() = nl and
        this != nl and
        ck = ct.getComparisonKind() |
        ck.isEquality() and isNull = branch
        or
        ck.isInequality() and isNull = branch.booleanNot()
      )
      or
      // Comparison with a non-`null` value, for example `x?.Length > 0`
      exists(ComparisonTest ct, ComparisonKind ck, Expr e |
        ct.getExpr() = result |
        ct.getAnArgument() = this and
        ct.getAnArgument() = e and
        nonNullValue(e) and
        ck = ct.getComparisonKind() and
        this != e and
        isNull = false and
        if ck.isInequality() then branch = false else branch = true
      )
      or
      // Call to `string.IsNullOrEmpty()`
      result = any(MethodCall mc |
        mc.getTarget() = any(SystemStringClass c).getIsNullOrEmptyMethod() and
        mc.getArgument(0) = this and
        branch = false and
        isNull = false
      )
      or
      result = any(IsExpr ie |
        ie.getExpr() = this and
        if ie.(IsConstantExpr).getConstant() instanceof NullLiteral then
          // E.g. `x is null`
          isNull = branch
        else
          // E.g. `x is string` or `x is ""`
          (branch = true and isNull = false)
      )
    )
  }

  /**
   * Gets an expression that tests via matching whether this expression is `null`.
   *
   * If the returned element matches (`v.isMatch()`) or non-matches
   * (`not v.isMatch()`), then this expression is guaranteed to be `null`
   * if `isNull` is true, and non-`null` if `isNull` is false.
   *
   * For example, if the case statement `case string s` matches in
   *
   * ```
   * switch (o)
   * {
   *     case string s:
   *         return s;
   *     default:
   *         return "";
   * }
   * ```
   *
   * then `o` is guaranteed to be non-`null`.
   */
  private Expr getAMatchingNullCheck(MatchValue v, boolean isNull) {
    exists(SwitchStmt ss, CaseStmt cs |
      cs = v.getCaseStmt() and
      this = ss.getCondition() and
      result = this and
      cs = ss.getACase() |
      // E.g. `case string`
      cs instanceof TypeCase and
      v.isMatch() and
      isNull = false
      or
      cs = any(ConstCase cc |
        if cc.getExpr() instanceof NullLiteral then
          // `case null`
          if v.isMatch() then isNull = true else isNull = false
        else (
          // E.g. `case ""`
          v.isMatch() and
          isNull = false
        )
      )
    )
  }

  /**
   * Gets an expression that tests via nullness whether this expression is `null`.
   *
   * If the returned expression evaluates to `null` (`v.isNull()`) or evaluates to
   * non-`null` (`not v.isNull()`), then this expression is guaranteed to be `null`
   * if `isNull` is true, and non-`null` if `isNull` is false.
   *
   * For example, if `x` evaluates to `null` in `x ?? y` then `y` is evaluated, and
   * `x` is guaranteed to be `null`.
   */
  private Expr getANullnessNullCheck(NullValue v, boolean isNull) {
    exists(NullnessCompletion c |
      c.isValidFor(this) |
      result = this and
      if c.isNull() then (
        v.isNull() and
        isNull = true
      )
      else (
        not v.isNull() and
        isNull = false
      )
    )
  }

  /**
   * Gets an expression that tests whether this expression is `null`.
   *
   * If the returned expression has abstract value `v`, then this expression is
   * guaranteed to be `null` if `isNull` is true, and non-`null` if `isNull` is
   * false.
   *
   * For example, if the expression `x != null` evaluates to `true` then the
   * expression `x` is guaranteed to be non-`null`.
   */
  Expr getANullCheck(AbstractValue v, boolean isNull) {
    result = this.getABooleanNullCheck(v, isNull)
    or
    result = this.getAMatchingNullCheck(v, isNull)
    or
    result = this.getANullnessNullCheck(v, isNull)
  }
}

/** An expression that accesses/calls a declaration. */
class AccessOrCallExpr extends Expr {
  private Declaration target;

  AccessOrCallExpr() { target = getDeclarationTarget(this) }

  /** Gets the target of this expression. */
  Declaration getTarget() { result = target }

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
  Ssa::Definition getSsaQualifier() { result = getSsaQualifier(this) }

  /**
   * Holds if this expression has an SSA qualifier.
   */
  predicate hasSsaQualifier() { exists(this.getSsaQualifier()) }
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
 * A guarded expression is an access or a call that is reached only when another
 * expression, `e`, has a certain abstract value, where `e` contains a sub
 * expression that is structurally equal to this expression.
 *
 * For example, the property call `x.Field.Property` on line 3 is guarded in
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
  private Expr e0;
  private AccessOrCallExpr sub0;
  private AbstractValue v0;

  GuardedExpr() { isGuardedBy(this, e0, sub0, v0) }

  /**
   * Gets an expression that guards this expression. That is, this expression is
   * only reached when the returned expression has abstract value `v`.
   *
   * The expression `sub` is a sub expression of the guarding expression that is
   * structurally equal to this expression.
   *
   * In case this expression or `sub` accesses an SSA variable in its
   * left-most qualifier, then so must the other (accessing the same SSA
   * variable).
   */
  Expr getAGuard(Expr sub, AbstractValue v) {
    result = e0 and
    sub = sub0 and
    v = v0
  }

  /**
   * Holds if this expression is guarded by expression `cond`, which must
   * evaluate to `b`. The expression `sub` is a sub expression of `cond`
   * that is structurally equal to this expression.
   *
   * In case this expression or `sub` accesses an SSA variable in its
   * left-most qualifier, then so must the other (accessing the same SSA
   * variable).
   */
  predicate isGuardedBy(Expr cond, Expr sub, boolean b) {
    cond = this.getAGuard(sub, any(BooleanValue v | v.getValue() = b))
  }
}

/** An expression guarded by a `null` check. */
class NullGuardedExpr extends GuardedExpr {
  NullGuardedExpr() {
    exists(Expr e, NullValue v | e = this.getAGuard(e, v) | not v.isNull())
  }
}

/** INTERNAL: Do not use. */
module Internal {
  private import ControlFlow::Internal

  newtype TAbstractValue =
    TBooleanValue(boolean b) { b = true or b = false }
    or
    TNullValue(boolean b) { b = true or b = false }
    or
    TMatchValue(CaseStmt cs, boolean b) { b = true or b = false }
    or
    TEmptyCollectionValue(boolean b) { b = true or b = false }

  /**
   * Gets the parent expression of `e` which is `null` only if `e` is `null`,
   * if any. For example, `result = x?.y` and `e = x`, or `result = x + 1`
   * and `e = x`.
   */
  Expr getNullEquivParent(Expr e) {
    result = any(QualifiableExpr qe |
      qe.getQualifier() = e and
      qe.isConditional() and
      (
        result.(FieldAccess).getTarget().getType() instanceof ValueType
        or
        result.(Call).getTarget().getReturnType() instanceof ValueType
      )
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
   * A helper class for calculating structurally equal access/call expressions.
   */
  private class ConditionOnExprComparisonConfig extends InternalStructuralComparisonConfiguration {
    ConditionOnExprComparisonConfig() {
      this = "ConditionOnExprComparisonConfig"
    }

    override predicate candidate(Element x, Element y) {
      exists(BasicBlock bb, Declaration d |
        candidateAux(x, d, bb) and
        y = any(AccessOrCallExpr e |
          e.getAControlFlowNode().getBasicBlock() = bb and
          e.getTarget() = d
        )
      )
    }

    /**
     * Holds if access/call expression `e` (targeting declaration `target`)
     * is a sub expression of a condition that controls whether basic block
     * `bb` is reached.
     */
    pragma [noinline]
    private predicate candidateAux(AccessOrCallExpr e, Declaration target, BasicBlock bb) {
      target = e.getTarget() and
      controls(bb, _, e, _)
    }
  }

  /**
   * Holds if basic block `bb` only is reached when `e` has abstract value `v`.
   * SSA qualified expression `sub` is a sub expression of `e`.
   */
  private predicate controls(BasicBlock bb, Expr e, AccessOrCallExpr sub, AbstractValue v) {
    exists(ConditionBlock cb, ConditionalSuccessor s, AbstractValue v0, Expr cond |
      cb.controls(bb, s) |
      v0.branchImplies(cb.getLastNode().getElement(), s, cond) and
      impliesSteps(cond, v0, e, v) and
      sub = e.getAChildExpr*()
    )
  }

  private cached module Cached {
    cached
    predicate isGuardedBy(AccessOrCallExpr guarded, Expr e, AccessOrCallExpr sub, AbstractValue v) {
      exists(BasicBlock bb |
        controls(bb, e, sub, v) and
        bb = guarded.getAControlFlowNode().getBasicBlock() and
        exists(ConditionOnExprComparisonConfig c | c.same(sub, guarded)) |
        not guarded.hasSsaQualifier() and not sub.hasSsaQualifier()
        or
        guarded.getSsaQualifier() = sub.getSsaQualifier()
      )
    }

    /**
     * Holds if `e1` having abstract value `v1` implies that `e2` has abstract
     * value `v2, using one step of reasoning.
     */
    cached
    predicate impliesStep(Expr e1, AbstractValue v1, Expr e2, AbstractValue v2) {
      exists(BinaryOperation bo |
        bo instanceof BitwiseAndExpr or
        bo instanceof LogicalAndExpr
      |
        bo = e1 and
        e2 = bo.getAnOperand() and
        v1 = TBooleanValue(true) and
        v2 = v1
        or
        bo = e2 and
        e1 = bo.getAnOperand() and
        v1 = TBooleanValue(false) and
        v2 = v1
      )
      or
      exists(BinaryOperation bo |
        bo instanceof BitwiseOrExpr or
        bo instanceof LogicalOrExpr
      |
        bo = e1 and
        e2 = bo.getAnOperand() and
        v1 = TBooleanValue(false) and
        v2 = v1
        or
        bo = e2 and
        e1 = bo.getAnOperand() and
        v1 = TBooleanValue(true) and
        v2 = v1
      )
      or
      e1.(LogicalNotExpr).getOperand() = e2 and
      v2 = TBooleanValue(v1.(BooleanValue).getValue().booleanNot())
      or
      e1 = e2.(LogicalNotExpr).getOperand() and
      v2 = TBooleanValue(v1.(BooleanValue).getValue().booleanNot())
      or
      exists(ComparisonTest ct, boolean polarity, BoolLiteral boolLit, boolean b |
        ct.getAnArgument() = boolLit and
        b = boolLit.getBoolValue() and
        v2 = TBooleanValue(v1.(BooleanValue).getValue().booleanXor(polarity).booleanXor(b)) |
        ct.getComparisonKind().isEquality() and
        polarity = true and
        (
          // e1 === e2 == b, v1 === !(v2 xor b)
          e1 = ct.getExpr() and
          e2 = ct.getAnArgument()
          or
          // e2 === e1 == b, v1 === !(v2 xor b)
          e1 = ct.getAnArgument() and
          e2 = ct.getExpr()
        )
        or
        ct.getComparisonKind().isInequality() and
        polarity = false and
        (
          // e1 === e2 != b, v1 === v2 xor b
          e1 = ct.getExpr() and
          e2 = ct.getAnArgument()
          or
          // e2 === e1 != true, v1 === v2 xor b
          e1 = ct.getAnArgument() and
          e2 = ct.getExpr()
        )
      )
      or
      exists(ConditionalExpr cond, boolean branch, BoolLiteral boolLit, boolean b |
        b = boolLit.getBoolValue() and
        (
          cond.getThen() = boolLit and branch = true
          or
          cond.getElse() = boolLit and branch = false
        )
      |
        e1 = cond and
        v1 = TBooleanValue(b.booleanNot()) and
        (
          // e1 === e2 ? b : x, v1 === !b, v2 === false; or
          // e1 === e2 ? x : b, v1 === !b, v2 === true
          e2 = cond.getCondition() and
          v2 = TBooleanValue(branch.booleanNot())
          or
          // e1 === x ? e2 : b, v1 === !b, v2 === v1
          e2 = cond.getThen() and
          branch = false and
          v2 = v1
          or
          // e1 === x ? b : e2, v1 === !b, v2 === v1
          e2 = cond.getElse() and
          branch = true and
          v2 = v1
        )
        or
        // e2 === e1 ? b : x, v1 === true, v2 === b; or
        // e2 === e1 ? x : b, v1 === false, v2 === b
        e1 = cond.getCondition() and
        e2 = cond and
        v1 = TBooleanValue(branch) and
        v2 = TBooleanValue(b)
      )
      or
      exists(boolean isNull |
        v2 = any(NullValue nv | if nv.isNull() then isNull = true else isNull = false) |
        e1 = e2.(DereferenceableExpr).getANullCheck(v1, isNull) and
        (e1 != e2 or v1 != v2)
      )
      or
      e1 instanceof DereferenceableExpr and
      e1 = getNullEquivParent(e2) and
      v1 instanceof NullValue and
      v1 = v2
    }
  }
  import Cached

  /**
   * Holds if `e1` having some abstract value, `v`, implies that `e2` has the same
   * abstract value `v`.
   */
  predicate impliesStepIdentity(Expr e1, Expr e2) {
    exists(PreSsa::Definition def |
      def.getDefinition().getSource() = e2 |
      e1 = def.getARead()
    )
  }

  /**
   * Holds if `e1` having abstract value `v1` implies that `e2` has abstract value
   * `v2, using zero or more steps of reasoning.
   */
  predicate impliesSteps(Expr e1, AbstractValue v1, Expr e2, AbstractValue v2) {
    e1.getType() instanceof BoolType and
    e1 = e2 and
    v1 = v2 and
    v1 = TBooleanValue(_)
    or
    v1.branchImplies(_, _, e1) and
    e2 = e1 and
    v2 = v1
    or
    exists(Expr mid, AbstractValue vMid |
      impliesSteps(e1, v1, mid, vMid) |
      impliesStep(mid, vMid, e2, v2)
      or
      impliesStepIdentity(mid, e2) and
      v2 = vMid
    )
  }
}
private import Internal
