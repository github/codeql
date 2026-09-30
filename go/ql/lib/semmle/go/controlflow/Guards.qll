/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 *
 * This is an instantiation of the shared guards library for Go.
 */
overlay[local?]
module;

private import go
private import semmle.go.controlflow.ControlFlowGraphImpl
private import semmle.go.dataflow.SSA as GoSsa
private import semmle.go.dataflow.SsaImpl as SsaImpl
private import semmle.go.dataflow.internal.DataFlowUtil as DataFlowUtil
private import codeql.controlflow.Guards as SharedGuards
private import codeql.controlflow.SuccessorType

private module GuardsInput implements
  SharedGuards::InputSig<Location, CfgImpl::Cfg::ControlFlowNode, CfgImpl::Cfg::BasicBlock>
{
  private import go as G

  class NormalExitNode = CfgImpl::ControlFlow::NormalExitNode;

  class AstNode = G::AstNode;

  class Expr extends G::Expr {
    /** Gets the associated control flow node. */
    CfgImpl::Cfg::ControlFlowNode getControlFlowNode() { result = IR::evalExprInstruction(this) }

    /** Gets the basic block containing this expression. */
    CfgImpl::Cfg::BasicBlock getBasicBlock() { result = this.getControlFlowNode().getBasicBlock() }
  }

  predicate booleanOutcomeBlock(Expr guard, CfgImpl::Cfg::BasicBlock outcomeBlock, boolean branch) {
    exists(CfgImpl::Cfg::ControlFlowNode outcomeNode |
      branch = true and outcomeNode.isAfterTrue(guard)
      or
      branch = false and outcomeNode.isAfterFalse(guard)
    |
      outcomeBlock = outcomeNode.getBasicBlock()
    )
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
    NilConstant() {
      exprRefersToNil(this)
      or
      exprRefersToNil(this.(G::ConversionExpr).getOperand().stripParens())
    }

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
      or
      DataFlowUtil::isCertainlyNotNil(DataFlow::exprNode(this))
    }
  }

  /**
   * A case clause in a tagged expression `switch` statement, or a case expression in an
   * expressionless `switch` statement.
   */
  class Case extends AstNode {
    G::ExpressionSwitchStmt switch;

    Case() {
      exists(switch.getExpr()) and
      this = switch.getACase()
      or
      not exists(switch.getExpr()) and
      (
        this = switch.getANonDefaultCase().getAnExpr()
        or
        this = switch.getDefault()
      )
    }

    Expr getSwitchExpr() {
      result = switch.getExpr()
      or
      not exists(switch.getExpr()) and result = this
    }

    predicate isDefaultCase() { this = switch.getDefault() }

    ConstantExpr asConstantCase() {
      exists(G::CaseClause cc |
        this = cc and
        cc.getNumExpr() = 1 and
        result = cc.getExpr(0)
      )
    }

    predicate matchEdge(CfgImpl::Cfg::BasicBlock bb1, CfgImpl::Cfg::BasicBlock bb2) {
      exists(Expr caseExpr |
        caseExpr = this.(G::CaseClause).getAnExpr()
        or
        caseExpr = this
      |
        caseExpressionBranch(caseExpr, bb1,
          any(MatchingSuccessor successor |
            bb1.getASuccessor(successor) = bb2 and successor.getValue() = true
          ))
      )
    }

    predicate nonMatchEdge(CfgImpl::Cfg::BasicBlock bb1, CfgImpl::Cfg::BasicBlock bb2) {
      exists(G::CaseClause cc, int last, Expr caseExpr |
        cc = this and
        last = max(int i | exists(cc.getExpr(i))) and
        caseExpr = cc.getExpr(last)
      |
        caseExpressionBranch(caseExpr, bb1,
          any(MatchingSuccessor successor |
            bb1.getASuccessor(successor) = bb2 and successor.getValue() = false
          ))
      )
      or
      caseExpressionBranch(this, bb1,
        any(MatchingSuccessor successor |
          bb1.getASuccessor(successor) = bb2 and successor.getValue() = false
        ))
    }
  }

  predicate caseOutcomeBlock(Case guard, CfgImpl::Cfg::BasicBlock outcomeBlock, boolean branch) {
    branch = true and
    guard.isDefaultCase() and
    outcomeBlock =
      any(CfgImpl::Cfg::ControlFlowNode outcomeNode |
        outcomeNode
            .isAfterValue(guard, any(MatchingSuccessor successor | successor.getValue() = true))
      ).getBasicBlock()
  }

  additional predicate caseExpressionBranch(
    Expr caseExpr, CfgImpl::Cfg::BasicBlock bb, MatchingSuccessor successor
  ) {
    exists(G::CaseClause cc, G::ExpressionSwitchStmt switch |
      cc = switch.getACase() and
      caseExpr = cc.getAnExpr() and
      bb.getLastNode() = caseExpr.getControlFlowNode() and
      exists(bb.getASuccessor(successor))
    )
  }

  predicate equalityBranchEdge(
    Expr left, Expr right, CfgImpl::Cfg::BasicBlock bb1, CfgImpl::Cfg::BasicBlock bb2, boolean equal
  ) {
    exists(G::CaseClause cc, G::ExpressionSwitchStmt switch |
      cc = switch.getACase() and
      left = switch.getExpr() and
      right = cc.getAnExpr() and
      caseExpressionBranch(right, bb1,
        any(MatchingSuccessor successor |
          bb1.getASuccessor(successor) = bb2 and successor.getValue() = equal
        ))
    )
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
  overlay[caller?]
  pragma[inline]
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

  final private class FinalFunction = G::Function;

  /**
   * A declared function or concrete method.
   *
   * Calls are restricted separately to calls whose syntactic target is this
   * function or method, excluding interface dispatch.
   */
  class NonOverridableMethod extends FinalFunction {
    NonOverridableMethod() {
      exists(super.getFuncDecl()) and
      super.getNumResult() <= 1
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
    call.getTarget() = m
  }

  private predicate hasExplicitReceiverArgument(G::CallExpr call) {
    call.getTarget() instanceof G::Method and
    call.getCalleeExpr().(G::SelectorExpr).getBase() instanceof G::TypeExpr
  }

  /**
   * Gets the receiver argument when the selector base is passed directly,
   * without promotion or an implicit address/dereference conversion.
   */
  private Expr getDirectReceiverArgument(G::CallExpr call, NonOverridableMethod method) {
    exists(G::SelectorExpr sel, IR::MethodReadInstruction read |
      sel = call.getCalleeExpr() and
      read.getExpr() = sel and
      read.getReceiver() = IR::evalExprInstruction(result) and
      result = sel.getBase() and
      result.getType() = method.getParameter(-1).getType()
    )
  }

  class NonOverridableMethodCall extends Expr instanceof G::CallExpr {
    NonOverridableMethodCall() { nonOverridableCall(this, _) }

    NonOverridableMethod getMethod() { nonOverridableCall(this, result) }

    Expr getArgument(ArgumentPosition apos) {
      (
        not hasExplicitReceiverArgument(this) and
        (
          apos = -1 and
          result = getDirectReceiverArgument(this, this.getMethod())
          or
          apos != -1 and
          result = super.getArgument(apos)
        )
        or
        hasExplicitReceiverArgument(this) and
        result = super.getArgument(apos + 1)
      ) and
      not (
        super.hasImplicitVarargs() and
        apos = this.getMethod().getNumParameter() - 1
      )
    }
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

  predicate implicitReturnDefinition(GuardsInput::NonOverridableMethod method, SsaDefinition def) {
    exists(IR::ReadResultInstruction read |
      method.getNumResult() = 1 and
      read.reads(method.getResult(0)) and
      def.getVariable().getAUse() = read
    )
  }

  predicate additionalSsaDefinitionValue(SsaDefinition def, GuardValue value) {
    exists(IR::EvalImplicitInitInstruction init |
      def.(GoSsa::SsaExplicitDefinition).getInstruction() = init and
      value.asBooleanValue() = init.getBoolValue()
    )
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
 * A guard. This is an expression whose value, or a switch case whose match outcome, determines
 * subsequent control flow.
 */
final class Guard extends GuardsLogic::Guard {
  /** Gets the innermost function or file to which this guard belongs. */
  ControlFlow::Root getRoot() { result.isRootOf(this) }
}

/**
 * Holds if `caseExpr` is a case expression in a tagged switch and its matching edge controls
 * `block`.
 */
predicate caseExpressionMatchControls(Expr caseExpr, BasicBlock block) {
  exists(BasicBlock guard, MatchingSuccessor successor |
    GuardsInput::caseExpressionBranch(caseExpr, guard, successor) and
    successor.getValue() = true and
    guard.edgeDominates(block, successor)
  )
}

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 */
module ValidationWrapper<GuardsLogic::guardChecksSig/3 guardChecks> {
  import GuardsLogic::ValidationWrapper<guardChecks/3>
}

bindingset[this]
private signature class ValidationParamSig;

private module WithValidationParam<ValidationParamSig P> {
  signature predicate guardChecksSig(Guard g, Expr e, GuardValue value, P param);
}

/**
 * Provides a parameterized set of guard checks extended with wrapped invocations.
 */
module ParameterizedValidationWrapper<
  ValidationParamSig P, WithValidationParam<P>::guardChecksSig/4 guardChecks0>
{
  private predicate guardChecksAdjusted(
    GuardsLogic::Guard g, GuardsInput::Expr e, GuardValue value, P param
  ) {
    guardChecks0(g, e, value, param)
  }

  private module Wrapper = GuardsLogic::ParameterizedValidationWrapper<P, guardChecksAdjusted/4>;

  /** Holds if `guard` validates `e` upon evaluating to `value`. */
  predicate guardChecks(Guard guard, Expr e, GuardValue value, P param) {
    Wrapper::guardChecks(guard, e, value, param)
  }
}

/**
 * Holds if `bb` can only be reached when the expression `e` evaluates to `b`.
 *
 * This is the replacement for the old
 * `ConditionGuardNode.ensures(e, b) and ConditionGuardNode.dominates(bb)`
 * idiom.
 */
overlay[caller?]
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
