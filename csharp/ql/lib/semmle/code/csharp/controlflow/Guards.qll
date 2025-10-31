/**
 * Provides classes for working with guarded expressions.
 */

import csharp
private import ControlFlow
private import semmle.code.csharp.commons.Assertions
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.commons.StructuralComparison as SC
private import semmle.code.csharp.controlflow.BasicBlocks
private import semmle.code.csharp.controlflow.internal.Completion
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Linq
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic
private import codeql.controlflow.Guards as SharedGuards

private module GuardsInput implements
  SharedGuards::InputSig<Location, ControlFlow::Node, ControlFlow::BasicBlock>
{
  private import csharp as CS

  class NormalExitNode = ControlFlow::Nodes::NormalExitNode;

  class AstNode = ControlFlowElement;

  class Expr = CS::Expr;

  private newtype TConstantValue =
    TStringValue(string value) { any(StringLiteral s).getValue() = value }

  class ConstantValue extends TConstantValue {
    string toString() { this = TStringValue(result) }
  }

  abstract class ConstantExpr extends Expr {
    predicate isNull() { none() }

    boolean asBooleanValue() { none() }

    int asIntegerValue() { none() }

    ConstantValue asConstantValue() { none() }
  }

  private class NullConstant extends ConstantExpr {
    NullConstant() { nullValueImplied(this) }

    override predicate isNull() { any() }
  }

  private class BooleanConstant extends ConstantExpr instanceof BoolLiteral {
    override boolean asBooleanValue() { result = super.getBoolValue() }
  }

  private predicate intConst(Expr e, int i) {
    e.getValue().toInt() = i and
    (
      e.getType() instanceof Enum
      or
      e.getType() instanceof IntegralType
    )
  }

  private class IntegerConstant extends ConstantExpr {
    IntegerConstant() { intConst(this, _) }

    override int asIntegerValue() { intConst(this, result) }
  }

  private class EnumConst extends ConstantExpr {
    EnumConst() { this.getType() instanceof Enum and this.hasValue() }

    override int asIntegerValue() { result = this.getValue().toInt() }
  }

  private class StringConstant extends ConstantExpr instanceof StringLiteral {
    override ConstantValue asConstantValue() { result = TStringValue(this.getValue()) }
  }

  class NonNullExpr extends Expr {
    NonNullExpr() { nonNullValueImplied(this) }
  }

  class Case extends AstNode instanceof CS::Case {
    Expr getSwitchExpr() { super.getExpr() = result }

    predicate isDefaultCase() { this instanceof DefaultCase }

    ConstantExpr asConstantCase() { super.getPattern() = result }

    private predicate hasEdge(BasicBlock bb1, BasicBlock bb2, MatchingCompletion c) {
      exists(PatternExpr pe |
        super.getPattern() = pe and
        c.isValidFor(pe) and
        bb1.getLastNode() = pe.getAControlFlowNode() and
        bb1.getASuccessor(c.getAMatchingSuccessorType()) = bb2
      )
    }

    predicate matchEdge(BasicBlock bb1, BasicBlock bb2) {
      exists(MatchingCompletion c | this.hasEdge(bb1, bb2, c) and c.isMatch())
    }

    predicate nonMatchEdge(BasicBlock bb1, BasicBlock bb2) {
      exists(MatchingCompletion c | this.hasEdge(bb1, bb2, c) and c.isNonMatch())
    }
  }

  abstract private class BinExpr extends BinaryOperation { }

  class AndExpr extends BinExpr {
    AndExpr() {
      this instanceof LogicalAndExpr or
      this instanceof BitwiseAndExpr
    }
  }

  class OrExpr extends BinExpr {
    OrExpr() {
      this instanceof LogicalOrExpr or
      this instanceof BitwiseOrExpr
    }
  }

  class NotExpr = LogicalNotExpr;

  class IdExpr extends Expr {
    IdExpr() { this instanceof AssignExpr or this instanceof CastExpr }

    Expr getEqualChildExpr() {
      result = this.(AssignExpr).getRValue()
      or
      result = this.(CastExpr).getExpr()
    }
  }

  predicate equalityTest(Expr eqtest, Expr left, Expr right, boolean polarity) {
    exists(ComparisonTest ct |
      ct.getExpr() = eqtest and
      ct.getFirstArgument() = left and
      ct.getSecondArgument() = right
    |
      ct.getComparisonKind().isEquality() and polarity = true
      or
      ct.getComparisonKind().isInequality() and polarity = false
    )
    or
    exists(IsExpr ie, PatternExpr pat |
      ie = eqtest and
      ie.getExpr() = left and
      ie.getPattern() = pat
    |
      right = pat.(ConstantPatternExpr) and
      polarity = true
      or
      right = pat.(NotPatternExpr).getPattern().(ConstantPatternExpr) and
      polarity = false
    )
  }

  class ConditionalExpr = CS::ConditionalExpr;

  class Parameter = CS::Parameter;

  private int parameterPosition() { result in [-1, any(Parameter p).getPosition()] }

  class ParameterPosition extends int {
    ParameterPosition() { this = parameterPosition() }
  }

  class ArgumentPosition extends int {
    ArgumentPosition() { this = parameterPosition() }
  }

  pragma[inline]
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

  final private class FinalCallable = Callable;

  class NonOverridableMethod extends FinalCallable {
    NonOverridableMethod() { not this.(Overridable).isOverridableOrImplementable() }

    Parameter getParameter(ParameterPosition ppos) {
      super.getParameter(ppos) = result and
      not result.isParams()
    }

    Expr getAReturnExpr() { this.canReturn(result) }
  }

  class NonOverridableMethodCall extends Expr instanceof Call {
    NonOverridableMethod getMethod() { super.getTarget().getUnboundDeclaration() = result }

    Expr getArgument(ArgumentPosition apos) {
      result = super.getArgumentForParameter(any(Parameter p | p.getPosition() = apos))
    }
  }
}

