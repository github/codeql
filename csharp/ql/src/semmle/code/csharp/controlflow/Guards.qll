/**
 * Provides classes for working with guarded expressions.
 */

import csharp
private import cil
private import dotnet
private import ControlFlow::SuccessorTypes
private import semmle.code.csharp.commons.Assertions
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.commons.StructuralComparison::Internal
private import semmle.code.csharp.controlflow.BasicBlocks
private import semmle.code.csharp.controlflow.internal.Completion
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Linq
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic

/** An expression whose value may control the execution of another element. */
class Guard extends Expr {
  Guard() { isGuard(this, _) }

  /**
   * Holds if `cfn` is guarded by this expression having value `v`, where `sub` is
   * a sub expression of this expression that is structurally equal to the expression
   * belonging to `cfn`.
   *
   * In case `cfn` or `sub` access an SSA variable in their left-most qualifier, then
   * so must the other (accessing the same SSA variable).
   */
  predicate controlsNode(ControlFlow::Nodes::ElementNode cfn, AccessOrCallExpr sub, AbstractValue v) {
    isGuardedByNode(cfn, this, sub, v)
  }

  /**
   * Holds if basic block `bb` is guarded by this expression having value `v`.
   */
  predicate controlsBasicBlock(BasicBlock bb, AbstractValue v) {
    Internal::guardControls(this, _, bb, v)
  }

  /**
   * Holds if this guard is an equality test between `e1` and `e2`. If the test is
   * negated, that is `!=`, then `polarity` is false, otherwise `polarity` is
   * true.
   */
  predicate isEquality(Expr e1, Expr e2, boolean polarity) {
    exists(BooleanValue v |
      this = Internal::getAnEqualityCheck(e1, v, e2) and
      polarity = v.getValue()
    )
  }
}

/** An abstract value. */
abstract class AbstractValue extends TAbstractValue {
  /** Holds if the `s` branch out of `cfe` is taken iff `e` has this value. */
  abstract predicate branch(ControlFlowElement cfe, ConditionalSuccessor s, Expr e);

  /** Gets an abstract value that represents the dual of this value, if any. */
  abstract AbstractValue getDualValue();

  /**
   * Gets an expression that has this abstract value. Two expressions that have the
   * same concrete value also have the same abstract value, but not necessarily the
   * other way around.
   *
   * Moreover, `e = this.getAnExpr() implies not e = this.getDualValue().getAnExpr()`.
   */
  abstract Expr getAnExpr();

  /**
   * Holds if this is a singleton abstract value. That is, two expressions that have
   * this abstract value also have the same concrete value.
   */
  abstract predicate isSingleton();

  /**
   * Holds if this value describes a referential property. For example, emptiness
   * of a collection is a referential property.
   *
   * Such values only propagate through adjacent reads, for example, in
   *
   * ```csharp
   * int M()
   * {
   *     var x = new string[]{ "a", "b", "c" }.ToList();
   *     x.Clear();
   *     return x.Count;
   * }
   * ```
   *
   * the non-emptiness of `new string[]{ "a", "b", "c" }.ToList()` only propagates
   * to the read of `x` in `x.Clear()` and not in `x.Count`.
   *
   * Aliasing is not taken into account in the analyses.
   */
  predicate isReferentialProperty() { none() }

  /** Gets a textual representation of this abstract value. */
  abstract string toString();
}

/** Provides different types of `AbstractValues`s. */
module AbstractValues {
  /** A Boolean value. */
  class BooleanValue extends AbstractValue, TBooleanValue {
    /** Gets the underlying Boolean value. */
    boolean getValue() { this = TBooleanValue(result) }

    override predicate branch(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) {
      s.(BooleanSuccessor).getValue() = this.getValue() and
      exists(BooleanCompletion c | s.matchesCompletion(c) |
        c.isValidFor(cfe) and
        e = cfe
      )
    }

    override BooleanValue getDualValue() { result.getValue() = this.getValue().booleanNot() }

    override Expr getAnExpr() {
      result.getType() instanceof BoolType and
      result.getValue() = this.getValue().toString()
    }

    override predicate isSingleton() { any() }

    override string toString() { result = this.getValue().toString() }
  }

  /** An integer value. */
  class IntegerValue extends AbstractValue, TIntegerValue {
    /** Gets the underlying integer value. */
    int getValue() { this = TIntegerValue(result) }

    override predicate branch(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) { none() }

    override IntegerValue getDualValue() { none() }

    override Expr getAnExpr() {
      result.getValue().toInt() = this.getValue() and
      (
        result.getType() instanceof Enum
        or
        result.getType() instanceof IntegralType
      )
    }

    override predicate isSingleton() { any() }

    override string toString() { result = this.getValue().toString() }
  }

  /** A value that is either `null` or non-`null`. */
  class NullValue extends AbstractValue, TNullValue {
    /** Holds if this value represents `null`. */
    predicate isNull() { this = TNullValue(true) }

    /** Holds if this value represents non-`null`. */
    predicate isNonNull() { this = TNullValue(false) }

    override predicate branch(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) {
      this = TNullValue(s.(NullnessSuccessor).getValue()) and
      exists(NullnessCompletion c | s.matchesCompletion(c) |
        c.isValidFor(cfe) and
        e = cfe
      )
    }

    override NullValue getDualValue() {
      if this.isNull() then result.isNonNull() else result.isNull()
    }

    override DereferenceableExpr getAnExpr() {
      if this.isNull() then nullValueImplied(result) else nonNullValueImplied(result)
    }

    override predicate isSingleton() { this.isNull() }

    override string toString() { if this.isNull() then result = "null" else result = "non-null" }
  }

  /** A value that represents match or non-match against a specific pattern. */
  class MatchValue extends AbstractValue, TMatchValue {
    /** Gets the case. */
    Case getCase() { this = TMatchValue(result, _) }

    /** Holds if this value represents a match. */
    predicate isMatch() { this = TMatchValue(_, true) }

    override predicate branch(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) {
      this = TMatchValue(_, s.(MatchingSuccessor).getValue()) and
      exists(MatchingCompletion c, Switch switch, Case case | s.matchesCompletion(c) |
        c.isValidFor(cfe) and
        switchMatching(switch, case, cfe) and
        e = switch.getExpr() and
        case = this.getCase()
      )
    }

    override MatchValue getDualValue() {
      result =
        any(MatchValue mv |
          mv.getCase() = this.getCase() and
          if this.isMatch() then not mv.isMatch() else mv.isMatch()
        )
    }

    override Expr getAnExpr() { none() }

    override predicate isSingleton() { none() }

    override string toString() {
      exists(string s | s = this.getCase().getPattern().toString() |
        if this.isMatch() then result = "match " + s else result = "non-match " + s
      )
    }
  }

  /** A value that represents an empty or non-empty collection. */
  class EmptyCollectionValue extends AbstractValue, TEmptyCollectionValue {
    /** Holds if this value represents an empty collection. */
    predicate isEmpty() { this = TEmptyCollectionValue(true) }

    /** Holds if this value represents a non-empty collection. */
    predicate isNonEmpty() { this = TEmptyCollectionValue(false) }

