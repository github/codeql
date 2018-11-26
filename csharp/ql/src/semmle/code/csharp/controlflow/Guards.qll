/**
 * Provides classes for working with guarded expressions.
 */

import csharp
private import ControlFlow::SuccessorTypes
private import semmle.code.csharp.commons.Assertions
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
      // Call to `string.IsNullOrEmpty()` or `string.IsNullOrWhiteSpace()`
      exists(MethodCall mc, string name |
        result = mc |
        mc.getTarget() = any(SystemStringClass c).getAMethod(name) and
        name.regexpMatch("IsNullOr(Empty|WhiteSpace)") and
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
      or
      isCustomNullCheck(result, this, v, isNull)
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
  private Guard g;
  private AccessOrCallExpr sub0;
  private AbstractValue v0;

  GuardedExpr() { isGuardedBy(this, g, sub0, v0) }

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
    result = g and
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

  /** Holds if expression `e` is a non-`null` value. */
  predicate nonNullValue(Expr e) {
    e.stripCasts() = any(Expr s | s.hasValue() and not s instanceof NullLiteral)
  }

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

  /** An expression whose value may control the execution of another element. */
  class Guard extends Expr {
    private AbstractValue val;

    Guard() {
      this.getType() instanceof BoolType and
      not this instanceof BoolLiteral and
      val = TBooleanValue(_)
      or
      this instanceof DereferenceableExpr and
      val = TNullValue(_)
      or
      val.branchImplies(_, _, this)
      or
      asserts(_, this, val)
    }

    /** Gets an abstract value that this guard may have. */
    AbstractValue getAValue() { result = val }

    /** Holds if basic block `bb` only is reached when this guard has abstract value `v`. */
    predicate controls(BasicBlock bb, AbstractValue v) {
      exists(ControlFlowElement cfe, ConditionalSuccessor s, AbstractValue v0, Guard g |
        cfe.controlsBlock(bb, s) |
        v0.branchImplies(cfe, s, g) and
        impliesSteps(g, v0, this, v)
      )
    }

    /**
     * Holds if control flow node `cfn` only is reached when this guard evaluates to `v`,
     * because of an assertion.
     */
    private predicate assertionControlsNode(ControlFlow::Node cfn, AbstractValue v) {
      exists(Assertion a, Guard g, AbstractValue v0 |
        asserts(a, g, v0) and
        impliesSteps(g, v0, this, v)
      |
        a.strictlyDominates(cfn.getBasicBlock())
        or
        exists(BasicBlock bb, int i, int j |
          bb.getNode(i) = a.getAControlFlowNode() |
          bb.getNode(j) = cfn and
          j > i
        )
      )
    }

    /**
     * Holds if control flow element `cfe` only is reached when this guard evaluates to `v`,
     * because of an assertion.
     */
    predicate assertionControlsElement(ControlFlowElement cfe, AbstractValue v) {
      forex(ControlFlow::Node cfn |
        cfn = cfe.getAControlFlowNode() |
        this.assertionControlsNode(cfn, v)
      )
    }

    /**
     * Holds if pre-basic-block `bb` only is reached when this guard has abstract value `v`,
     * not taking implications into account.
     */
    predicate preControlsDirect(PreBasicBlocks::PreBasicBlock bb, AbstractValue v) {
      exists(PreBasicBlocks::ConditionBlock cb, ConditionalSuccessor s |
        cb.controls(bb, s) |
        v.branchImplies(cb.getLastElement(), s, this)
      )
    }

    /** Holds if pre-basic-block `bb` only is reached when this guard has abstract value `v`. */
    predicate preControls(PreBasicBlocks::PreBasicBlock bb, AbstractValue v) {
      exists(AbstractValue v0, Guard g |
        g.preControlsDirect(bb, v0) |
        impliesSteps(g, v0, this, v)
      )
    }
  }

  /**
   * Holds if assertion `a` directly asserts that expression `e` evaluates to value `v`.
   */
  predicate asserts(Assertion a, Expr e, AbstractValue v) {
    e = a.getExpr() and
    (
      a.getAssertMethod() instanceof AssertTrueMethod and
      v.(BooleanValue).getValue() = true
      or
      a.getAssertMethod() instanceof AssertFalseMethod and
      v.(BooleanValue).getValue() = false
      or
      a.getAssertMethod() instanceof AssertNullMethod and
      v.(NullValue).isNull()
      or
      a.getAssertMethod() instanceof AssertNonNullMethod and
      v = any(NullValue nv | not nv.isNull())
    )
  }

  private Expr stripConditionalExpr(Expr e) {
    e = any(ConditionalExpr ce |
      result = stripConditionalExpr(ce.getThen())
      or
      result = stripConditionalExpr(ce.getElse())
    )
    or
    not e instanceof ConditionalExpr and
    result = e
  }

  private predicate canReturn(Callable c, Expr ret) {
    exists(Expr e | c.canReturn(e) | ret = stripConditionalExpr(e))
  }

  private class PreSsaImplicitParameterDefinition extends PreSsa::Definition {
    private Parameter p;

    PreSsaImplicitParameterDefinition() {
      p = this.getDefinition().(AssignableDefinitions::ImplicitParameterDefinition).getParameter()
    }

    Parameter getParameter() { result = p }

    /**
     * Holds if the callable that this parameter belongs to can return `ret`, but
     * only if this parameter is `null` or non-`null`, as specified by `isNull`.
     */
    predicate nullGuardedReturn(Expr ret, boolean isNull) {
      canReturn(p.getCallable(), ret) and
      exists(PreBasicBlocks::PreBasicBlock bb, NullValue nv |
        this.getARead().(Guard).preControls(bb, nv) |
        ret = bb.getAnElement() and
        if nv.isNull() then isNull = true else isNull = false
      )
    }
  }

  /**
   * Holds if `ret` is an expression returned by the callable to which parameter
   * `p` belongs, and `ret` having Boolean value `retVal` allows the conclusion
   * that the parameter `p` either is `null` or non-`null`, as specified by `isNull`.
   */
  private predicate validReturnInCustomNullCheck(Expr ret, Parameter p, BooleanValue retVal, boolean isNull) {
    exists(Callable c |
      canReturn(c, ret) |
      p.getCallable() = c and
      c.getReturnType() instanceof BoolType
    ) and
    exists(PreSsaImplicitParameterDefinition def |
      p = def.getParameter() |
      def.nullGuardedReturn(ret, isNull)
      or
      exists(NullValue nv |
        impliesSteps(ret, retVal, def.getARead(), nv) |
        if nv.isNull() then isNull = true else isNull = false
      )
    )
  }

  /**
   * Gets a non-overridable callable with a Boolean return value that performs a
   * `null`-check on parameter `p`. A return value having Boolean value `retVal`
   * allows us to conclude that the argument either is `null` or non-`null`, as
   * specified by `isNull`.
   */
  private Callable customNullCheck(Parameter p, BooleanValue retVal, boolean isNull) {
    result.getReturnType() instanceof BoolType and
    not result.(Virtualizable).isOverridableOrImplementable() and
    p.getCallable() = result and
    not p.isParams() and
    p.getType() = any(Type t | t instanceof RefType or t instanceof NullableType) and
    forex(Expr ret |
      canReturn(result, ret) and
      not ret.(BoolLiteral).getBoolValue() = retVal.getValue().booleanNot()
      |
      validReturnInCustomNullCheck(ret, p, retVal, isNull)
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
      exists(Guard g |
        e = g.getAChildExpr*() |
        g.controls(bb, _)
        or
        g.assertionControlsElement(bb.getANode().getElement(), _)
      )
    }
  }

  private cached module Cached {
    pragma[noinline]
    private predicate isGuardedBy0(ControlFlow::Node cfn, AccessOrCallExpr guarded, Guard g, AccessOrCallExpr sub, AbstractValue v) {
      cfn = guarded.getAControlFlowNode() and
      g.controls(cfn.getBasicBlock(), v) and
      exists(ConditionOnExprComparisonConfig c | c.same(sub, guarded))
    }

    pragma[noinline]
    private predicate isGuardedBy1(AccessOrCallExpr guarded, Guard g, AccessOrCallExpr sub, AbstractValue v) {
      forex(ControlFlow::Node cfn |
        cfn = guarded.getAControlFlowNode() |
        isGuardedBy0(cfn, guarded, g, sub, v)
      )
      or
      g.assertionControlsElement(guarded, v) and
      exists(ConditionOnExprComparisonConfig c | c.same(sub, guarded))
    }

    cached
    predicate isGuardedBy(AccessOrCallExpr guarded, Guard g, AccessOrCallExpr sub, AbstractValue v) {
      isGuardedBy1(guarded, g, sub, v) and
      sub = g.getAChildExpr*() and
      (
        not guarded.hasSsaQualifier() and not sub.hasSsaQualifier()
        or
        guarded.getSsaQualifier() = sub.getSsaQualifier()
      )
    }
  }
  import Cached

  // The predicates in this module should be cached in the same stage as the cache stage
  // in ControlFlowGraph.qll. This is to avoid recomputation of pre-basic-blocks and
  // pre-SSA predicates
  cached module CachedWithCFG {
    cached
    predicate isCustomNullCheck(Call call, Expr arg, BooleanValue v, boolean isNull) {
      exists(Callable callable, Parameter p |
        arg = call.getArgumentForParameter(any(Parameter p0 | p0.getSourceDeclaration() = p)) and
        call.getTarget().getSourceDeclaration() = callable and
        callable = customNullCheck(p, v, isNull)
      )
    }

    /**
     * Holds if the assumption that `g1` has abstract value `v1` implies that
     * `g2` has abstract value `v2`, using one step of reasoning. That is, the
     * evaluation of `g2` to `v2` dominates the evaluation of `g1` to `v1`.
     */
    cached
    predicate impliesStep(Guard g1, AbstractValue v1, Guard g2, AbstractValue v2) {
      g1 = any(BinaryOperation bo |
        (
          bo instanceof BitwiseAndExpr or
          bo instanceof LogicalAndExpr
        ) and
        g2 = bo.getAnOperand() and
        v1 = TBooleanValue(true) and
        v2 = v1
      )
      or
      g1 = any(BinaryOperation bo |
        (
          bo instanceof BitwiseOrExpr or
          bo instanceof LogicalOrExpr
        ) and
        g2 = bo.getAnOperand() and
        v1 = TBooleanValue(false) and
        v2 = v1
      )
      or
      g2 = g1.(LogicalNotExpr).getOperand() and
      v2 = TBooleanValue(v1.(BooleanValue).getValue().booleanNot())
      or
      exists(ComparisonTest ct, boolean polarity, BoolLiteral boolLit, boolean b |
        ct.getAnArgument() = boolLit and
        b = boolLit.getBoolValue() and
        g2 = ct.getAnArgument() and
        g1 = ct.getExpr() and
        v2 = TBooleanValue(v1.(BooleanValue).getValue().booleanXor(polarity).booleanXor(b)) |
        ct.getComparisonKind().isEquality() and
        polarity = true
        or
        ct.getComparisonKind().isInequality() and
        polarity = false
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
        g1 = cond and
        v1 = TBooleanValue(b.booleanNot()) and
        (
          g2 = cond.getCondition() and
          v2 = TBooleanValue(branch.booleanNot())
          or
          g2 = cond.getThen() and
          branch = false and
          v2 = v1
          or
          g2 = cond.getElse() and
          branch = true and
          v2 = v1
        )
      )
      or
      exists(boolean isNull |
        g1 = g2.(DereferenceableExpr).getANullCheck(v1, isNull) |
        v2 = any(NullValue nv | if nv.isNull() then isNull = true else isNull = false) and
        (g1 != g2 or v1 != v2)
      )
      or
      g1 instanceof DereferenceableExpr and
      g1 = getNullEquivParent(g2) and
      v1 instanceof NullValue and
      v2 = v1
      or
      exists(PreSsa::Definition def |
        def.getDefinition().getSource() = g2 |
        g1 = def.getARead() and
        v1 = g1.getAValue() and
        v2 = v1
      )
    }

    cached
    predicate forceCachingInSameStage() { any() }
  }
  import CachedWithCFG

  /**
   * Holds if the assumption that `g1` has abstract value `v1` implies that
   * `g2` has abstract value `v2`, using zero or more steps of reasoning. That is,
   * the evaluation of `g2` to `v2` dominates the evaluation of `g1` to `v1`.
   */
  predicate impliesSteps(Guard g1, AbstractValue v1, Guard g2, AbstractValue v2) {
    g1 = g2 and
    v1 = v2 and
    v1 = g1.getAValue()
    or
    exists(Expr mid, AbstractValue vMid |
      impliesSteps(g1, v1, mid, vMid) |
      impliesStep(mid, vMid, g2, v2)
    )
  }
}
private import Internal
