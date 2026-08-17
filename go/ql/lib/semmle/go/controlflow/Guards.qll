/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 *
 * This is an instantiation of the shared guards library for Go.
 */
overlay[local?]
module;

private import go
private import semmle.go.controlflow.ControlFlowGraphShared
private import semmle.go.dataflow.SSA as GoSsa
private import semmle.go.dataflow.SsaImpl as SsaImpl
private import codeql.controlflow.Guards as SharedGuards
private import codeql.controlflow.SuccessorType

private module GuardsInput implements
  SharedGuards::InputSig<Location, CfgImpl::Cfg::ControlFlowNode, CfgImpl::Cfg::BasicBlock>
{
  private import go as G

  /**
   * A control flow node indicating normal termination of a function or file.
   */
  class NormalExitNode extends CfgImpl::Cfg::ControlFlowNode {
    NormalExitNode() { this instanceof CfgImpl::ControlFlow::NormalExitNode }
  }

  class AstNode = G::AstNode;

  class Expr extends G::Expr {
    /** Gets the associated control flow node. */
    CfgImpl::Cfg::ControlFlowNode getControlFlowNode() { result = IR::evalExprInstruction(this) }

    /** Gets the basic block containing this expression. */
    CfgImpl::Cfg::BasicBlock getBasicBlock() { result = this.getControlFlowNode().getBasicBlock() }
  }

  private newtype TConstantValue = TStringValue(string s) { s = any(G::Expr e).getStringValue() }

  class ConstantValue extends TConstantValue {
    /** Gets a textual representation of this constant value. */
    string toString() { this = TStringValue(result) }
  }

  abstract class ConstantExpr extends Expr {
    predicate isNull() { none() }

    boolean asBooleanValue() { none() }

    int asIntegerValue() { none() }

    ConstantValue asConstantValue() { none() }
  }

  private class NilConstant extends ConstantExpr {
    NilConstant() { exprRefersToNil(this) }

    override predicate isNull() { any() }
  }

  private class BooleanConstant extends ConstantExpr {
    BooleanConstant() { exists(this.getBoolValue()) }

    override boolean asBooleanValue() { result = this.getBoolValue() }
  }

  private class IntegerConstant extends ConstantExpr {
    IntegerConstant() { exists(this.getIntValue()) }

    override int asIntegerValue() { result = this.getIntValue() }
  }

  private class StringConstant extends ConstantExpr {
    StringConstant() { exists(this.getStringValue()) }

    override ConstantValue asConstantValue() { result = TStringValue(this.getStringValue()) }
  }

  /**
   * An expression that is known not to be `nil`.
   */
  class NonNullExpr extends Expr {
    NonNullExpr() {
      this instanceof G::CompositeLit
      or
      this instanceof G::FuncLit
      or
      this instanceof G::AddressExpr
    }
  }

  /**
   * A case expression in a tagless `switch` statement.
   */
  class Case extends Expr {
    Case() {
      this =
        any(G::ExpressionSwitchStmt switch | not exists(switch.getExpr())).getACase().getAnExpr()
    }

    Expr getSwitchExpr() { result = this }

    predicate isDefaultCase() { none() }

    ConstantExpr asConstantCase() { none() }

    predicate matchEdge(CfgImpl::Cfg::BasicBlock bb1, CfgImpl::Cfg::BasicBlock bb2) {
      bb1.getLastNode() = this.getControlFlowNode() and
      bb1.getASuccessor(any(MatchingSuccessor successor | successor.getValue() = true)) = bb2
    }

    predicate nonMatchEdge(CfgImpl::Cfg::BasicBlock bb1, CfgImpl::Cfg::BasicBlock bb2) {
      bb1.getLastNode() = this.getControlFlowNode() and
      bb1.getASuccessor(any(MatchingSuccessor successor | successor.getValue() = false)) = bb2
    }
  }

  class AndExpr extends Expr instanceof G::LandExpr {
    /** Gets an operand of this expression. */
    Expr getAnOperand() { result = super.getAnOperand() }
  }

  class OrExpr extends Expr instanceof G::LorExpr {
    /** Gets an operand of this expression. */
    Expr getAnOperand() { result = super.getAnOperand() }
  }

  class NotExpr extends Expr instanceof G::NotExpr {
    /** Gets the operand of this expression. */
    Expr getOperand() { result = super.getOperand() }
  }

  private predicate sameNumericTypeFamily(G::NumericType source, G::NumericType target) {
    source instanceof G::SignedIntegerType and target instanceof G::SignedIntegerType
    or
    source instanceof G::UnsignedIntegerType and target instanceof G::UnsignedIntegerType
    or
    source instanceof G::FloatType and target instanceof G::FloatType
    or
    source instanceof G::ComplexType and target instanceof G::ComplexType
  }

  private predicate isUpcast(G::ConversionExpr conversion) {
    conversion.getOperand().getType().getUnderlyingType() = conversion.getType().getUnderlyingType()
    or
    exists(G::NumericType source, G::NumericType target |
      source = conversion.getOperand().getType().getUnderlyingType() and
      target = conversion.getType().getUnderlyingType() and
      sameNumericTypeFamily(source, target) and
      source.getSize() <= target.getSize()
    )
  }

  /**
   * An expression that has the same value as a specific sub-expression, that
   * is, a parenthesized expression or an upcast.
   */
  class IdExpr extends Expr {
    IdExpr() { this instanceof G::ParenExpr or isUpcast(this) }

    Expr getEqualChildExpr() {
      result = this.(G::ParenExpr).getExpr()
      or
      result = this.(G::ConversionExpr).getOperand()
    }
  }

  /**
   * Holds if `eqtest` is an equality or inequality test between `left` and
   * `right`. The `polarity` indicates whether this is an equality test (true)
   * or inequality test (false).
   */
  pragma[nomagic]
  predicate equalityTest(Expr eqtest, Expr left, Expr right, boolean polarity) {
    exists(G::EqualityTestExpr eq | eq = eqtest |
      left = eq.getLeftOperand() and
      right = eq.getRightOperand() and
      polarity = eq.getPolarity()
    )
  }

  /**
   * A conditional expression. Go has no such expression, so this class is
   * empty.
   */
  class ConditionalExpr extends Expr {
    ConditionalExpr() { none() }

    /** Gets the condition of this expression. */
    Expr getCondition() { none() }

    /** Gets the true branch of this expression. */
    Expr getThen() { none() }

    /** Gets the false branch of this expression. */
    Expr getElse() { none() }
  }

  class Parameter = G::Parameter;

  private int parameterPosition() { result = any(Parameter p).getIndex() }

  /** A parameter position represented by an integer. */
  class ParameterPosition extends int {
    ParameterPosition() { this = parameterPosition() }
  }

  /** An argument position represented by an integer. */
  class ArgumentPosition extends int {
    ArgumentPosition() { this = parameterPosition() }
  }

  /** Holds if arguments at position `apos` match parameters at position `ppos`. */
  pragma[inline]
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

  final private class FinalFunction = G::Function;

  /**
   * A function whose calls always dispatch to that same function.
   *
   * Methods are excluded, since a call to a method may dispatch to a different
   * implementation via an interface.
   */
  class NonOverridableMethod extends FinalFunction {
    NonOverridableMethod() {
      not this instanceof G::Method and
      exists(super.getFuncDecl()) and
      super.getNumResult() = 1
    }

    Parameter getParameter(ParameterPosition ppos) { result = super.getParameter(ppos) }

    /** Gets an expression being returned by this function. */
    Expr getAReturnExpr() {
      exists(G::ReturnStmt ret |
        ret.getEnclosingFunction() = super.getFuncDecl() and
        result = ret.getExpr()
      )
    }
  }

  private predicate nonOverridableCall(G::CallExpr call, NonOverridableMethod m) {
    call = m.getACall().asExpr()
  }

  class NonOverridableMethodCall extends Expr instanceof G::CallExpr {
    NonOverridableMethodCall() { nonOverridableCall(this, _) }

    NonOverridableMethod getMethod() { nonOverridableCall(this, result) }

    Expr getArgument(ArgumentPosition apos) { result = super.getArgument(apos) }
  }
}