private module GuardsImpl = SharedGuards::Make<Location, Cfg, GuardsInput>;

class GuardValue = GuardsImpl::GuardValue;

private module LogicInput implements GuardsImpl::LogicInputSig {
  class SsaDefinition extends Ssa::Definition {
    Expr getARead() { super.getARead() = result }
  }

  class SsaExplicitWrite extends SsaDefinition instanceof Ssa::ExplicitDefinition {
    Expr getValue() { result = super.getADefinition().getSource() }
  }

  class SsaPhiDefinition extends SsaDefinition instanceof Ssa::PhiNode {
    predicate hasInputFromBlock(SsaDefinition inp, BasicBlock bb) {
      super.hasInputFromBlock(inp, bb)
    }
  }

  class SsaParameterInit extends SsaDefinition instanceof Ssa::ImplicitParameterDefinition {
    Parameter getParameter() { result = super.getParameter() }
  }

  predicate additionalNullCheck(GuardsImpl::PreGuard guard, GuardValue val, Expr e, boolean isNull) {
    // Comparison with a non-`null` value, for example `x?.Length > 0`
    exists(ComparisonTest ct, ComparisonKind ck, Expr arg | ct.getExpr() = guard |
      e instanceof DereferenceableExpr and
      ct.getAnArgument() = e and
      ct.getAnArgument() = arg and
      nonNullValueImplied(arg) and
      ck = ct.getComparisonKind() and
      e != arg and
      isNull = false and
      not ck.isEquality() and
      not ck.isInequality() and
      val.asBooleanValue() = true
    )
    or
    // Call to `string.IsNullOrEmpty()` or `string.IsNullOrWhiteSpace()`
    exists(MethodCall mc, string name | guard = mc |
      mc.getTarget() = any(SystemStringClass c).getAMethod(name) and
      name.regexpMatch("IsNullOr(Empty|WhiteSpace)") and
      mc.getArgument(0) = e and
      val.asBooleanValue() = false and
      isNull = false
    )
    or
    guard =
      any(PatternMatch pm |
        e instanceof DereferenceableExpr and
        e = pm.getExpr() and
        (
          val.asBooleanValue().booleanNot() = patternMatchesNull(pm.getPattern()) and
          isNull = false
          or
          exists(TypePatternExpr tpe |
            // E.g. `x is string` where `x` has type `string`
            typePattern(guard, tpe, tpe.getCheckedType()) and
            val.asBooleanValue() = false and
            isNull = true
          )
        )
      )
    or
    e.(DereferenceableExpr).hasNullableType() and
    guard =
      any(PropertyAccess pa |
        pa.getQualifier() = e and
        pa.getTarget().hasName("HasValue") and
        val.asBooleanValue().booleanNot() = isNull
      )
  }