    override predicate branch(ControlFlowElement cfe, ConditionalSuccessor s, Expr e) {
      this = TEmptyCollectionValue(s.(EmptinessSuccessor).getValue()) and
      exists(EmptinessCompletion c, ForeachStmt fs | s.matchesCompletion(c) |
        c.isValidFor(cfe) and
        foreachEmptiness(fs, cfe) and
        e = fs.getIterableExpr()
      ) and
      // Only when taking the non-empty successor do we know that the original iterator
      // expression was non-empty. When taking the empty successor, we may have already
      // iterated through the `foreach` loop zero or more times, hence the iterator
      // expression can be both empty and non-empty
      this.isNonEmpty()
    }

    override EmptyCollectionValue getDualValue() {
      if this.isEmpty() then result.isNonEmpty() else result.isEmpty()
    }

    override Expr getAnExpr() {
      this.isEmpty() and
      emptyValue(result)
      or
      this.isNonEmpty() and
      nonEmptyValue(result)
    }

    override predicate isSingleton() { none() }

    override predicate isReferentialProperty() { any() }

    override string toString() { if this.isEmpty() then result = "empty" else result = "non-empty" }
  }
}

private import AbstractValues

/**
 * An expression that evaluates to a value that can be dereferenced. That is,
 * an expression that may evaluate to `null`.
 */
class DereferenceableExpr extends Expr {
  private boolean isNullableType;

  DereferenceableExpr() {
    exists(Expr e, Type t |
      // There is currently a bug in the extractor: the type of `x?.Length` is
      // incorrectly `int`, while it should have been `int?`. We apply
      // `getNullEquivParent()` as a workaround
      this = getNullEquivParent*(e) and
      t = e.getType() and
      not this instanceof SwitchCaseExpr and
      not this instanceof PatternExpr
    |
      t instanceof NullableType and
      isNullableType = true
      or
      t instanceof RefType and
      isNullableType = false
    )
  }

  /** Holds if this expression has a nullable type `T?`. */
  predicate hasNullableType() { isNullableType = true }

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
    exists(boolean branch | branch = v.getValue() |
      // Comparison with `null`, for example `x != null`
      exists(ComparisonTest ct, ComparisonKind ck, Expr e |
        ct.getExpr() = result and
        ct.getAnArgument() = this and
        ct.getAnArgument() = e and
        e = any(NullValue nv | nv.isNull()).getAnExpr() and
        this != e and
        ck = ct.getComparisonKind()
      |
        ck.isEquality() and isNull = branch
        or
        ck.isInequality() and isNull = branch.booleanNot()
      )
      or
      // Comparison with a non-`null` value, for example `x?.Length > 0`
      exists(ComparisonTest ct, ComparisonKind ck, Expr e | ct.getExpr() = result |
        ct.getAnArgument() = this and
        ct.getAnArgument() = e and
        e = any(NullValue nv | nv.isNonNull()).getAnExpr() and
        ck = ct.getComparisonKind() and
        this != e and
        isNull = false and
        if ck.isInequality() then branch = false else branch = true
      )
      or
      // Call to `string.IsNullOrEmpty()` or `string.IsNullOrWhiteSpace()`
      exists(MethodCall mc, string name | result = mc |
        mc.getTarget() = any(SystemStringClass c).getAMethod(name) and
        name.regexpMatch("IsNullOr(Empty|WhiteSpace)") and
        mc.getArgument(0) = this and
        branch = false and
        isNull = false
      )
      or
      result =
        any(PatternMatch pm |
          pm.getExpr() = this and
          if pm.getPattern() instanceof NullLiteral
          then
            // E.g. `x is null`
            isNull = branch
          else (
            // E.g. `x is string` or `x is ""`
            branch = true and isNull = false
            or
            // E.g. `x is string` where `x` has type `string`
            pm.getPattern().(TypePatternExpr).getCheckedType() = pm.getExpr().getType() and
            branch = false and
            isNull = true
          )
        )
      or
      this.hasNullableType() and
      result =
        any(PropertyAccess pa |
          pa.getQualifier() = this and
          pa.getTarget().hasName("HasValue") and
          if branch = true then isNull = false else isNull = true
        )
      or
      isCustomNullCheck(result, this, v, isNull)
    )
  }

  /**
   * Gets an expression that tests via matching whether this expression is `null`.
   *
   * If the returned expression matches (`v.isMatch()`) or non-matches
   * (`not v.isMatch()`), then this expression is guaranteed to be `null`
   * if `isNull` is true, and non-`null` if `isNull` is false.
   *
   * For example, if the case statement `case string s` matches in
   *
   * ```csharp
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
    exists(Switch s, Case case |
      case = v.getCase() and
      this = s.getExpr() and
      result = this and
      case = s.getACase()
    |
      // E.g. `case string`
      case.getPattern() instanceof TypePatternExpr and
      v.isMatch() and
      isNull = false
      or
      case.getPattern() =
        any(ConstantPatternExpr cpe |
          if cpe instanceof NullLiteral
          then
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
    exists(NullnessCompletion c | c.isValidFor(this) |
      result = this and
      if c.isNull()
      then (
        v.isNull() and
        isNull = true
      ) else (
        v.isNonNull() and
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

/**
 * An expression that evaluates to a collection. That is, an expression whose
 * (transitive, reflexive) base type is `IEnumerable`.
 */
class CollectionExpr extends Expr {
  CollectionExpr() {
    this.getType().(ValueOrRefType).getABaseType*() instanceof SystemCollectionsIEnumerableInterface
  }

  /**
   * Gets an expression that computes the size of this collection. `lowerBound`
   * indicates whether the expression only computes a lower bound.
   */
  private Expr getASizeExpr(boolean lowerBound) {
    lowerBound = false and
    result =
      any(PropertyRead pr |
        this = pr.getQualifier() and
        pr.getTarget() = any(SystemArrayClass x).getLengthProperty()
      )
    or
    lowerBound = false and
    result =
      any(PropertyRead pr |
        this = pr.getQualifier() and
        pr
            .getTarget()
            .overridesOrImplementsOrEquals(any(Property p |
                p.getSourceDeclaration() =
                  any(SystemCollectionsGenericICollectionInterface x).getCountProperty()
              ))
      )
    or
    result =
      any(MethodCall mc |
        mc.getTarget().getSourceDeclaration() =
          any(SystemLinq::SystemLinqEnumerableClass x).getACountMethod() and
        this = mc.getArgument(0) and
        if mc.getNumberOfArguments() = 1 then lowerBound = false else lowerBound = true
      )
  }

  private Expr getABooleanEmptinessCheck(BooleanValue v, boolean isEmpty) {
    exists(boolean branch | branch = v.getValue() |
      result =
        any(ComparisonTest ct |
          exists(boolean lowerBound |
            ct.getAnArgument() = this.getASizeExpr(lowerBound) and
            if isEmpty = true then lowerBound = false else any()
          |
            // x.Length == 0
            ct.getComparisonKind().isEquality() and
            ct.getAnArgument().getValue().toInt() = 0 and
            branch = isEmpty
            or
            // x.Length == k, k > 0
            ct.getComparisonKind().isEquality() and
            ct.getAnArgument().getValue().toInt() > 0 and
            branch = true and
            isEmpty = false
            or
            // x.Length != 0
            ct.getComparisonKind().isInequality() and
            ct.getAnArgument().getValue().toInt() = 0 and
            branch = isEmpty.booleanNot()
            or
            // x.Length != k, k != 0
            ct.getComparisonKind().isInequality() and
            ct.getAnArgument().getValue().toInt() != 0 and
            branch = false and
            isEmpty = false
            or
            // x.Length > k, k >= 0
            ct.getComparisonKind().isLessThan() and
            ct.getFirstArgument().getValue().toInt() >= 0 and
            branch = true and
            isEmpty = false
            or
            // x.Length >= k, k > 0
            ct.getComparisonKind().isLessThanEquals() and
            ct.getFirstArgument().getValue().toInt() > 0 and
            branch = true and
            isEmpty = false
          )
        ).getExpr()
      or
      result =
        any(MethodCall mc |
          mc.getTarget().getSourceDeclaration() =
            any(SystemLinq::SystemLinqEnumerableClass x).getAnAnyMethod() and
          this = mc.getArgument(0) and
          branch = isEmpty.booleanNot() and
          if branch = false then mc.getNumberOfArguments() = 1 else any()
        )
    )
  }

