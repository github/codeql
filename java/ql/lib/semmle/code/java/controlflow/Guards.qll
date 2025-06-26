/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 */

import java
private import semmle.code.java.controlflow.Dominance
private import semmle.code.java.controlflow.internal.Preconditions
private import semmle.code.java.controlflow.internal.SwitchCases
private import codeql.controlflow.Guards as SharedGuards

/**
 * A basic block that terminates in a condition, splitting the subsequent control flow.
 */
class ConditionBlock extends BasicBlock {
  ConditionBlock() { this.getLastNode() instanceof ConditionNode }

  /** Gets the last node of this basic block. */
  ConditionNode getConditionNode() { result = this.getLastNode() }

  /** Gets the condition of the last node of this basic block. */
  ExprParent getCondition() { result = this.getConditionNode().getCondition() }

  /** Gets a `true`- or `false`-successor of the last node of this basic block. */
  BasicBlock getTestSuccessor(boolean testIsTrue) {
    result.getFirstNode() = this.getConditionNode().getABranchSuccessor(testIsTrue)
  }

  /*
   * For this block to control the block `controlled` with `testIsTrue` the following must be true:
   * Execution must have passed through the test i.e. `this` must strictly dominate `controlled`.
   * Execution must have passed through the `testIsTrue` edge leaving `this`.
   *
   * Although "passed through the true edge" implies that `this.getATrueSuccessor()` dominates `controlled`,
   * the reverse is not true, as flow may have passed through another edge to get to `this.getATrueSuccessor()`
   * so we need to assert that `this.getATrueSuccessor()` dominates `controlled` *and* that
   * all predecessors of `this.getATrueSuccessor()` are either `this` or dominated by `this.getATrueSuccessor()`.
   *
   * For example, in the following java snippet:
   * ```
   * if (x)
   *   controlled;
   * false_successor;
   * uncontrolled;
   * ```
   * `false_successor` dominates `uncontrolled`, but not all of its predecessors are `this` (`if (x)`)
   *  or dominated by itself. Whereas in the following code:
   * ```
   * if (x)
   *   while (controlled)
   *     also_controlled;
   * false_successor;
   * uncontrolled;
   * ```
   * the block `while controlled` is controlled because all of its predecessors are `this` (`if (x)`)
   * or (in the case of `also_controlled`) dominated by itself.
   *
   * The additional constraint on the predecessors of the test successor implies
   * that `this` strictly dominates `controlled` so that isn't necessary to check
   * directly.
   */

  /**
   * Holds if `controlled` is a basic block controlled by this condition, that
   * is, a basic blocks for which the condition is `testIsTrue`.
   */
  predicate controls(BasicBlock controlled, boolean testIsTrue) {
    exists(BasicBlock succ |
      succ = this.getTestSuccessor(testIsTrue) and
      dominatingEdge(this, succ) and
      succ.dominates(controlled)
    )
  }
}

// Join order engineering -- first determine the switch block and the case indices required, then retrieve them.
bindingset[switch, i]
pragma[inline_late]
private predicate isNthCaseOf(SwitchBlock switch, SwitchCase c, int i) { c.isNthCaseOf(switch, i) }

/**
 * Gets a switch case >= pred, up to but not including `pred`'s successor pattern case,
 * where `pred` is declared on `switch`.
 */
private SwitchCase getACaseUpToNextPattern(PatternCase pred, SwitchBlock switch) {
  // Note we do include `case null, default` (as well as plain old `default`) here.
  not result.(ConstCase).getValue(_) instanceof NullLiteral and
  exists(int maxCaseIndex |
    switch = pred.getParent() and
    if exists(getNextPatternCase(pred))
    then maxCaseIndex = getNextPatternCase(pred).getCaseIndex() - 1
    else maxCaseIndex = lastCaseIndex(switch)
  |
    isNthCaseOf(switch, result, [pred.getCaseIndex() .. maxCaseIndex])
  )
}

/**
 * Gets the closest pattern case preceding `case`, including `case` itself, if any.
 */