  predicate additionalImpliesStep(
    GuardsImpl::PreGuard g1, GuardValue v1, GuardsImpl::PreGuard g2, GuardValue v2
  ) {
    g1 instanceof DereferenceableExpr and
    g1 = getNullEquivParent(g2) and
    v1.isNullness(_) and
    v2 = v1
    or
    g1 instanceof DereferenceableExpr and
    g2 = getANullImplyingChild(g1) and
    v1.isNonNullValue() and
    v2 = v1
    or
    g2 = g1.(NullCoalescingExpr).getAnOperand() and
    v1.isNullValue() and
    v2 = v1
    or
    exists(Assertion assert, AssertMethod target, int i |
      assert.getAssertMethod() = target and
      g1 = assert and
      v1.getDualValue().isThrowsException() and
      g2 = assert.getExpr(i)
    |
      target.(BooleanAssertMethod).getAnAssertionIndex(v2.asBooleanValue()) = i
      or
      target.(NullnessAssertMethod).getAnAssertionIndex(any(boolean isNull | v2.isNullness(isNull))) =
        i
    )
  }
}

module Guards = GuardsImpl::Logic<LogicInput>;

/** An expression whose value may control the execution of another element. */
class Guard extends Guards::Guard {
  /**
   * Holds if `cfn` is guarded by this expression having value `v`, where `sub` is
   * a sub expression of this expression that is structurally equal to the expression
   * belonging to `cfn`.
   *
   * In case `cfn` or `sub` access an SSA variable in their left-most qualifier, then
   * so must the other (accessing the same SSA variable).
   */
  predicate controlsNode(ControlFlow::Nodes::ElementNode cfn, AccessOrCallExpr sub, GuardValue v) {
    isGuardedByNode(cfn, this, sub, v)
  }

  /**
   * Holds if `cfn` is guarded by this expression having value `v`.
   *
   * Note: This predicate is inlined.
   */
  pragma[inline]
  predicate controlsNode(ControlFlow::Nodes::ElementNode cfn, GuardValue v) {
    guardControls(this, cfn.getBasicBlock(), v)
  }

  /**
   * Holds if basic block `bb` is guarded by this expression having value `v`.
   */
  predicate controlsBasicBlock(BasicBlock bb, GuardValue v) { guardControls(this, bb, v) }

  /**
   * Gets a valid value for this guard. For example, if this guard is a test, then
   * it can have Boolean values `true` and `false`.
   */
  deprecated GuardValue getAValue() { isGuard(this, result) }
}

/** DEPRECATED: Use `GuardValue` instead. */
deprecated class AbstractValue = GuardValue;

/**
 * DEPRECATED: Use `GuardValue` member predicates instead.
 *
 * Provides different types of `AbstractValues`s.
 */
deprecated module AbstractValues {
  class BooleanValue extends AbstractValue {
    BooleanValue() { exists(this.asBooleanValue()) }

    boolean getValue() { this.asBooleanValue() = result }
  }

  class IntegerValue extends AbstractValue {
    IntegerValue() { exists(this.asIntValue()) }

    int getValue() { this.asIntValue() = result }
  }

  class NullValue extends AbstractValue {
    NullValue() { this.isNullness(_) }

    predicate isNull() { this.isNullValue() }

    predicate isNonNull() { this.isNonNullValue() }

    DereferenceableExpr getAnExpr() {
      if this.isNull() then nullValueImplied(result) else nonNullValueImplied(result)
    }
  }
}