private module GuardsImpl = SharedGuards::Make<Location, CfgImpl::Cfg, GuardsInput>;

private module LogicInput implements GuardsImpl::LogicInputSig {
  final private class FinalSsaDefinition = GoSsa::SsaDefinition;

  class SsaDefinition extends FinalSsaDefinition {
    GuardsInput::Expr getARead() {
      result = super.getVariable().getAUse().(IR::EvalInstruction).getExpr()
    }
  }

  class SsaExplicitWrite extends SsaDefinition instanceof GoSsa::SsaExplicitDefinition {
    GuardsInput::Expr getValue() { result = super.getRhs().(IR::EvalInstruction).getExpr() }
  }

  class SsaPhiDefinition extends SsaDefinition instanceof GoSsa::SsaPhiNode {
    /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
    predicate hasInputFromBlock(SsaDefinition inp, BasicBlock bb) {
      SsaImpl::phiHasInputFromBlock(this, inp, bb)
    }
  }

  class SsaParameterInit extends SsaDefinition {
    SsaParameterInit() {
      this.(GoSsa::SsaExplicitDefinition).getInstruction() instanceof IR::InitParameterInstruction
    }

    GuardsInput::Parameter getParameter() {
      this.(GoSsa::SsaExplicitDefinition).getInstruction() = IR::initParamInstruction(result)
    }
  }

