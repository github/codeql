/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 *
 * This is an instantiation of the shared guards library for Go.
 */

overlay[local?]
module;

private import go
private import semmle.go.controlflow.BasicBlocks as BasicBlocks
private import semmle.go.dataflow.SSA as GoSsa
private import semmle.go.dataflow.SsaImpl as SsaImpl
private import codeql.controlflow.Guards as SharedGuards

private module GuardsInput implements
  SharedGuards::InputSig<Location, ControlFlowNode, BasicBlock>
{
  private import go as G

  /**
   * A control flow node indicating normal termination of a function or file.
   *
   * Go has no exceptions, so every exit node is a normal exit node. Note that
   * this also includes exits due to `panic`, which the guards library treats
   * conservatively.
   */
  class NormalExitNode extends ControlFlowNode {
    NormalExitNode() { this = ControlFlow::exitNode(_) }
  }

  class AstNode = G::AstNode;

  class Expr extends G::Expr {
    /** Gets the associated control flow node. */
    ControlFlowNode getControlFlowNode() { result = IR::evalExprInstruction(this) }

    /** Gets the basic block containing this expression. */
    BasicBlock getBasicBlock() { result = this.getControlFlowNode().getBasicBlock() }
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
   * A `switch` case.
   *
   * Go's control flow graph does not currently produce matching successor
   * edges for `switch` statements: an expression switch with a tag desugars
   * into ordinary comparisons, and a tagless expression switch already
   * produces Boolean successors for each case expression. Hence there is
   * nothing for this class to model.
   */
  class Case extends AstNode {
    Case() { none() }

    Expr getSwitchExpr() { none() }

    predicate isDefaultCase() { none() }

    ConstantExpr asConstantCase() { none() }

    predicate matchEdge(BasicBlock bb1, BasicBlock bb2) { none() }

    predicate nonMatchEdge(BasicBlock bb1, BasicBlock bb2) { none() }
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

  /**
   * An expression that has the same value as a specific sub-expression, that
   * is, a parenthesized expression or a type conversion.
   */
  class IdExpr extends Expr {
    IdExpr() { this instanceof G::ParenExpr or this instanceof G::ConversionExpr }

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

private module GuardsImpl =
  SharedGuards::Make<Location, BasicBlocks::Cfg, GuardsInput>;

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
   * Holds if `guard` evaluating to `val` ensures that:
   * `e <= k` when `upper = true`
   * `e >= k` when `upper = false`
   */
  predicate rangeGuard(
    GuardsImpl::PreGuard guard, GuardValue val, GuardsInput::Expr e, int k, boolean upper
  ) {
    exists(RelationalComparisonExpr rel, int strictnessAdjustment |
      guard = rel and
      val.asBooleanValue() = true and
      (if rel.isStrict() then strictnessAdjustment = 1 else strictnessAdjustment = 0)
    |
      // `e < k` or `e <= k`
      e = rel.getLesserOperand() and
      upper = true and
      k = rel.getGreaterOperand().getIntValue() - strictnessAdjustment
      or
      // `k < e` or `k <= e`
      e = rel.getGreaterOperand() and
      upper = false and
      k = rel.getLesserOperand().getIntValue() + strictnessAdjustment
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
  import GuardsLogic::ValidationWrapper<guardChecks>
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