/** Gets the value resulting from matching `null` against `pat`. */
private boolean patternMatchesNull(PatternExpr pat) {
  pat instanceof NullLiteral and result = true
  or
  not pat instanceof NullLiteral and
  not pat instanceof NotPatternExpr and
  not pat instanceof OrPatternExpr and
  not pat instanceof AndPatternExpr and
  result = false
  or
  result = patternMatchesNull(pat.(NotPatternExpr).getPattern()).booleanNot()
  or
  exists(OrPatternExpr ope | pat = ope |
    result =
      patternMatchesNull(ope.getLeftOperand()).booleanOr(patternMatchesNull(ope.getRightOperand()))
  )
  or
  exists(AndPatternExpr ape | pat = ape |
    result =
      patternMatchesNull(ape.getLeftOperand()).booleanAnd(patternMatchesNull(ape.getRightOperand()))
  )
}

pragma[nomagic]
private predicate typePattern(PatternMatch pm, TypePatternExpr tpe, Type t) {
  tpe = pm.getPattern() and
  t = pm.getExpr().getType()
}

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

  /** Holds if `guard` suggests that this expression may be `null`. */
  predicate guardSuggestsMaybeNull(Guards::Guard guard) {
    not nonNullValueImplied(this) and
    (
      exists(NullnessCompletion c | c.isValidFor(this) and c.isNull() and guard = this)
      or
      LogicInput::additionalNullCheck(guard, _, this, true)
      or
      guard.isEquality(this, any(Expr n | nullValueImplied(n)), _)
      or
      Guards::nullGuard(guard, any(GuardValue v | exists(v.asBooleanValue())), this, true)
    )
  }
}

/**
 * DEPRECATED: Use `EnumerableCollectionExpr` instead.
 */
deprecated class CollectionExpr = EnumerableCollectionExpr;

/**
 * An expression that evaluates to a collection. That is, an expression whose
 * (transitive, reflexive) base type is `IEnumerable`.
 */