private PatternCase getClosestPrecedingPatternCase(SwitchCase case) {
  case = getACaseUpToNextPattern(result, _)
}

/**
 * Holds if `pred` is a control-flow predecessor of switch case `sc` that is not a
 * fall-through from a previous case.
 *
 * For classic switches that means flow from the selector expression; for switches
 * involving pattern cases it can also mean flow from a previous pattern case's type
 * test or guard failing and proceeding to then consider subsequent cases.
 */
private predicate isNonFallThroughPredecessor(SwitchCase sc, ControlFlowNode pred) {
  pred = sc.getControlFlowNode().getAPredecessor() and
  (
    pred.asExpr().getParent*() = sc.getSelectorExpr()
    or
    // Ambiguous: in the case of `case String _ when x: case "SomeConstant":`, the guard `x`
    // passing edge will fall through into the constant case, and the guard failing edge
    // will test if the selector equals `"SomeConstant"` and if so branch to the same
    // case statement. Therefore don't label this a non-fall-through predecessor.
    exists(PatternCase previousPatternCase |
      previousPatternCase = getClosestPrecedingPatternCase(sc)
    |
      pred.asExpr().getParent*() = previousPatternCase.getGuard() and
      // Check there is any statement in between the previous pattern case and this one,
      // or the case is a rule, so there is no chance of a fall-through.
      (
        previousPatternCase.isRule() or
        not previousPatternCase.getIndex() = sc.getIndex() - 1
      )
    )
    or
    // Unambigious: on the test-passing edge there must be at least one intervening
    // declaration node, including anonymous `_` declarations.
    pred.asStmt() = getClosestPrecedingPatternCase(sc)
  )
}

private module GuardsInput implements SharedGuards::InputSig<Location> {
  private import java as J
  private import semmle.code.java.dataflow.NullGuards as NullGuards
  import SuccessorType

  class ControlFlowNode = J::ControlFlowNode;