  /**
   * Gets an expression that tests whether this expression is empty.
   *
   * If the returned expression has abstract value `v`, then this expression is
   * guaranteed to be empty if `isEmpty` is true, and non-empty if `isEmpty` is
   * false.
   *
   * For example, if the expression `x.Length != 0` evaluates to `true` then the
   * expression `x` is guaranteed to be non-empty.
   */
  Expr getAnEmptinessCheck(AbstractValue v, boolean isEmpty) {
    result = this.getABooleanEmptinessCheck(v, isEmpty)
  }
}

/** An expression that accesses/calls a declaration. */
class AccessOrCallExpr extends Expr {
  private Declaration target;

  AccessOrCallExpr() { target = getDeclarationTarget(this) }

  /** Gets the target of this expression. */
  Declaration getTarget() { result = target }

  /**
   * Gets a (non-trivial) SSA definition corresponding to the longest
   * qualifier chain of this expression, if any.
   *
   * This includes the case where this expression is itself an access to an
   * SSA definition.
   *
   * Examples:
   *
   * ```csharp
   * x.Foo.Bar();   // SSA qualifier: SSA definition for `x.Foo`
   * x.Bar();       // SSA qualifier: SSA definition for `x`
   * x.Foo().Bar(); // SSA qualifier: SSA definition for `x`
   * x;             // SSA qualifier: SSA definition for `x`
   * ```
   *
   * An expression can have more than one SSA qualifier in the presence
   * of control flow splitting.
   */
  Ssa::Definition getAnSsaQualifier(ControlFlow::Node cfn) { result = getAnSsaQualifier(this, cfn) }
}

private Declaration getDeclarationTarget(Expr e) {
  e = any(AssignableAccess aa | result = aa.getTarget()) or
  result = e.(Call).getTarget()
}

private Ssa::Definition getAnSsaQualifier(Expr e, ControlFlow::Node cfn) {
  e = getATrackedAccess(result, cfn)
  or
  not e = getATrackedAccess(_, _) and
  result = getAnSsaQualifier(e.(QualifiableExpr).getQualifier(), cfn)
}