class EnumerableCollectionExpr extends Expr {
  EnumerableCollectionExpr() {
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
        pr.getTarget()
            .overridesOrImplementsOrEquals(any(Property p |
                p.getUnboundDeclaration() =
                  any(SystemCollectionsGenericICollectionInterface x).getCountProperty()
              ))
      )
    or
    result =
      any(MethodCall mc |
        mc.getTarget().getUnboundDeclaration() =
          any(SystemLinq::SystemLinqEnumerableClass x).getACountMethod() and
        this = mc.getArgument(0) and
        if mc.getNumberOfArguments() = 1 then lowerBound = false else lowerBound = true
      )
  }

  private Expr getABooleanEmptinessCheck(GuardValue v, boolean isEmpty) {
    exists(boolean branch | branch = v.asBooleanValue() |
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
          mc.getTarget().getUnboundDeclaration() =
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
  Expr getAnEmptinessCheck(GuardValue v, boolean isEmpty) {
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
  result = def.getAReadAtNode(cfn)
  or
  result = def.(Ssa::ExplicitDefinition).getADefinition().getTargetAccess() and
  cfn = def.getControlFlowNode()
}

private predicate ssaMustHaveValue(Expr e, GuardValue v) {
  exists(Ssa::Definition def, BasicBlock bb |
    e = def.getARead() and
    e.getBasicBlock() = bb and
    Guards::ssaControls(def, bb, v)
  )
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
  GuardedExpr() { isGuardedByExpr(this, _, _, _) or ssaMustHaveValue(this, _) }

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
  Guard getAGuard(Expr sub, GuardValue v) { isGuardedByExpr(this, result, sub, v) }

  /**
   * Holds if this expression must have abstract value `v`. That is, this
   * expression is guarded by a structurally equal expression having abstract
   * value `v`.
   */
  predicate mustHaveValue(GuardValue v) {
    exists(Guard g | g = this.getAGuard(g, v)) or ssaMustHaveValue(this, v)
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
    cond = this.getAGuard(sub, any(GuardValue v | v.asBooleanValue() = b))
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
  private GuardValue v0;

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
  Guard getAGuard(Expr sub, GuardValue v) {
    result = g and
    sub = sub0 and
    v = v0
  }

  /**
   * Holds if this control flow node must have abstract value `v`. That is, this
   * control flow node is guarded by a structurally equal expression having
   * abstract value `v`.
   */
  predicate mustHaveValue(GuardValue v) { g = this.getAGuard(g, v) }
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
  private GuardValue v0;

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
  Guard getAGuard(Expr sub, GuardValue v) {
    result = g and
    sub = sub0 and
    v = v0
  }

  /**
   * Holds if this data flow node must have abstract value `v`. That is, this
   * data flow node is guarded by a structurally equal expression having
   * abstract value `v`.
   */
  predicate mustHaveValue(GuardValue v) { g = this.getAGuard(g, v) }
}

/** An expression guarded by a `null` check. */
class NullGuardedExpr extends GuardedExpr {
  NullGuardedExpr() { this.mustHaveValue(any(GuardValue v | v.isNonNullValue())) }
}

/** A data flow node guarded by a `null` check. */
class NullGuardedDataFlowNode extends GuardedDataFlowNode {
  NullGuardedDataFlowNode() { this.mustHaveValue(any(GuardValue v | v.isNonNullValue())) }
}

/** INTERNAL: Do not use. */
module Internal {
  /** Holds if expression `e` is a `null` value. */
  predicate nullValue(Expr e) {
    e instanceof NullLiteral
    or
    e instanceof DefaultValueExpr and e.getType().isRefType()
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
    NonNullCallable() { this = any(SystemObjectClass c).getGetTypeMethod() }
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
    e.(Call).getTarget().getUnboundDeclaration() instanceof NonNullCallable and
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
      nonNullValueImplied(o) and
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

  // The predicates in this module should be evaluated in the same stage as the CFG
  // construction stage. This is to avoid recomputation of pre-basic-blocks and
  // pre-SSA predicates
  private module PreCfg {
    private import semmle.code.csharp.controlflow.internal.PreBasicBlocks as PreBasicBlocks
    private import semmle.code.csharp.controlflow.internal.PreSsa

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

    deprecated predicate isGuard(Expr e, GuardValue val) {
      (
        e.getType() instanceof BoolType and
        not e instanceof BoolLiteral and
        not e instanceof SwitchCaseExpr and
        not e instanceof PatternExpr and
        exists(val.asBooleanValue())
        or
        e instanceof DereferenceableExpr and
        val.isNullness(_)
      ) and
      not e = any(ExprStmt es).getExpr() and
      not e = any(LocalVariableDeclStmt s).getAVariableDeclExpr()
    }

    cached
    private module CachedWithCfg {
      private import semmle.code.csharp.Caching

      private predicate firstReadSameVarUniquePredecessor(
        PreSsa::Definition def, AssignableRead read
      ) {
        read = def.getAFirstRead() and
        (
          not PreSsa::adjacentReadPairSameVar(_, read)
          or
          read = unique(AssignableRead read0 | PreSsa::adjacentReadPairSameVar(read0, read))
        )
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
        (
          read1 = read2 and
          read1 = unique(AssignableRead other | PreSsa::adjacentReadPairSameVar(other, read2))
          or
          read1 =
            unique(AssignableRead other |
              PreSsa::adjacentReadPairSameVar(other, read2) and other != read2
            )
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
        exists(PreSsa::Definition def | emptyDef(def) | firstReadSameVarUniquePredecessor(def, e))
        or
        exists(MethodCall mc |
          mc.getTarget().getAnUltimateImplementee().getUnboundDeclaration() =
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
          firstReadSameVarUniquePredecessor(def, e)
        )
        or
        exists(MethodCall mc |
          mc.getTarget().getAnUltimateImplementee().getUnboundDeclaration() =
            any(SystemCollectionsGenericICollectionInterface c).getAddMethod() and
          adjacentReadPairSameVarUniquePredecessor(mc.getQualifier(), e)
        )
      }
    }

    import CachedWithCfg
  }

  import PreCfg

  private predicate interestingDescendantCandidate(Expr e) {
    guardControls(e, _, _)
    or
    e instanceof AccessOrCallExpr
  }

  /**
   * An (interesting) descendant of a guard that controls some basic block.
   *
   * This class exists purely for performance reasons: It allows us to big-step
   * through the child hierarchy in `guardControlsSub()` instead of using
   * `getAChildExpr()`.
   */
  private class ControlGuardDescendant extends Expr {
    ControlGuardDescendant() {
      guardControls(this, _, _)
      or
      any(ControlGuardDescendant other).interestingDescendant(this)
    }

    private predicate descendant(Expr e) {
      e = this.getAChildExpr()
      or
      exists(Expr mid |
        this.descendant(mid) and
        not interestingDescendantCandidate(mid) and
        e = mid.getAChildExpr()
      )
    }

    /** Holds if `e` is an interesting descendant of this descendant. */
    predicate interestingDescendant(Expr e) {
      this.descendant(e) and
      interestingDescendantCandidate(e)
    }
  }

  /**
   * Holds if `g` controls basic block `bb`, and `sub` is some (interesting)
   * sub expression of `g`.
   *
   * Sub expressions inside nested logical operations that themselve control `bb`
   * are not included, since these will be sub expressions of their immediately
   * enclosing logical operation. (This restriction avoids a quadratic blow-up.)
   *
   * For example, in
   *
   * ```csharp
   * if (a && (b && c))
   *     BLOCK
   * ```
   *
   * `a` is included as a sub expression of `a && (b && c)` (which controls `BLOCK`),
   * while `b` and `c` are only included as sub expressions of `b && c` (which also
   * controls `BLOCK`).
   */
  pragma[nomagic]
  private predicate guardControlsSub(Guard g, BasicBlock bb, ControlGuardDescendant sub) {
    guardControls(g, bb, _) and
    sub = g
    or
    exists(ControlGuardDescendant mid |
      guardControlsSub(g, bb, mid) and
      mid.interestingDescendant(sub)
    |
      not guardControls(sub, bb, _)
      or
      not mid instanceof UnaryLogicalOperation and
      not mid instanceof BinaryLogicalOperation and
      not mid instanceof BitwiseOperation
    )
  }

  /**
   * Holds if access/call expression `e` (targeting declaration `target`)
   * is a sub expression of a guard that controls whether basic block
   * `bb` is reached.
   */
  pragma[noinline]
  private predicate candidateAux(AccessOrCallExpr e, Declaration target, BasicBlock bb) {
    target = e.getTarget() and
    guardControlsSub(_, bb, e)
  }

  private predicate candidate(AccessOrCallExpr x, AccessOrCallExpr y) {
    exists(BasicBlock bb, Declaration d |
      candidateAux(x, d, bb) and
      y =
        any(AccessOrCallExpr e |
          e.getAControlFlowNode().getBasicBlock() = bb and
          e.getTarget() = d
        )
    )
  }

  private predicate same(AccessOrCallExpr x, AccessOrCallExpr y) {
    candidate(x, y) and
    SC::sameGvn(x, y)
  }

  cached
  private module Cached {
    private import semmle.code.csharp.Caching
    private import semmle.code.csharp.dataflow.internal.SsaImpl as SsaImpl

    /**
     * Holds if basic block `bb` only is reached when guard `g` has abstract value `v`.
     */
    cached
    predicate guardControls(Guard g, BasicBlock bb, GuardValue v) {
      g.(Guards::Guard).valueControls(bb, v)
    }

    pragma[nomagic]
    private predicate guardControlsSubSame(Guard g, BasicBlock bb, ControlGuardDescendant sub) {
      guardControlsSub(g, bb, sub) and
      same(sub, _)
    }

    pragma[nomagic]
    private predicate nodeIsGuardedBySameSubExpr0(
      ControlFlow::Node guardedCfn, BasicBlock guardedBB, AccessOrCallExpr guarded, Guard g,
      AccessOrCallExpr sub, GuardValue v
    ) {
      Stages::GuardsStage::forceCachingInSameStage() and
      guardedCfn = guarded.getAControlFlowNode() and
      guardedBB = guardedCfn.getBasicBlock() and
      guardControls(g, guardedBB, v) and
      guardControlsSubSame(g, guardedBB, sub) and
      same(sub, guarded)
    }

    pragma[nomagic]
    private predicate nodeIsGuardedBySameSubExpr(
      ControlFlow::Node guardedCfn, BasicBlock guardedBB, AccessOrCallExpr guarded, Guard g,
      AccessOrCallExpr sub, GuardValue v
    ) {
      nodeIsGuardedBySameSubExpr0(guardedCfn, guardedBB, guarded, g, sub, v) and
      guardControlsSub(g, guardedBB, sub)
    }

    pragma[nomagic]
    private predicate nodeIsGuardedBySameSubExprSsaDef0(
      ControlFlow::Node cfn, BasicBlock guardedBB, AccessOrCallExpr guarded, Guard g,
      ControlFlow::Node subCfn, BasicBlock subCfnBB, AccessOrCallExpr sub, GuardValue v,
      Ssa::Definition def
    ) {
      nodeIsGuardedBySameSubExpr(cfn, guardedBB, guarded, g, sub, v) and
      def = sub.getAnSsaQualifier(subCfn) and
      subCfnBB = subCfn.getBasicBlock()
    }

    pragma[nomagic]
    private predicate nodeIsGuardedBySameSubExprSsaDef(
      ControlFlow::Node guardedCfn, AccessOrCallExpr guarded, Guard g, ControlFlow::Node subCfn,
      AccessOrCallExpr sub, GuardValue v, Ssa::Definition def
    ) {
      exists(BasicBlock guardedBB, BasicBlock subCfnBB |
        nodeIsGuardedBySameSubExprSsaDef0(guardedCfn, guardedBB, guarded, g, subCfn, subCfnBB, sub,
          v, def) and
        subCfnBB.getASuccessor*() = guardedBB
      )
    }

    pragma[noinline]
    private predicate isGuardedByExpr0(
      AccessOrCallExpr guarded, Guard g, AccessOrCallExpr sub, GuardValue v
    ) {
      forex(ControlFlow::Node cfn | cfn = guarded.getAControlFlowNode() |
        nodeIsGuardedBySameSubExpr(cfn, _, guarded, g, sub, v)
      )
    }

    cached
    predicate isGuardedByExpr(AccessOrCallExpr guarded, Guard g, AccessOrCallExpr sub, GuardValue v) {
      isGuardedByExpr0(guarded, g, sub, v) and
      forall(ControlFlow::Node subCfn, Ssa::Definition def |
        nodeIsGuardedBySameSubExprSsaDef(_, guarded, g, subCfn, sub, v, def)
      |
        def = guarded.getAnSsaQualifier(_)
      )
    }

    cached
    predicate isGuardedByNode(
      ControlFlow::Nodes::ElementNode guarded, Guard g, AccessOrCallExpr sub, GuardValue v
    ) {
      nodeIsGuardedBySameSubExpr(guarded, _, _, g, sub, v) and
      forall(ControlFlow::Node subCfn, Ssa::Definition def |
        nodeIsGuardedBySameSubExprSsaDef(guarded, _, g, subCfn, sub, v, def)
      |
        def =
          guarded
              .getAstNode()
              .(AccessOrCallExpr)
              .getAnSsaQualifier(guarded.getBasicBlock().getANode())
      )
    }
  }

  import Cached
}

private import Internal