  class BasicBlock = J::BasicBlock;

  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) { J::dominatingEdge(bb1, bb2) }

  class AstNode = ExprParent;

  class Expr = J::Expr;

  private newtype TConstantValue =
    TCharValue(string c) { any(CharacterLiteral lit).getValue() = c } or
    TStringValue(string value) { any(CompileTimeConstantExpr c).getStringValue() = value } or
    TEnumValue(EnumConstant c)

  class ConstantValue extends TConstantValue {
    string toString() {
      this = TCharValue(result)
      or
      this = TStringValue(result)
      or
      exists(EnumConstant c | this = TEnumValue(c) and result = c.toString())
    }
  }

  abstract class ConstantExpr extends Expr {
    predicate isNull() { none() }

    boolean asBooleanValue() { none() }

    int asIntegerValue() { none() }

    ConstantValue asConstantValue() { none() }
  }

  private class NullConstant extends ConstantExpr instanceof J::NullLiteral {
    override predicate isNull() { any() }
  }

  private class BooleanConstant extends ConstantExpr instanceof J::BooleanLiteral {
    override boolean asBooleanValue() { result = super.getBooleanValue() }
  }

  private class IntegerConstant extends ConstantExpr instanceof J::CompileTimeConstantExpr {
    override int asIntegerValue() { result = super.getIntValue() }
  }

  private class CharConstant extends ConstantExpr instanceof J::CharacterLiteral {
    override ConstantValue asConstantValue() { result = TCharValue(super.getValue()) }
  }

  private class StringConstant extends ConstantExpr instanceof J::CompileTimeConstantExpr {
    override ConstantValue asConstantValue() { result = TStringValue(super.getStringValue()) }
  }

  private class EnumConstantExpr extends ConstantExpr instanceof J::VarAccess {
    override ConstantValue asConstantValue() {
      exists(EnumConstant c | this = c.getAnAccess() and result = TEnumValue(c))
    }
  }

  class NonNullExpr extends Expr {
    NonNullExpr() {
      this = NullGuards::baseNotNullExpr()
      or
      exists(Field f |
        this = f.getAnAccess() and
        f.isFinal() and
        f.getInitializer() = NullGuards::baseNotNullExpr()
      )
    }
  }

  class Case extends ExprParent instanceof J::SwitchCase {
    Expr getSwitchExpr() { result = super.getSelectorExpr() }

    predicate isDefaultCase() { this instanceof DefaultCase }

    ConstantExpr asConstantCase() {
      exists(ConstCase cc | this = cc |
        cc.getValue() = result and
        strictcount(cc.getValue(_)) = 1
      )
    }

    private predicate hasPatternCaseMatchEdge(BasicBlock bb1, BasicBlock bb2, boolean isMatch) {
      exists(ConditionNode patterncase |
        this instanceof PatternCase and
        patterncase = super.getControlFlowNode() and
        bb1.getLastNode() = patterncase and
        bb2.getFirstNode() = patterncase.getABranchSuccessor(isMatch)
      )
    }

    predicate matchEdge(BasicBlock bb1, BasicBlock bb2) {
      exists(ControlFlowNode pred |
        // Pattern cases are handled as ConditionBlocks.
        not this instanceof PatternCase and
        bb2.getFirstNode() = super.getControlFlowNode() and
        isNonFallThroughPredecessor(this, pred) and
        bb1 = pred.getBasicBlock()
      )
      or
      this.hasPatternCaseMatchEdge(bb1, bb2, true)
    }

    predicate nonMatchEdge(BasicBlock bb1, BasicBlock bb2) {
      this.hasPatternCaseMatchEdge(bb1, bb2, false)
    }
  }

  abstract private class BinExpr extends Expr {
    Expr getAnOperand() {
      result = this.(BinaryExpr).getAnOperand() or result = this.(AssignOp).getSource()
    }
  }

  class AndExpr extends BinExpr {
    AndExpr() {
      this instanceof AndBitwiseExpr or
      this instanceof AndLogicalExpr or
      this instanceof AssignAndExpr
    }
  }

  class OrExpr extends BinExpr {
    OrExpr() {
      this instanceof OrBitwiseExpr or
      this instanceof OrLogicalExpr or
      this instanceof AssignOrExpr
    }
  }

  class NotExpr extends Expr instanceof J::LogNotExpr {
    Expr getOperand() { result = this.(J::LogNotExpr).getExpr() }
  }

  class IdExpr extends Expr {
    IdExpr() { this instanceof AssignExpr or this instanceof CastExpr }

    Expr getEqualChildExpr() {
      result = this.(AssignExpr).getSource()
      or
      result = this.(CastExpr).getExpr()
    }
  }

  private predicate objectsEquals(Method equals) {
    equals.hasQualifiedName("java.util", "Objects", "equals") and
    equals.getNumberOfParameters() = 2
  }

  pragma[nomagic]
  predicate equalityTest(Expr eqtest, Expr left, Expr right, boolean polarity) {
    exists(EqualityTest eq | eq = eqtest |
      eq.getLeftOperand() = left and
      eq.getRightOperand() = right and
      eq.polarity() = polarity
    )
    or
    exists(MethodCall call | call = eqtest and polarity = true |
      call.getMethod() instanceof EqualsMethod and
      call.getQualifier() = left and
      call.getAnArgument() = right
      or
      objectsEquals(call.getMethod()) and
      call.getArgument(0) = left and
      call.getArgument(1) = right
    )
  }

  class ConditionalExpr extends Expr instanceof J::ConditionalExpr {
    Expr getCondition() { result = super.getCondition() }

    Expr getThen() { result = super.getTrueExpr() }

    Expr getElse() { result = super.getFalseExpr() }
  }
}

private module GuardsImpl = SharedGuards::Make<Location, GuardsInput>;

private module LogicInputCommon {
  private import semmle.code.java.dataflow.NullGuards as NullGuards