  /**
   * Holds if `rel` evaluating to `branch` ensures that `lesser` is less than
   * `greater`, strictly if `strict` is true.
   */
  private predicate comparison(
    RelationalComparisonExpr rel, boolean branch, GuardsInput::Expr lesser,
    GuardsInput::Expr greater, boolean strict
  ) {
    branch = true and
    lesser = rel.getLesserOperand() and
    greater = rel.getGreaterOperand() and
    (if rel.isStrict() then strict = true else strict = false)
    or
    branch = false and
    lesser = rel.getGreaterOperand() and
    greater = rel.getLesserOperand() and
    (if rel.isStrict() then strict = false else strict = true)
  }

  /**
   * Holds if `guard` evaluating to `val` ensures that:
   * `e <= k` when `upper = true`
   * `e >= k` when `upper = false`
   */
  predicate rangeGuard(
    GuardsImpl::PreGuard guard, GuardValue val, GuardsInput::Expr e, int k, boolean upper
  ) {
    exists(
      RelationalComparisonExpr rel, boolean branch, GuardsInput::Expr lesser,
      GuardsInput::Expr greater, boolean strict, int strictnessAdjustment
    |
      guard = rel and
      val.asBooleanValue() = branch and
      comparison(rel, branch, lesser, greater, strict) and
      (if strict = true then strictnessAdjustment = 1 else strictnessAdjustment = 0)
    |
      // `e < k` or `e <= k`
      e = lesser and
      upper = true and
      k = greater.getIntValue() - strictnessAdjustment
      or
      // `k < e` or `k <= e`
      e = greater and
      upper = false and
      k = lesser.getIntValue() + strictnessAdjustment
    )
  }
}

/** An abstract value that a `Guard` may evaluate to. */
class GuardValue = GuardsImpl::GuardValue;

private module GuardsLogic = GuardsImpl::Logic<LogicInput>;

/**
 * A guard. This is an expression whose value determines subsequent control
 * flow.
 */
final class Guard extends GuardsLogic::Guard {
  /** Gets the innermost function or file to which this guard belongs. */
  ControlFlow::Root getRoot() { result.isRootOf(this) }
}

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 */
module ValidationWrapper<GuardsLogic::guardChecksSig/3 guardChecks> {
  import GuardsLogic::ValidationWrapper<guardChecks/3>
}

/**
 * Holds if `bb` can only be reached when the expression `e` evaluates to `b`.
 *
 * This is the replacement for the old
 * `ConditionGuardNode.ensures(e, b) and ConditionGuardNode.dominates(bb)`
 * idiom.
 */
pragma[inline]
predicate guardEnsures(Expr e, boolean b, BasicBlock bb) { e.(Guard).controls(bb, b) }

/** Holds if `guard` evaluating to `branch` ensures that `i = j` holds. */
predicate guardEnsuresEq(Guard guard, boolean branch, DataFlow::Node i, DataFlow::Node j) {
  guard.isEquality(i.asExpr(), j.asExpr(), branch)
}

/** Holds if `guard` evaluating to `branch` ensures that `i != j` holds. */
predicate guardEnsuresNeq(Guard guard, boolean branch, DataFlow::Node i, DataFlow::Node j) {
  exists(boolean eqval |
    guard.isEquality(i.asExpr(), j.asExpr(), eqval) and
    branch = eqval.booleanNot()
  )
}

/**
 * Holds if `guard` evaluating to `branch` ensures that `lesser <= greater + bias`
 * holds.
 */
predicate guardEnsuresLeq(
  Guard guard, boolean branch, DataFlow::Node lesser, DataFlow::Node greater, int bias
) {
  exists(DataFlow::RelationalComparisonNode rel |
    guard = rel.asExpr() and
    rel.leq(branch, lesser, greater, bias)
  )
  or
  guardEnsuresEq(guard, branch, lesser, greater) and bias = 0
}