private AssignableAccess getATrackedAccess(Ssa::Definition def, ControlFlow::Node cfn) {
  result = def.getAReadAtNode(cfn) and
  not def instanceof Ssa::ImplicitUntrackedDefinition
  or
  result = def.(Ssa::ExplicitDefinition).getADefinition().getTargetAccess() and
  cfn = def.getControlFlowNode()
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
 * ```csharp
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
 * ```csharp
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

  GuardedExpr() { isGuardedByExpr(this, g, sub0, v0) }

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
  Guard getAGuard(Expr sub, AbstractValue v) {
    result = g and
    sub = sub0 and
    v = v0
  }

  /**
   * Holds if this expression must have abstract value `v`. That is, this
   * expression is guarded by a structurally equal expression having abstract
   * value `v`.
   */
  predicate mustHaveValue(AbstractValue v) { g = this.getAGuard(g, v) }

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

/**
 * A guarded control flow node. A guarded control flow node is like a guarded
 * expression (`GuardedExpr`), except control flow graph splitting is taken
 * into account. That is, one control flow node belonging to an expression may
 * be guarded, while another split need not be guarded:
 *
 * ```csharp
 * if (b)
 *     if (x == null)
 *         return;
 * x.ToString();
 * if (b)
 *     ...
 * ```
 *
 * In the example above, the node for `x.ToString()` is null-guarded in the
 * split `b == true`, but not in the split `b == false`.
 */
class GuardedControlFlowNode extends ControlFlow::Nodes::ElementNode {
  private Guard g;
  private AccessOrCallExpr sub0;
  private AbstractValue v0;

  GuardedControlFlowNode() { g.controlsNode(this, sub0, v0) }

  /**
   * Gets an expression that guards this control flow node. That is, this control
   * flow node is only reached when the returned expression has abstract value `v`.
   *
   * The expression `sub` is a sub expression of the guarding expression that is
   * structurally equal to the expression belonging to this control flow node.
   *
   * In case this control flow node or `sub` accesses an SSA variable in its
   * left-most qualifier, then so must the other (accessing the same SSA
   * variable).
   */
  Guard getAGuard(Expr sub, AbstractValue v) {
    result = g and
    sub = sub0 and
    v = v0
  }

  /**
   * Holds if this control flow node must have abstract value `v`. That is, this
   * control flow node is guarded by a structurally equal expression having
   * abstract value `v`.
   */
  predicate mustHaveValue(AbstractValue v) { g = this.getAGuard(g, v) }
}

/**
 * A guarded data flow node. A guarded data flow node is like a guarded expression
 * (`GuardedExpr`), except control flow graph splitting is taken into account. That
 * is, one data flow node belonging to an expression may be guarded, while another
 * split need not be guarded:
 *
 * ```csharp
 * if (b)
 *     if (x == null)
 *         return;
 * x.ToString();
 * if (b)
 *     ...
 * ```
 *
 * In the example above, the node for `x.ToString()` is null-guarded in the
 * split `b == true`, but not in the split `b == false`.
 */
class GuardedDataFlowNode extends DataFlow::ExprNode {
  private Guard g;
  private AccessOrCallExpr sub0;
  private AbstractValue v0;

  GuardedDataFlowNode() {
    exists(ControlFlow::Nodes::ElementNode cfn | exists(this.getExprAtNode(cfn)) |
      g.controlsNode(cfn, sub0, v0)
    )
  }

  /**
   * Gets an expression that guards this data flow node. That is, this data flow
   * node is only reached when the returned expression has abstract value `v`.
   *
   * The expression `sub` is a sub expression of the guarding expression that is
   * structurally equal to the expression belonging to this data flow node.
   *
   * In case this data flow node or `sub` accesses an SSA variable in its
   * left-most qualifier, then so must the other (accessing the same SSA
   * variable).
   */
  Guard getAGuard(Expr sub, AbstractValue v) {
    result = g and
    sub = sub0 and
    v = v0
  }

  /**
   * Holds if this data flow node must have abstract value `v`. That is, this
   * data flow node is guarded by a structurally equal expression having
   * abstract value `v`.
   */
  predicate mustHaveValue(AbstractValue v) { g = this.getAGuard(g, v) }
}

/** An expression guarded by a `null` check. */
class NullGuardedExpr extends GuardedExpr {
  NullGuardedExpr() { this.mustHaveValue(any(NullValue v | v.isNonNull())) }
}

/** A data flow node guarded by a `null` check. */
class NullGuardedDataFlowNode extends GuardedDataFlowNode {
  NullGuardedDataFlowNode() { this.mustHaveValue(any(NullValue v | v.isNonNull())) }
}

/** INTERNAL: Do not use. */
module Internal {
  private import semmle.code.cil.CallableReturns

  newtype TAbstractValue =
    TBooleanValue(boolean b) { b = true or b = false } or
    TIntegerValue(int i) { i = any(Expr e).getValue().toInt() } or
    TNullValue(boolean b) { b = true or b = false } or
    TMatchValue(Case c, boolean b) {
      exists(c.getPattern()) and
      (b = true or b = false)
    } or
    TEmptyCollectionValue(boolean b) { b = true or b = false }

  /** A callable that always returns a `null` value. */
  private class NullCallable extends Callable {
    NullCallable() {
      exists(CIL::Method m | m.matchesHandle(this) | alwaysNullMethod(m) and not m.isVirtual())
    }
  }

  /** Holds if expression `e` is a `null` value. */
  predicate nullValue(Expr e) {
    e instanceof NullLiteral
    or
    e instanceof DefaultValueExpr and e.getType().isRefType()
    or
    e.(Call).getTarget().getSourceDeclaration() instanceof NullCallable
  }

  /** Holds if expression `e2` is a `null` value whenever `e1` is. */
  predicate nullValueImpliedUnary(Expr e1, Expr e2) {
    e1 = e2.(AssignExpr).getRValue()
    or
    e1 = e2.(Cast).getExpr()
    or
    e2 = e1.(NullCoalescingExpr).getAnOperand()
  }

  /** Holds if expression `e3` is a `null` value whenever `e1` and `e2` are. */
  predicate nullValueImpliedBinary(Expr e1, Expr e2, Expr e3) {
    e3 = any(ConditionalExpr ce | e1 = ce.getThen() and e2 = ce.getElse())
    or
    e3 = any(NullCoalescingExpr nce | e1 = nce.getLeftOperand() and e2 = nce.getRightOperand())
  }

  /** A callable that always returns a non-`null` value. */
  private class NonNullCallable extends Callable {
    NonNullCallable() {
      exists(CIL::Method m | m.matchesHandle(this) | alwaysNotNullMethod(m) and not m.isVirtual())
      or
      this = any(SystemObjectClass c).getGetTypeMethod()
    }
  }

  /** Holds if expression `e` is a non-`null` value. */
  predicate nonNullValue(Expr e) {
    e instanceof ObjectCreation
    or
    e instanceof ArrayCreation
    or
    e.hasNotNullFlowState()
    or
    e.hasValue() and
    exists(Expr stripped | stripped = e.stripCasts() |
      not stripped instanceof NullLiteral and
      not stripped instanceof DefaultValueExpr
    )
    or
    e instanceof ThisAccess
    or
    // "In string concatenation operations, the C# compiler treats a null string the same as an empty string."
    // (https://docs.microsoft.com/en-us/dotnet/csharp/how-to/concatenate-multiple-strings)
    e instanceof AddExpr and
    e.getType() instanceof StringType
    or
    e.(DefaultValueExpr).getType().isValueType()
    or
    e.(Call).getTarget().getSourceDeclaration() instanceof NonNullCallable and
    not e.(QualifiableExpr).isConditional()
    or
    e instanceof SuppressNullableWarningExpr
    or
    e.stripCasts().getType() = any(ValueType t | not t instanceof NullableType)
  }

  /** Holds if expression `e2` is a non-`null` value whenever `e1` is. */
  predicate nonNullValueImpliedUnary(Expr e1, Expr e2) {
    e1 = e2.(CastExpr).getExpr()
    or
    e1 = e2.(AssignExpr).getRValue()
    or
    e1 = e2.(NullCoalescingExpr).getAnOperand()
  }

  /**
   * Gets the parent expression of `e` which is `null` iff `e` is `null`,
   * if any. For example, `result = x?.y` and `e = x`, or `result = x + 1`
   * and `e = x`.
   */
  Expr getNullEquivParent(Expr e) {
    result =
      any(QualifiableExpr qe |
        qe.isConditional() and
        (
          e = qe.getQualifier()
          or
          e = qe.(ExtensionMethodCall).getArgument(0)
        ) and
        (
          // The accessed declaration must have a value type in order
          // for `only if` to hold
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
      // The other operand must be provably non-null in order
      // for `only if` to hold
      o = any(NullValue nv | nv.isNonNull()).getAnExpr() and
      e != o
    )
  }

  /**
   * Gets a child expression of `e` which is `null` only if `e` is `null`.
   */
  Expr getANullImplyingChild(Expr e) {
    e =
      any(QualifiableExpr qe |
        qe.isConditional() and
        result = qe.getQualifier()
      )
    or
    // In C#, `null + 1` has type `int?` with value `null`
    e = any(BinaryArithmeticOperation bao | result = bao.getAnOperand())
  }

  /** Same as `this.getAChildExpr*()`, but avoids `fastTC`. */
  private Expr getAChildExprStar(Guard g) {
    result = g
    or
    result = getAChildExprStar(g).getAChildExpr()
  }

  private Expr stripConditionalExpr(Expr e) {
    e =
      any(ConditionalExpr ce |
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

  // The predicates in this module should be evaluated in the same stage as the CFG
  // construction stage. This is to avoid recomputation of pre-basic-blocks and
  // pre-SSA predicates
  private module PreCFG {
    private import semmle.code.csharp.controlflow.internal.PreBasicBlocks as PreBasicBlocks
    private import semmle.code.csharp.controlflow.internal.PreSsa as PreSsa

    /**
     * Holds if pre-basic-block `bb` only is reached when guard `g` has abstract value `v`,
     * not taking implications into account.
     */
    private predicate preControlsDirect(Guard g, PreBasicBlocks::PreBasicBlock bb, AbstractValue v) {
      exists(PreBasicBlocks::ConditionBlock cb, ConditionalSuccessor s | cb.controls(bb, s) |
        v.branch(cb.getLastElement(), s, g)
      )
    }

    /** Holds if pre-basic-block `bb` only is reached when guard `g` has abstract value `v`. */
    predicate preControls(Guard g, PreBasicBlocks::PreBasicBlock bb, AbstractValue v) {
      exists(AbstractValue v0, Guard g0 | preControlsDirect(g0, bb, v0) |
        preImpliesSteps(g0, v0, g, v)
      )
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
          preControls(this.getARead(), bb, nv)
        |
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
    private predicate validReturnInCustomNullCheck(
      Expr ret, Parameter p, BooleanValue retVal, boolean isNull
    ) {
      exists(Callable c | canReturn(c, ret) |
        p.getCallable() = c and
        c.getReturnType() instanceof BoolType
      ) and
      exists(PreSsaImplicitParameterDefinition def | p = def.getParameter() |
        def.nullGuardedReturn(ret, isNull)
        or
        exists(NullValue nv | preImpliesSteps(ret, retVal, def.getARead(), nv) |
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

    pragma[noinline]
    private predicate conditionalAssign0(
      Guard guard, AbstractValue vGuard, PreSsa::Definition def, Expr e, PreSsa::Definition upd,
      PreBasicBlocks::PreBasicBlock bbGuard
    ) {
      e = upd.getDefinition().getSource() and
      upd = def.getAPhiInput() and
      preControlsDirect(guard, upd.getBasicBlock(), vGuard) and
      bbGuard.getAnElement() = guard and
      bbGuard.strictlyDominates(def.getBasicBlock()) and
      not preControlsDirect(guard, def.getBasicBlock(), vGuard)
    }

    pragma[noinline]
    private predicate conditionalAssign1(
      Guard guard, AbstractValue vGuard, PreSsa::Definition def, Expr e, PreSsa::Definition upd,
      PreBasicBlocks::PreBasicBlock bbGuard, PreSsa::Definition other
    ) {
      conditionalAssign0(guard, vGuard, def, e, upd, bbGuard) and
      other != upd and
      other = def.getAPhiInput()
    }

    pragma[noinline]
    private predicate conditionalAssign2(
      Guard guard, AbstractValue vGuard, PreSsa::Definition def, Expr e, PreSsa::Definition upd,
      PreBasicBlocks::PreBasicBlock bbGuard, PreSsa::Definition other
    ) {
      conditionalAssign1(guard, vGuard, def, e, upd, bbGuard, other) and
      preControlsDirect(guard, other.getBasicBlock(), vGuard.getDualValue())
    }

    /** Gets the successor block that is reached when guard `g` has abstract value `v`. */
    private PreBasicBlocks::PreBasicBlock getConditionalSuccessor(Guard g, AbstractValue v) {
      exists(PreBasicBlocks::ConditionBlock pred, ConditionalSuccessor s |
        v.branch(pred.getLastElement(), s, g)
      |
        result = pred.getASuccessorByType(s)
      )
    }

    pragma[noinline]
    private predicate conditionalAssign3(
      Guard guard, AbstractValue vGuard, PreSsa::Definition def, Expr e, PreSsa::Definition upd,
      PreBasicBlocks::PreBasicBlock bbGuard, PreSsa::Definition other
    ) {
      conditionalAssign1(guard, vGuard, def, e, upd, bbGuard, other) and
      other.getBasicBlock().dominates(bbGuard) and
      not PreSsa::ssaDefReachesEndOfBlock(getConditionalSuccessor(guard, vGuard), other, _)
    }

    /**
     * Holds if the evaluation of `guard` to `vGuard` implies that `def` is assigned
     * expression `e`.
     */
    private predicate conditionalAssign(
      Guard guard, AbstractValue vGuard, PreSsa::Definition def, Expr e
    ) {
      // For example:
      //   v = guard ? e : x;
      exists(ConditionalExpr c | c = def.getDefinition().getSource() |
        guard = c.getCondition() and
        vGuard =
          any(BooleanValue bv |
            bv.getValue() = true and
            e = c.getThen()
            or
            bv.getValue() = false and
            e = c.getElse()
          )
      )
      or
      exists(PreSsa::Definition upd, PreBasicBlocks::PreBasicBlock bbGuard |
        conditionalAssign0(guard, vGuard, def, e, upd, bbGuard)
      |
        forall(PreSsa::Definition other |
          conditionalAssign1(guard, vGuard, def, e, upd, bbGuard, other)
        |
          // For example:
          //   if (guard)
          //     upd = a;
          //   else
          //     other = b;
          //   def = phi(upd, other)
          conditionalAssign2(guard, vGuard, def, e, upd, bbGuard, other)
          or
          // For example:
          //   other = a;
          //   if (guard)
          //       upd = b;
          //   def = phi(other, upd)
          conditionalAssign3(guard, vGuard, def, e, upd, bbGuard, other)
        )
      )
    }

    /**
     * Holds if the evaluation of `guard` to `vGuard` implies that `def` is assigned
     * an expression with abstract value `vDef`.
     */
    private predicate conditionalAssignVal(
      Expr guard, AbstractValue vGuard, PreSsa::Definition def, AbstractValue vDef
    ) {
      conditionalAssign(guard, vGuard, def, vDef.getAnExpr())
    }

    pragma[noinline]
    private predicate relevantEq(PreSsa::Definition def, AbstractValue v, AssignableRead ar) {
      conditionalAssignVal(_, _, def, v) and
      ar = def.getARead()
    }

    /**
     * Gets an expression that directly tests whether expression `e1` is equal
     * to expression `e2`.
     *
     * If the returned expression evaluates to `v`, then expression `e1` is
     * guaranteed to be equal to `e2`, otherwise it is guaranteed to not be
     * equal to `e2`.
     *
     * For example, if the expression `x != ""` evaluates to `false` then the
     * expression `x` is guaranteed to be equal to `""`.
     */
    private Expr getABooleanEqualityCheck(Expr e1, BooleanValue v, Expr e2) {
      exists(boolean branch | branch = v.getValue() |
        exists(ComparisonTest ct, ComparisonKind ck |
          ct.getExpr() = result and
          ct.getAnArgument() = e1 and
          ct.getAnArgument() = e2 and
          e2 != e1 and
          ck = ct.getComparisonKind()
        |
          ck.isEquality() and branch = true
          or
          ck.isInequality() and branch = false
        )
        or
        result =
          any(IsExpr ie |
            ie.getExpr() = e1 and
            e2 = ie.getPattern().(ConstantPatternExpr) and
            branch = true
          )
      )
    }

    /**
     * Gets an expression that tests via matching whether expression `e1` is equal
     * to expression `e2`.
     *
     * If the returned expression matches (`v.isMatch()`), then expression `e1` is
     * guaranteed to be equal to `e2`. If the returned expression non-matches
     * (`not v.isMatch()`), then this expression is guaranteed to not be equal to `e2`.
     *
     * For example, if the case statement `case ""` matches in
     *
     * ```csharp
     * switch (o)
     * {
     *     case "":
     *         return s;
     *     default:
     *         return "";
     * }
     * ```
     *
     * then `o` is guaranteed to be equal to `""`.
     */
    private Expr getAMatchingEqualityCheck(Expr e1, MatchValue v, Expr e2) {
      exists(Switch s, Case case | case = v.getCase() |
        e1 = s.getExpr() and
        result = e1 and
        case = s.getACase() and
        e2 = case.getPattern().(ConstantPatternExpr) and
        v.isMatch()
      )
    }

    private Expr getAnEqualityCheckVal(Expr e, AbstractValue v, AbstractValue vExpr) {
      result = getAnEqualityCheck(e, v, vExpr.getAnExpr())
    }

    /**
     * Holds if the evaluation of `guard` to `vGuard` implies that `def` does not
     * have the value `vDef`.
     */
    private predicate guardImpliesNotEqual(
      Expr guard, AbstractValue vGuard, PreSsa::Definition def, AbstractValue vDef
    ) {
      exists(AssignableRead ar | relevantEq(def, vDef, ar) |
        // For example:
        //   if (de == null); vGuard = TBooleanValue(false); vDef = TNullValue(true)
        // but not
        //   if (de == "abc"); vGuard = TBooleanValue(false); vDef = TNullValue(false)
        guard = getAnEqualityCheckVal(ar, vGuard.getDualValue(), vDef) and
        vDef.isSingleton()
        or
        // For example:
        //   if (de != null); vGuard = TBooleanValue(true); vDef = TNullValue(true)
        // or
        //   if (de == null); vGuard = TBooleanValue(true); vDef = TNullValue(false)
        exists(NullValue nv |
          guard =
            ar.(DereferenceableExpr).getANullCheck(vGuard, any(boolean b | nv = TNullValue(b)))
        |
          vDef = nv.getDualValue()
        )
        or
        // For example:
        //   if (de == false); vGuard = TBooleanValue(true); vDef = TBooleanValue(true)
        guard = getAnEqualityCheckVal(ar, vGuard, vDef.getDualValue())
      )
    }

    /**
     * Holds if `def` can have a value that is not representable as an
     * abstract value.
     */
    private predicate hasPossibleUnknownValue(PreSsa::Definition def) {
      exists(PreSsa::Definition input | input = def.getAnUltimateDefinition() |
        not exists(input.getDefinition().getSource())
        or
        exists(Expr e | e = stripConditionalExpr(input.getDefinition().getSource()) |
          not e = any(AbstractValue v).getAnExpr()
        )
      )
    }

    /**
     * Gets an ultimate definition of `def` that is not itself a phi node. The
     * boolean `fromBackEdge` indicates whether the flow from `result` to `def`
     * goes through a back edge.
     */
    private PreSsa::Definition getADefinition(PreSsa::Definition def, boolean fromBackEdge) {
      result = def and
      not exists(def.getAPhiInput()) and
      fromBackEdge = false
      or
      exists(PreSsa::Definition input, PreBasicBlocks::PreBasicBlock pred, boolean fbe |
        input = def.getAPhiInput()
      |
        pred = def.getBasicBlock().getAPredecessor() and
        PreSsa::ssaDefReachesEndOfBlock(pred, input, _) and
        result = getADefinition(input, fbe) and
        (if def.getBasicBlock().dominates(pred) then fromBackEdge = true else fromBackEdge = fbe)
      )
    }

    /**
     * Holds if `e` has abstract value `v` and may be assigned to `def`. The Boolean
     * `fromBackEdge` indicates whether the flow from `e` to `def` goes through a
     * back edge.
     */
    private predicate possibleValue(
      PreSsa::Definition def, boolean fromBackEdge, Expr e, AbstractValue v
    ) {
      not hasPossibleUnknownValue(def) and
      exists(PreSsa::Definition input | input = getADefinition(def, fromBackEdge) |
        e = stripConditionalExpr(input.getDefinition().getSource()) and
        v.getAnExpr() = e
      )
    }

    private predicate nonUniqueValue(PreSsa::Definition def, Expr e, AbstractValue v) {
      possibleValue(def, false, e, v) and
      possibleValue(def, _, any(Expr other | other != e), v)
    }

    /**
     * Holds if `e` has abstract value `v` and may be assigned to `def` without going
     * through back edges, and all other possible ultimate definitions of `def` do not
     * have abstract value `v`. The trivial case where `def` is an explicit update with
     * source `e` is excluded.
     */
    private predicate uniqueValue(PreSsa::Definition def, Expr e, AbstractValue v) {
      possibleValue(def, false, e, v) and
      not nonUniqueValue(def, e, v) and
      exists(Expr other | possibleValue(def, _, other, _) and other != e)
    }

    /**
     * Holds if `guard` having abstract value `vGuard` implies that `def` has
     * abstract value `vDef`.
     */
    private predicate guardImpliesEqual(
      Guard guard, AbstractValue vGuard, PreSsa::Definition def, AbstractValue vDef
    ) {
      guard = getAnEqualityCheck(def.getARead(), vGuard, vDef.getAnExpr())
    }

    private predicate nullDef(PreSsa::Definition def) {
      nullValueImplied(def.getDefinition().getSource())
    }

    private predicate nonNullDef(PreSsa::Definition def) {
      nonNullValueImplied(def.getDefinition().getSource())
    }

    private predicate emptyDef(PreSsa::Definition def) {
      emptyValue(def.getDefinition().getSource())
    }

    private predicate nonEmptyDef(PreSsa::Definition def) {
      nonEmptyValue(def.getDefinition().getSource())
    }

    cached
    private module CachedWithCFG {
      private import semmle.code.csharp.Caching

      cached
      predicate isGuard(Expr e, AbstractValue val) {
        (
          e.getType() instanceof BoolType and
          not e instanceof BoolLiteral and
          not e instanceof SwitchCaseExpr and
          not e instanceof PatternExpr and
          val = TBooleanValue(_)
          or
          e instanceof DereferenceableExpr and
          val = TNullValue(_)
          or
          val.branch(_, _, e)
          or
          e instanceof CollectionExpr and
          val = TEmptyCollectionValue(_)
        ) and
        not e = any(ExprStmt es).getExpr() and
        not e = any(LocalVariableDeclStmt s).getAVariableDeclExpr()
      }

      /**
       * Gets an expression that tests whether expression `e1` is equal to
       * expression `e2`.
       *
       * If the returned expression has abstract value `v`, then expression `e1` is
       * guaranteed to be equal to `e2`, and if the returned expression has abstract
       * value `v.getDualValue()`, then this expression is guaranteed to be
       * non-equal to `e`.
       *
       * For example, if the expression `x != ""` evaluates to `false` then the
       * expression `x` is guaranteed to be equal to `""`.
       */
      cached
      Expr getAnEqualityCheck(Expr e1, AbstractValue v, Expr e2) {
        result = getABooleanEqualityCheck(e1, v, e2)
        or
        result = getABooleanEqualityCheck(e2, v, e1)
        or
        result = getAMatchingEqualityCheck(e1, v, e2)
        or
        result = getAMatchingEqualityCheck(e2, v, e1)
      }

      cached
      predicate isCustomNullCheck(Call call, Expr arg, BooleanValue v, boolean isNull) {
        exists(Callable callable, Parameter p |
          arg = call.getArgumentForParameter(any(Parameter p0 | p0.getSourceDeclaration() = p)) and
          call.getTarget().getSourceDeclaration() = callable and
          callable = customNullCheck(p, v, isNull)
        )
      }

      private predicate firstReadSameVarUniquePredecesssor(
        PreSsa::Definition def, AssignableRead read
      ) {
        PreSsa::firstReadSameVar(def, read) and
        not exists(AssignableRead other | PreSsa::adjacentReadPairSameVar(other, read) |
          other != read
        )
      }

      /**
       * Holds if the assumption that `g1` has abstract value `v1` implies that
       * `g2` has abstract value `v2`, using one step of reasoning. That is, the
       * evaluation of `g2` to `v2` dominates the evaluation of `g1` to `v1`.
       *
       * This predicate does not rely on the control flow graph.
       */
      cached
      predicate preImpliesStep(Guard g1, AbstractValue v1, Guard g2, AbstractValue v2) {
        g1 =
          any(BinaryOperation bo |
            (
              bo instanceof BitwiseAndExpr or
              bo instanceof LogicalAndExpr
            ) and
            g2 = bo.getAnOperand() and
            v1 = TBooleanValue(true) and
            v2 = v1
          )
        or
        g1 =
          any(BinaryOperation bo |
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
          v2 = TBooleanValue(v1.(BooleanValue).getValue().booleanXor(polarity).booleanXor(b))
        |
          ct.getComparisonKind().isEquality() and
          polarity = true
          or
          ct.getComparisonKind().isInequality() and
          polarity = false
        )
        or
        exists(ConditionalExpr cond, boolean branch, Expr e, AbstractValue v |
          e = v.getAnExpr() and
          (
            cond.getThen() = e and branch = true
            or
            cond.getElse() = e and branch = false
          )
        |
          g1 = cond and
          v1 = v.getDualValue() and
          (
            // g1 === g2 ? e : ...;
            g2 = cond.getCondition() and
            v2 = TBooleanValue(branch.booleanNot())
            or
            // g1 === ... ? g2 : e
            g2 = cond.getThen() and
            branch = false and
            v2 = v1
            or
            // g1 === g2 ? ... : e
            g2 = cond.getElse() and
            branch = true and
            v2 = v1
          )
        )
        or
        isGuard(g1, v1) and
        v1 =
          any(MatchValue mv |
            mv.isMatch() and
            g2 = g1 and
            v2.getAnExpr() = mv.getCase().getPattern().(ConstantPatternExpr) and
            v1 != v2
          )
        or
        exists(boolean isNull | g1 = g2.(DereferenceableExpr).getANullCheck(v1, isNull) |
          v2 = any(NullValue nv | if nv.isNull() then isNull = true else isNull = false) and
          (g1 != g2 or v1 != v2)
        )
        or
        exists(boolean isEmpty | g1 = g2.(CollectionExpr).getAnEmptinessCheck(v1, isEmpty) |
          v2 =
            any(EmptyCollectionValue ecv | if ecv.isEmpty() then isEmpty = true else isEmpty = false) and
          g1 != g2
        )
        or
        g1 instanceof DereferenceableExpr and
        g1 = getNullEquivParent(g2) and
        v1 instanceof NullValue and
        v2 = v1
        or
        g1 instanceof DereferenceableExpr and
        g2 = getANullImplyingChild(g1) and
        v1.(NullValue).isNonNull() and
        v2 = v1
        or
        g2 = g1.(AssignExpr).getRValue() and
        isGuard(g1, v1) and
        v2 = v1
        or
        g2 = g1.(Assignment).getLValue() and
        isGuard(g1, v1) and
        v2 = v1
        or
        g2 = g1.(CastExpr).getExpr() and
        isGuard(g1, v1) and
        v2 = v1.(NullValue)
        or
        exists(PreSsa::Definition def |
          def.getDefinition().getSource() = g2 and
          g1 = def.getARead() and
          isGuard(g1, v1) and
          v2 = v1 and
          if v1.isReferentialProperty() then firstReadSameVarUniquePredecesssor(def, g1) else any()
        )
        or
        exists(PreSsa::Definition def, AbstractValue v |
          // If for example `def = g2 ? v : ...`, then a guard `g1` proving `def != v`
          // ensures that `g2` evaluates to `false`.
          conditionalAssignVal(g2, v2.getDualValue(), def, v) and
          guardImpliesNotEqual(g1, v1, def, v)
        )
        or
        exists(PreSsa::Definition def, Expr e, AbstractValue v |
          // If for example `def = g2 ? v : ...` and all other assignments to `def` are
          // different from `v`, then a guard proving `def == v` ensures that `g2`
          // evaluates to `true`.
          uniqueValue(def, e, v) and
          guardImpliesEqual(g1, v1, def, v) and
          preControlsDirect(g2, any(PreBasicBlocks::PreBasicBlock bb | e = bb.getAnElement()), v2) and
          not preControlsDirect(g2, any(PreBasicBlocks::PreBasicBlock bb | g1 = bb.getAnElement()),
            v2)
        )
        or
        g2 = g1.(NullCoalescingExpr).getAnOperand() and
        v1.(NullValue).isNull() and
        v2 = v1
      }

      cached
      predicate nullValueImplied(Expr e) {
        nullValue(e)
        or
        exists(Expr e1 | nullValueImplied(e1) and nullValueImpliedUnary(e1, e))
        or
        exists(Expr e1, Expr e2 |
          nullValueImplied(e1) and nullValueImplied(e2) and nullValueImpliedBinary(e1, e2, e)
        )
        or
        e =
          any(PreSsa::Definition def |
            forex(PreSsa::Definition u | u = def.getAnUltimateDefinition() | nullDef(u))
          ).getARead()
      }

      cached
      predicate nonNullValueImplied(Expr e) {
        nonNullValue(e)
        or
        exists(Expr e1 | nonNullValueImplied(e1) and nonNullValueImpliedUnary(e1, e))
        or
        e =
          any(PreSsa::Definition def |
            forex(PreSsa::Definition u | u = def.getAnUltimateDefinition() | nonNullDef(u))
          ).getARead()
      }

      private predicate adjacentReadPairSameVarUniquePredecessor(
        AssignableRead read1, AssignableRead read2
      ) {
        PreSsa::adjacentReadPairSameVar(read1, read2) and
        not exists(AssignableRead other |
          PreSsa::adjacentReadPairSameVar(other, read2) and
          other != read1 and
          other != read2
        )
      }

      cached
      predicate emptyValue(Expr e) {
        e.(ArrayCreation).getALengthArgument().getValue().toInt() = 0
        or
        e.(ArrayInitializer).hasNoElements()
        or
        exists(Expr mid | emptyValue(mid) |
          mid = e.(AssignExpr).getRValue()
          or
          mid = e.(Cast).getExpr()
        )
        or
        exists(PreSsa::Definition def | emptyDef(def) | firstReadSameVarUniquePredecesssor(def, e))
        or
        exists(MethodCall mc |
          mc.getTarget().getAnUltimateImplementee().getSourceDeclaration() =
            any(SystemCollectionsGenericICollectionInterface c).getClearMethod() and
          adjacentReadPairSameVarUniquePredecessor(mc.getQualifier(), e)
        )
      }

      cached
      predicate nonEmptyValue(Expr e) {
        forex(Expr length | length = e.(ArrayCreation).getALengthArgument() |
          length.getValue().toInt() != 0
        )
        or
        e.(ArrayInitializer).getNumberOfElements() > 0
        or
        exists(Expr mid | nonEmptyValue(mid) |
          mid = e.(AssignExpr).getRValue()
          or
          mid = e.(Cast).getExpr()
        )
        or
        exists(PreSsa::Definition def | nonEmptyDef(def) |
          firstReadSameVarUniquePredecesssor(def, e)
        )
        or
        exists(MethodCall mc |
          mc.getTarget().getAnUltimateImplementee().getSourceDeclaration() =
            any(SystemCollectionsGenericICollectionInterface c).getAddMethod() and
          adjacentReadPairSameVarUniquePredecessor(mc.getQualifier(), e)
        )
      }
    }

    import CachedWithCFG
  }

  import PreCFG

  /**
   * A helper class for calculating structurally equal access/call expressions.
   */
  private class ConditionOnExprComparisonConfig extends InternalStructuralComparisonConfiguration {
    ConditionOnExprComparisonConfig() { this = "ConditionOnExprComparisonConfig" }

    override predicate candidate(ControlFlowElement x, ControlFlowElement y) {
      exists(BasicBlock bb, Declaration d |
        candidateAux(x, d, bb) and
        y =
          any(AccessOrCallExpr e |
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
    pragma[noinline]
    private predicate candidateAux(AccessOrCallExpr e, Declaration target, BasicBlock bb) {
      target = e.getTarget() and
      exists(Guard g | e = getAChildExprStar(g) | guardControls(g, _, bb, _))
    }
  }

  cached
  private module Cached {
    private import semmle.code.csharp.Caching

    /**
     * Holds if basic block `bb` only is reached when guard `g` has abstract value `v`.
     *
     * `cb` records all of the possible condition blocks for `g` that a path from the
     * callable entry point to `bb` may go through.
     */
    cached
    predicate guardControls(Guard g, ConditionBlock cb, BasicBlock bb, AbstractValue v) {
      exists(AbstractValue v0, Guard g0 |
        impliesSteps(g0, v0, g, v) and
        exists(ControlFlowElement cfe, ConditionalSuccessor cs |
          v0.branch(cfe, cs, g0) and cfe.controlsBlock(bb, cs, cb)
        )
      )
    }

    pragma[noinline]
    private predicate nodeIsGuardedBySameSubExpr0(
      ControlFlow::Node guardedCfn, AccessOrCallExpr guarded, Guard g, ConditionBlock cb,
      AccessOrCallExpr sub, AbstractValue v
    ) {
      Stages::GuardsStage::forceCachingInSameStage() and
      guardedCfn = guarded.getAControlFlowNode() and
      guardControls(g, cb, guardedCfn.getBasicBlock(), v) and
      exists(ConditionOnExprComparisonConfig c | c.same(sub, guarded))
    }

    pragma[noinline]
    private predicate nodeIsGuardedBySameSubExpr(
      ControlFlow::Node guardedCfn, AccessOrCallExpr guarded, Guard g, ConditionBlock cb,
      AccessOrCallExpr sub, AbstractValue v
    ) {
      nodeIsGuardedBySameSubExpr0(guardedCfn, guarded, g, cb, sub, v) and
      sub = getAChildExprStar(g)
    }

    pragma[noinline]
    private predicate nodeIsGuardedBySameSubExprSsaDef(
      ControlFlow::Node cfn, AccessOrCallExpr guarded, Guard g, ControlFlow::Node subCfn,
      AccessOrCallExpr sub, AbstractValue v, Ssa::Definition def
    ) {
      exists(ConditionBlock cb |
        nodeIsGuardedBySameSubExpr(cfn, guarded, g, cb, sub, v) and
        subCfn.getBasicBlock().dominates(cb) and
        def = sub.getAnSsaQualifier(subCfn)
      )
    }

    private predicate adjacentReadPairSameVarUniquePredecessor(
      Ssa::Definition def, ControlFlow::Node cfn1, ControlFlow::Node cfn2
    ) {
      Ssa::Internal::adjacentReadPairSameVar(def, cfn1, cfn2) and
      not exists(ControlFlow::Node other |
        Ssa::Internal::adjacentReadPairSameVar(def, other, cfn2) and
        other != cfn1 and
        other != cfn2
      )
    }

    pragma[noinline]
    private predicate isGuardedByExpr0(
      AccessOrCallExpr guarded, Guard g, AccessOrCallExpr sub, AbstractValue v
    ) {
      forex(ControlFlow::Node cfn | cfn = guarded.getAControlFlowNode() |
        nodeIsGuardedBySameSubExpr(cfn, guarded, g, _, sub, v)
      )
    }

    cached
    predicate isGuardedByExpr(
      AccessOrCallExpr guarded, Guard g, AccessOrCallExpr sub, AbstractValue v
    ) {
      isGuardedByExpr0(guarded, g, sub, v) and
      forall(ControlFlow::Node subCfn, Ssa::Definition def |
        nodeIsGuardedBySameSubExprSsaDef(_, guarded, g, subCfn, sub, v, def)
      |
        exists(ControlFlow::Node guardedCfn |
          def = guarded.getAnSsaQualifier(guardedCfn) and
          if v.isReferentialProperty()
          then adjacentReadPairSameVarUniquePredecessor(def, subCfn, guardedCfn)
          else any()
        )
      )
    }

    cached
    predicate isGuardedByNode(
      ControlFlow::Nodes::ElementNode guarded, Guard g, AccessOrCallExpr sub, AbstractValue v
    ) {
      nodeIsGuardedBySameSubExpr(guarded, _, g, _, sub, v) and
      forall(ControlFlow::Node subCfn, Ssa::Definition def |
        nodeIsGuardedBySameSubExprSsaDef(guarded, _, g, subCfn, sub, v, def)
      |
        def =
          guarded
              .getElement()
              .(AccessOrCallExpr)
              .getAnSsaQualifier(guarded.getBasicBlock().getANode()) and
        if v.isReferentialProperty()
        then adjacentReadPairSameVarUniquePredecessor(def, subCfn, guarded)
        else any()
      )
    }

    private predicate firstReadUniquePredecessor(Ssa::ExplicitDefinition def, ControlFlow::Node cfn) {
      exists(def.getAFirstReadAtNode(cfn)) and
      not exists(ControlFlow::Node other |
        Ssa::Internal::adjacentReadPairSameVar(def, other, cfn) and
        other != cfn
      )
    }

    /**
     * Holds if the assumption that `g1` has abstract value `v1` implies that
     * `g2` has abstract value `v2`, using one step of reasoning. That is, the
     * evaluation of `g2` to `v2` dominates the evaluation of `g1` to `v1`.
     *
     * This predicate relies on the control flow graph.
     */
    cached
    predicate impliesStep(Guard g1, AbstractValue v1, Guard g2, AbstractValue v2) {
      preImpliesStep(g1, v1, g2, v2)
      or
      forex(ControlFlow::Node cfn1 | cfn1 = g1.getAControlFlowNode() |
        exists(Ssa::ExplicitDefinition def | def.getADefinition().getSource() = g2 |
          g1 = def.getAReadAtNode(cfn1) and
          isGuard(g1, v1) and
          v2 = v1 and
          if v1.isReferentialProperty() then firstReadUniquePredecessor(def, cfn1) else any()
        )
      )
    }
  }

  import Cached

  /**
   * Holds if the assumption that `g1` has abstract value `v1` implies that
   * `g2` has abstract value `v2`, using zero or more steps of reasoning. That is,
   * the evaluation of `g2` to `v2` dominates the evaluation of `g1` to `v1`.
   *
   * This predicate does not rely on the control flow graph.
   */
  predicate preImpliesSteps(Guard g1, AbstractValue v1, Guard g2, AbstractValue v2) {
    g1 = g2 and
    v1 = v2 and
    isGuard(g1, v1)
    or
    exists(Expr mid, AbstractValue vMid | preImpliesSteps(g1, v1, mid, vMid) |
      preImpliesStep(mid, vMid, g2, v2)
    )
  }

  /**
   * Holds if the assumption that `g1` has abstract value `v1` implies that
   * `g2` has abstract value `v2`, using zero or more steps of reasoning. That is,
   * the evaluation of `g2` to `v2` dominates the evaluation of `g1` to `v1`.
   *
   * This predicate relies on the control flow graph.
   */
  predicate impliesSteps(Guard g1, AbstractValue v1, Guard g2, AbstractValue v2) {
    g1 = g2 and
    v1 = v2 and
    isGuard(g1, v1)
    or
    exists(Expr mid, AbstractValue vMid | impliesSteps(g1, v1, mid, vMid) |
      impliesStep(mid, vMid, g2, v2)
    )
  }
}

private import Internal