  predicate additionalNullCheck(
    GuardsImpl::PreGuard guard, GuardValue val, GuardsInput::Expr e, boolean isNull
  ) {
    guard.(InstanceOfExpr).getExpr() = e and val.asBooleanValue() = true and isNull = false
    or
    exists(MethodCall call |
      call = guard and
      call.getAnArgument() = e and
      NullGuards::nullCheckMethod(call.getMethod(), val.asBooleanValue(), isNull)
    )
  }
}

private module LogicInput_v1 implements GuardsImpl::LogicInputSig {
  private import semmle.code.java.dataflow.internal.BaseSSA

  final private class FinalBaseSsaVariable = BaseSsaVariable;

  class SsaDefinition extends FinalBaseSsaVariable {
    GuardsInput::Expr getARead() { result = this.getAUse() }
  }

  class SsaWriteDefinition extends SsaDefinition instanceof BaseSsaUpdate {
    GuardsInput::Expr getDefinition() {
      super.getDefiningExpr().(VariableAssign).getSource() = result or
      super.getDefiningExpr().(AssignOp) = result
    }
  }

  class SsaPhiNode extends SsaDefinition instanceof BaseSsaPhiNode {
    predicate hasInputFromBlock(SsaDefinition inp, BasicBlock bb) {
      super.hasInputFromBlock(inp, bb)
    }
  }

  predicate additionalNullCheck = LogicInputCommon::additionalNullCheck/4;

  predicate additionalImpliesStep(
    GuardsImpl::PreGuard g1, GuardValue v1, GuardsImpl::PreGuard g2, GuardValue v2
  ) {
    exists(MethodCall check, int argIndex |
      g1 = check and
      v1.getDualValue().isThrowsException() and
      conditionCheckArgument(check, argIndex, v2.asBooleanValue()) and
      g2 = check.getArgument(argIndex)
    )
  }
}

private module LogicInput_v2 implements GuardsImpl::LogicInputSig {
  private import semmle.code.java.dataflow.SSA as SSA

  final private class FinalSsaVariable = SSA::SsaVariable;

  class SsaDefinition extends FinalSsaVariable {
    GuardsInput::Expr getARead() { result = this.getAUse() }
  }

  class SsaWriteDefinition extends SsaDefinition instanceof SSA::SsaExplicitUpdate {
    GuardsInput::Expr getDefinition() {
      super.getDefiningExpr().(VariableAssign).getSource() = result or
      super.getDefiningExpr().(AssignOp) = result
    }
  }

  class SsaPhiNode extends SsaDefinition instanceof SSA::SsaPhiNode {
    predicate hasInputFromBlock(SsaDefinition inp, BasicBlock bb) {
      super.hasInputFromBlock(inp, bb)
    }
  }

  predicate additionalNullCheck = LogicInputCommon::additionalNullCheck/4;

  predicate additionalImpliesStep(
    GuardsImpl::PreGuard g1, GuardValue v1, GuardsImpl::PreGuard g2, GuardValue v2
  ) {
    LogicInput_v1::additionalImpliesStep(g1, v1, g2, v2)
    or
    CustomGuard::additionalImpliesStep(g1, v1, g2, v2)
  }
}

private module LogicInput_v3 implements GuardsImpl::LogicInputSig {
  private import semmle.code.java.dataflow.IntegerGuards as IntegerGuards
  import LogicInput_v2

  predicate rangeGuard(GuardsImpl::PreGuard guard, GuardValue val, Expr e, int k, boolean upper) {
    IntegerGuards::rangeGuard(guard, val.asBooleanValue(), e, k, upper)
  }

  predicate additionalNullCheck = LogicInputCommon::additionalNullCheck/4;

  predicate additionalImpliesStep = LogicInput_v2::additionalImpliesStep/4;
}

private module CustomGuardInput implements Guards_v2::CustomGuardInputSig {
  private import semmle.code.java.dataflow.SSA

  private int parameterPosition() { result in [-1, any(Parameter p).getPosition()] }

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

  final private class FinalMethod = Method;

  class BooleanMethod extends FinalMethod {
    BooleanMethod() {
      super.getReturnType().(PrimitiveType).hasName("boolean") and
      not super.isOverridable()
    }

    LogicInput_v2::SsaDefinition getParameter(ParameterPosition ppos) {
      exists(Parameter p |
        super.getParameter(ppos) = p and
        not p.isVarargs() and
        result.(SsaImplicitInit).isParameterDefinition(p)
      )
    }

    GuardsInput::Expr getAReturnExpr() {
      exists(ReturnStmt ret |
        this = ret.getEnclosingCallable() and
        ret.getResult() = result
      )
    }
  }

  private predicate booleanMethodCall(MethodCall call, BooleanMethod m) {
    call.getMethod().getSourceDeclaration() = m
  }

  class BooleanMethodCall extends GuardsInput::Expr instanceof MethodCall {
    BooleanMethodCall() { booleanMethodCall(this, _) }

    BooleanMethod getMethod() { booleanMethodCall(this, result) }

    GuardsInput::Expr getArgument(ArgumentPosition apos) { result = super.getArgument(apos) }
  }
}

class GuardValue = GuardsImpl::GuardValue;

private module CustomGuard = Guards_v2::CustomGuard<CustomGuardInput>;

/** INTERNAL: Don't use. */
module Guards_v1 = GuardsImpl::Logic<LogicInput_v1>;

/** INTERNAL: Don't use. */
module Guards_v2 = GuardsImpl::Logic<LogicInput_v2>;

/** INTERNAL: Don't use. */
module Guards_v3 = GuardsImpl::Logic<LogicInput_v3>;

/** INTERNAL: Don't use. */
predicate implies_v3(Guard g1, boolean b1, Guard g2, boolean b2) {
  Guards_v3::boolImplies(g1, any(GuardValue v | v.asBooleanValue() = b1), g2,
    any(GuardValue v | v.asBooleanValue() = b2))
}

/**
 * A guard. This may be any expression whose value determines subsequent
 * control flow. It may also be a switch case, which as a guard is considered
 * to evaluate to either true or false depending on whether the case matches.
 */
final class Guard extends Guards_v3::Guard {
  /** Gets the immediately enclosing callable whose body contains this guard. */
  Callable getEnclosingCallable() {
    result = this.(Expr).getEnclosingCallable() or
    result = this.(SwitchCase).getEnclosingCallable()
  }

  /**
   * Holds if this guard tests whether `testedExpr` has type `testedType`.
   *
   * `restricted` is true if the test applies additional restrictions on top of just `testedType`, and so
   * this guard failing does not guarantee `testedExpr` is *not* a `testedType`-- for example,
   * matching `record R(Object o)` with `case R(String s)` is a guard with an additional restriction on the
   * type of field `o`, so the guard passing guarantees `testedExpr` is an `R`, but it failing does not
   * guarantee `testedExpr` is not an `R`.
   */
  predicate appliesTypeTest(Expr testedExpr, Type testedType, boolean restricted) {
    (
      exists(InstanceOfExpr ioe | this = ioe |
        testedExpr = ioe.getExpr() and
        testedType = ioe.getSyntacticCheckedType()
      )
      or
      exists(PatternCase pc | this = pc |
        pc.getSelectorExpr() = testedExpr and
        testedType = pc.getUniquePattern().getType()
      )
    ) and
    (
      if
        exists(RecordPatternExpr rpe |
          rpe = [this.(InstanceOfExpr).getPattern(), this.(PatternCase).getAPattern()]
        |
          not rpe.isUnrestricted()
        )
      then restricted = true
      else restricted = false
    )
  }
}

/**
 * INTERNAL: Use `Guard.controls` instead.
 *
 * Holds if `guard.controls(controlled, branch)`, except this only relies on
 * BaseSSA-based reasoning.
 */
predicate guardControls_v1(Guards_v1::Guard guard, BasicBlock controlled, boolean branch) {
  guard.controls(controlled, branch)
}
