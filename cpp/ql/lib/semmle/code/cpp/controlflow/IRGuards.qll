/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 */

import cpp as Cpp
import semmle.code.cpp.ir.IR
private import codeql.util.Void
private import codeql.controlflow.Guards as SharedGuards
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.implementation.raw.internal.TranslatedExpr
private import semmle.code.cpp.ir.implementation.raw.internal.InstructionTag

private class BasicBlock = IRCfg::BasicBlock;

/**
 * INTERNAL: Do not use.
 */
module GuardsInput implements SharedGuards::InputSig<Cpp::Location, Instruction, IRCfg::BasicBlock> {
  private import cpp as Cpp

  class NormalExitNode = ExitFunctionInstruction;

  class AstNode = Instruction;

  /** The `Guards` library uses `Instruction`s as expressions. */
  class Expr extends Instruction {
    Instruction getControlFlowNode() { result = this }

    IRCfg::BasicBlock getBasicBlock() { result = this.getBlock() }
  }

  /**
   * The constant values that can be inferred.
   */
  class ConstantValue = Void;

  private class EqualityExpr extends CompareInstruction {
    EqualityExpr() {
      this instanceof CompareEQInstruction
      or
      this instanceof CompareNEInstruction
    }

    boolean getPolarity() {
      result = true and
      this instanceof CompareEQInstruction
      or
      result = false and
      this instanceof CompareNEInstruction
    }
  }

  /** A constant expression. */
  abstract class ConstantExpr extends Expr {
    /** Holds if this expression is the null constant. */
    predicate isNull() { none() }

    /** Holds if this expression is a boolean constant. */
    boolean asBooleanValue() { none() }

    /** Holds if this expression is an integer constant. */
    int asIntegerValue() { none() }

    /**
     * Holds if this expression is a C/C++ specific constant value.
     * This currently never holds in C/C++.
     */
    ConstantValue asConstantValue() { none() }
  }

  private class NullConstant extends ConstantExpr instanceof ConstantInstruction {
    NullConstant() {
      this.getValue() = "0" and
      this.getResultIRType() instanceof IRAddressType
    }

    override predicate isNull() { any() }
  }

  private class BooleanConstant extends ConstantExpr instanceof ConstantInstruction {
    BooleanConstant() { this.getResultIRType() instanceof IRBooleanType }

    override boolean asBooleanValue() {
      super.getValue() = "0" and
      result = false
      or
      super.getValue() = "1" and
      result = true
    }
  }

  private class IntegerConstant extends ConstantExpr {
    int value;

    IntegerConstant() {
      this.(ConstantInstruction).getValue().toInt() = value and
      this.getResultIRType() instanceof IRIntegerType
      or
      // In order to have an integer constant for a switch case
      // we misuse the first instruction (which is always a NoOp instruction)
      // as a constant with the switch case's value.
      // Even worse, since we need a case range to generate an `TIntRange`
      // guard value we must ensure that there exists `ConstantExpr`s whose
      // integer value is the end-points. So we let this constant expression
      // have both end-point values. Luckily, these `NoOp` instructions do not
      // interact with SSA in any way. So this should not break anything.
      exists(CaseEdge edge | this = any(SwitchInstruction switch).getSuccessor(edge) |
        value = edge.getMaxValue().toInt()
        or
        value = edge.getMinValue().toInt()
      )
    }

    override int asIntegerValue() { result = value }
  }

  private predicate nonNullExpr(Instruction i) {
    i instanceof VariableAddressInstruction
    or
    i.(PointerConstantInstruction).getValue() != "0"
    or
    i instanceof TypeidInstruction
    or
    nonNullExpr(i.(FieldAddressInstruction).getObjectAddress())
    or
    nonNullExpr(i.(PointerAddInstruction).getLeft())
    or
    nonNullExpr(i.(CopyInstruction).getSourceValue())
    or
    nonNullExpr(i.(ConvertInstruction).getUnary())
    or
    nonNullExpr(i.(CheckedConvertOrThrowInstruction).getUnary())
    or
    nonNullExpr(i.(CompleteObjectAddressInstruction).getUnary())
    or
    nonNullExpr(i.(InheritanceConversionInstruction).getUnary())
    or
    nonNullExpr(i.(BitOrInstruction).getAnInput())
  }

  /**
   * An expression that is guaranteed to not be `null`.
   */
  class NonNullExpr extends Expr {
    NonNullExpr() { nonNullExpr(this) }
  }

  /** A `case` in a `switch` instruction. */
  class Case extends Expr {
    SwitchInstruction switch;
    SwitchEdge edge;

    Case() { switch.getSuccessor(edge) = this }

    /**
     * Gets the edge for which control flows from the `Switch` instruction to
     * the target case.
     */
    SwitchEdge getEdge() { result = edge }

    /**
     * Holds if this case takes control-flow from `bb1` to `bb2` when
     * the case matches the scrutinee.
     */
    predicate matchEdge(BasicBlock bb1, BasicBlock bb2) {
      switch.getBlock() = bb1 and
      this.getBasicBlock() = bb2
    }

    /**
     * Holds if case takes control-flow from `bb1` to `bb2` when the
     * case does not match the scrutinee.
     *
     * This predicate never holds for C/C++.
     */
    predicate nonMatchEdge(BasicBlock bb1, BasicBlock bb2) { none() }

    /**
     * Gets the scrutinee expression.
     */
    Expr getSwitchExpr() { result = switch.getExpression() }

    /**
     * Holds if this case is the default case.
     */
    predicate isDefaultCase() { edge.isDefault() }

    /**
     * Gets the constant expression of this case.
     */
    ConstantExpr asConstantCase() {
      // Note: This only has a value if there is a unique value for the case.
      // So the will not be a result when using the GCC case range extension.
      // Instead, we model these using the `LogicInput_v1::rangeGuard` predicate.
      result = this and exists(this.getEdge().getValue())
    }
  }

  abstract private class BinExpr extends Expr instanceof BinaryInstruction {
    Expr getAnOperand() { result = super.getAnInput() }
  }

  /**
   * A bitwise "AND" expression.
   *
   * This does not include logical AND expressions since these are desugared as
   * part of IR generation.
   */
  class AndExpr extends BinExpr instanceof BitAndInstruction { }

  /**
   * A bitwise "OR" expression.
   *
   * This does not include logical OR expressions since these are desugared as
   * part of IR generation.
   */
  class OrExpr extends BinExpr instanceof BitOrInstruction { }

  /** A (bitwise or logical) "NOT" expression. */
  class NotExpr extends Expr instanceof UnaryInstruction {
    NotExpr() {
      this instanceof LogicalNotInstruction
      or
      this instanceof BitComplementInstruction
    }

    /** Gets the operand of this expression. */
    Expr getOperand() { result = super.getUnary() }
  }

  private predicate isBoolToIntConversion(ConvertInstruction convert, Instruction unary) {
    convert.getUnary() = unary and
    unary.getResultIRType() instanceof IRBooleanType and
    convert.getResultIRType() instanceof IRIntegerType
  }

  /**
   * A value preserving expression.
   */
  class IdExpr extends Expr {
    IdExpr() {
      this instanceof CopyInstruction
      or
      not isBoolToIntConversion(this, _) and
      this instanceof ConvertInstruction
      or
      this instanceof InheritanceConversionInstruction
    }

    /** Get the child expression that defines the value of this expression. */
    Expr getEqualChildExpr() {
      result = this.(CopyInstruction).getSourceValue()
      or
      result = this.(ConvertInstruction).getUnary()
      or
      result = this.(InheritanceConversionInstruction).getUnary()
    }
  }

  /**
   * Holds if `eqtest` tests the equality (or inequality) of `left` and
   * `right.`
   *
   * If `polarity` is `true` then `eqtest` is an equality test, and otherwise
   * `eqtest` is an inequality test.
   */
  pragma[nomagic]
  predicate equalityTest(Expr eqtest, Expr left, Expr right, boolean polarity) {
    exists(EqualityExpr eq | eqtest = eq |
      eq.getLeft() = left and
      eq.getRight() = right and
      polarity = eq.getPolarity()
    )
  }

  /**
   * A conditional expression (i.e., `b ? e1 : e2`). This expression is desugared
   * as part of IR generation.
   */
  class ConditionalExpr extends Expr {
    ConditionalExpr() { none() }

    /** Gets the condition of this conditional expression. */
    Expr getCondition() { none() }

    /** Gets the true branch of this conditional expression. */
    Expr getThen() { none() }

    /** Gets the false branch of this conditional expression. */
    Expr getElse() { none() }
  }

  private import semmle.code.cpp.dataflow.new.DataFlow::DataFlow as DataFlow
  private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate as Private

  class Parameter = Cpp::Parameter;

  /**
   * A (direct) parameter position. The value `-1` represents the position of
   * the implicit `this` parameter.
   */
  private int parameterPosition() { result in [-1, any(Cpp::Parameter p).getIndex()] }

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

  final private class FinalMethod = Cpp::Function;

  /**
   * A non-overridable function.
   *
   * This function is non-overridable either because it is not a member function, or
   * because it is a final member function.
   */
  class NonOverridableMethod extends FinalMethod {
    NonOverridableMethod() {
      not this instanceof Cpp::MemberFunction
      or
      exists(Cpp::MemberFunction mf | this = mf |
        not mf.isVirtual()
        or
        mf.isFinal()
      )
    }

    /** Gets the `Parameter` at `pos` of this function, if any. */
    Parameter getParameter(ParameterPosition ppos) { super.getParameter(ppos) = result }

    /** Gets an expression returned from this function. */
    GuardsInput::Expr getAReturnExpr() {
      exists(StoreInstruction store |
        // A write to the `IRVariable` which represents the return value.
        store.getDestinationAddress().(VariableAddressInstruction).getIRVariable() instanceof
          IRReturnVariable and
        store.getEnclosingFunction() = this and
        result = store
      )
    }
  }

  private predicate nonOverridableMethodCall(CallInstruction call, NonOverridableMethod m) {
    call.getStaticCallTarget() = m
  }

  /**
   * A call to a `NonOverridableMethod`.
   */
  class NonOverridableMethodCall extends GuardsInput::Expr instanceof CallInstruction {
    NonOverridableMethodCall() { nonOverridableMethodCall(this, _) }

    /** Gets the function that is called. */
    NonOverridableMethod getMethod() { nonOverridableMethodCall(this, result) }

    /** Gets the argument at `apos`, if any. */
    GuardsInput::Expr getArgument(ArgumentPosition apos) { result = super.getArgument(apos) }
  }
}

private module GuardsImpl = SharedGuards::Make<Cpp::Location, IRCfg, GuardsInput>;

private module LogicInput_v1 implements GuardsImpl::LogicInputSig {
  private import semmle.code.cpp.dataflow.new.DataFlow::DataFlow::Ssa

  final private class FinalBaseSsaVariable = Definition;

  class SsaDefinition extends FinalBaseSsaVariable {
    GuardsInput::Expr getARead() { result = this.getAUse().getDef() }
  }

  class SsaExplicitWrite extends SsaDefinition instanceof ExplicitDefinition {
    GuardsInput::Expr getValue() { result = super.getAssignedInstruction() }
  }

  class SsaPhiDefinition extends SsaDefinition instanceof PhiNode {
    predicate hasInputFromBlock(SsaDefinition inp, BasicBlock bb) {
      super.hasInputFromBlock(inp, bb)
    }
  }

  class SsaParameterInit extends SsaDefinition {
    SsaParameterInit() { this.isParameterDefinition(_) }

    GuardsInput::Parameter getParameter() { this.isParameterDefinition(result) }
  }

  predicate additionalImpliesStep(
    GuardsImpl::PreGuard g1, GuardValue v1, GuardsImpl::PreGuard g2, GuardValue v2
  ) {
    // The `ConditionalBranch` instruction is the instruction for which there are
    // conditional successors out of. However, the condition that controls
    // which conditional successor is taken is given by the condition of the
    // `ConditionalBranch` instruction. So this step either needs to be here,
    // or we need `ConditionalBranch` instructions to be `IdExpr`s. Modeling
    // them as `IdExpr`s would be a bit weird since the result type is
    // `IRVoidType`. Including them here is fine as long as `ConditionalBranch`
    // instructions cannot be assigned to SSA variables (which they cannot
    // since they produce no value).
    g1.(ConditionalBranchInstruction).getCondition() = g2 and
    v1.asBooleanValue() = v2.asBooleanValue()
  }

  predicate rangeGuard(
    GuardsImpl::PreGuard guard, GuardValue val, GuardsInput::Expr e, int k, boolean upper
  ) {
    exists(SwitchInstruction switch, string minValue, string maxValue |
      switch.getSuccessor(EdgeKind::caseEdge(minValue, maxValue)) = guard and
      e = switch.getExpression() and
      minValue != maxValue and
      val.asBooleanValue() = true
    |
      upper = false and
      k = minValue.toInt()
      or
      upper = true and
      k = maxValue.toInt()
    )
  }
}

class GuardValue = GuardsImpl::GuardValue;

/** INTERNAL: Don't use. */
module Guards_v1 = GuardsImpl::Logic<LogicInput_v1>;

/**
 * Holds if `block` consists of an `UnreachedInstruction`.
 *
 * We avoiding reporting an unreached block as being controlled by a guard. The unreached block
 * has the AST for the `Function` itself, which tends to confuse mapping between the AST `BasicBlock`
 * and the `IRBlock`.
 */
pragma[noinline]
private predicate isUnreachedBlock(IRBlock block) {
  block.getFirstInstruction() instanceof UnreachedInstruction
}

/**
 * DEPRECATED: Use `GuardValue` instead.
 *
 * An abstract value. This is either a boolean value, or a `switch` case.
 */
deprecated class AbstractValue extends GuardValue { }

/**
 * DEPRECATED: Use `GuardValue` instead.
 *
 * A Boolean value.
 */
deprecated class BooleanValue extends AbstractValue {
  BooleanValue() { exists(this.asBooleanValue()) }

  /** Gets the underlying Boolean value. */
  boolean getValue() { result = this.asBooleanValue() }
}

/**
 * DEPRECATED: Use `GuardValue` instead.
 *
 * A value that represents a match against a specific `switch` case.
 */
deprecated class MatchValue extends AbstractValue {
  MatchValue() { exists(this.asIntValue()) }

  /** Gets the case. */
  CaseEdge getCase() { result.getValue().toInt() = this.asIntValue() }
}

/**
 * A Boolean condition in the AST that guards one or more basic blocks. This includes
 * operands of logical operators but not switch statements.
 */
private class GuardConditionImpl extends Cpp::Element {
  /**
   * Holds if this condition controls `controlled`, meaning that `controlled` is only
   * entered if the value of this condition is `v`.
   *
   * For details on what "controls" mean, see the QLDoc for `controls`.
   */
  abstract predicate valueControls(Cpp::BasicBlock controlled, GuardValue v);

  /**
   * Holds if this condition controls `controlled`, meaning that `controlled` is only
   * entered if the value of this condition is `testIsTrue`.
   *
   * Illustration:
   *
   * ```
   * [                    (testIsTrue)                        ]
   * [             this ----------------succ ---- controlled  ]
   * [               |                    |                   ]
   * [ (testIsFalse) |                     ------ ...         ]
   * [             other                                      ]
   * ```
   *
   * The predicate holds if all paths to `controlled` go via the `testIsTrue`
   * edge of the control-flow graph. In other words, the `testIsTrue` edge
   * must dominate `controlled`. This means that `controlled` must be
   * dominated by both `this` and `succ` (the target of the `testIsTrue`
   * edge). It also means that any other edge into `succ` must be a back-edge
   * from a node which is dominated by `succ`.
   *
   * The short-circuit boolean operations have slightly surprising behavior
   * here: because the operation itself only dominates one branch (due to
   * being short-circuited) then it will only control blocks dominated by the
   * true (for `&&`) or false (for `||`) branch.
   */
  final predicate controls(Cpp::BasicBlock controlled, boolean testIsTrue) {
    this.valueControls(controlled, any(GuardValue bv | bv.asBooleanValue() = testIsTrue))
  }

  /**
   * Holds if the control-flow edge `(pred, succ)` may be taken only if
   * the value of this condition is `v`.
   */
  abstract predicate valueControlsEdge(Cpp::BasicBlock pred, Cpp::BasicBlock succ, GuardValue v);

  /**
   * Holds if  the control-flow edge `(pred, succ)` may be taken only if
   * this the value of this condition is `testIsTrue`.
   */
  final predicate controlsEdge(Cpp::BasicBlock pred, Cpp::BasicBlock succ, boolean testIsTrue) {
    this.valueControlsEdge(pred, succ, any(GuardValue bv | bv.asBooleanValue() = testIsTrue))
  }

  /**
   * Holds if (determined by this guard) `left < right + k` evaluates to `isLessThan` if this
   * expression evaluates to `testIsTrue`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate comparesLt(
    Cpp::Expr left, Cpp::Expr right, int k, boolean isLessThan, boolean testIsTrue
  );

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `left >= right + k`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate ensuresLt(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock block, boolean isLessThan
  );

  /**
   * Holds if (determined by this guard) `e < k` evaluates to `isLessThan` if
   * this expression evaluates to `value`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate comparesLt(Cpp::Expr e, int k, boolean isLessThan, GuardValue value);

  /**
   * Holds if (determined by this guard) `e < k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `e >= k`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate ensuresLt(Cpp::Expr e, int k, Cpp::BasicBlock block, boolean isLessThan);

  /**
   * Holds if (determined by this guard) `left == right + k` evaluates to `areEqual` if this
   * expression evaluates to `testIsTrue`. Note that there's a 4-argument ("unary") and a
   * 5-argument ("binary") version of `comparesEq` and they are not equivalent:
   *  - the unary version is suitable for guards where there is no expression representing the
   *    right-hand side, such as `if (x)`, and also works for equality with an integer constant
   *    (such as `if (x == k)`).
   *  - the binary version is the more general case for comparison of any expressions (not
   *    necessarily integer).
   */
  pragma[inline]
  abstract predicate comparesEq(
    Cpp::Expr left, Cpp::Expr right, int k, boolean areEqual, boolean testIsTrue
  );

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate ensuresEq(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock block, boolean areEqual
  );

  /**
   * Holds if (determined by this guard) `e == k` evaluates to `areEqual` if this expression
   * evaluates to `value`. Note that there's a 4-argument ("unary") and a 5-argument ("binary")
   * version of `comparesEq` and they are not equivalent:
   *  - the unary version is suitable for guards where there is no expression representing the
   *    right-hand side, such as `if (x)`, and also works for equality with an integer constant
   *    (such as `if (x == k)`).
   *  - the binary version is the more general case for comparison of any expressions (not
   *    necessarily integer).
   */
  pragma[inline]
  abstract predicate comparesEq(Cpp::Expr e, int k, boolean areEqual, GuardValue value);

  /**
   * Holds if (determined by this guard) `e == k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `e != k`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate ensuresEq(Cpp::Expr e, int k, Cpp::BasicBlock block, boolean areEqual);

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` on the edge from
   * `pred` to `succ`. If `areEqual = false` then this implies `left != right + k`.
   */
  pragma[inline]
  final predicate ensuresEqEdge(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock pred, Cpp::BasicBlock succ,
    boolean areEqual
  ) {
    exists(boolean testIsTrue |
      this.comparesEq(left, right, k, areEqual, testIsTrue) and
      this.controlsEdge(pred, succ, testIsTrue)
    )
  }

  /**
   * Holds if (determined by this guard) `e == k` must be `areEqual` on the edge from
   * `pred` to `succ`. If `areEqual = false` then this implies `e != k`.
   */
  pragma[inline]
  final predicate ensuresEqEdge(
    Cpp::Expr e, int k, Cpp::BasicBlock pred, Cpp::BasicBlock succ, boolean areEqual
  ) {
    exists(GuardValue v |
      this.comparesEq(e, k, areEqual, v) and
      this.valueControlsEdge(pred, succ, v)
    )
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` on the edge from
   * `pred` to `succ`. If `isLessThan = false` then this implies `left >= right + k`.
   */
  pragma[inline]
  final predicate ensuresLtEdge(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock pred, Cpp::BasicBlock succ,
    boolean isLessThan
  ) {
    exists(boolean testIsTrue |
      this.comparesLt(left, right, k, isLessThan, testIsTrue) and
      this.controlsEdge(pred, succ, testIsTrue)
    )
  }

  /**
   * Holds if (determined by this guard) `e < k` must be `isLessThan` on the edge from
   * `pred` to `succ`. If `isLessThan = false` then this implies `e >= k`.
   */
  pragma[inline]
  final predicate ensuresLtEdge(
    Cpp::Expr e, int k, Cpp::BasicBlock pred, Cpp::BasicBlock succ, boolean isLessThan
  ) {
    exists(GuardValue v |
      this.comparesLt(e, k, isLessThan, v) and
      this.valueControlsEdge(pred, succ, v)
    )
  }
}

final class GuardCondition = GuardConditionImpl;

/**
 * A binary logical operator in the AST that guards one or more basic blocks.
 */
private class GuardConditionFromBinaryLogicalOperator extends GuardConditionImpl instanceof Cpp::BinaryLogicalOperation
{
  override predicate valueControls(Cpp::BasicBlock controlled, GuardValue v) {
    exists(Cpp::BinaryLogicalOperation binop, GuardCondition lhs, GuardCondition rhs |
      this = binop and
      lhs = binop.getLeftOperand() and
      rhs = binop.getRightOperand() and
      lhs.valueControls(controlled, v) and
      rhs.valueControls(controlled, v)
    )
  }

  override predicate valueControlsEdge(Cpp::BasicBlock pred, Cpp::BasicBlock succ, GuardValue v) {
    exists(Cpp::BinaryLogicalOperation binop, GuardCondition lhs, GuardCondition rhs |
      this = binop and
      lhs = binop.getLeftOperand() and
      rhs = binop.getRightOperand() and
      lhs.valueControlsEdge(pred, succ, v) and
      rhs.valueControlsEdge(pred, succ, v)
    )
  }

  override predicate comparesLt(
    Cpp::Expr left, Cpp::Expr right, int k, boolean isLessThan, boolean testIsTrue
  ) {
    exists(boolean partIsTrue, GuardCondition part |
      this.(Cpp::BinaryLogicalOperation).impliesValue(part, partIsTrue, testIsTrue)
    |
      part.comparesLt(left, right, k, isLessThan, partIsTrue)
    )
  }

  override predicate comparesLt(Cpp::Expr e, int k, boolean isLessThan, GuardValue value) {
    exists(GuardValue partValue, GuardCondition part |
      this.(Cpp::BinaryLogicalOperation)
          .impliesValue(part, partValue.asBooleanValue(), value.asBooleanValue())
    |
      part.comparesLt(e, k, isLessThan, partValue)
    )
  }

  pragma[inline]
  override predicate ensuresLt(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock block, boolean isLessThan
  ) {
    exists(boolean testIsTrue |
      this.comparesLt(left, right, k, isLessThan, testIsTrue) and this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresLt(Cpp::Expr e, int k, Cpp::BasicBlock block, boolean isLessThan) {
    exists(GuardValue value |
      this.comparesLt(e, k, isLessThan, value) and this.valueControls(block, value)
    )
  }

  override predicate comparesEq(
    Cpp::Expr left, Cpp::Expr right, int k, boolean areEqual, boolean testIsTrue
  ) {
    exists(boolean partIsTrue, GuardCondition part |
      this.(Cpp::BinaryLogicalOperation).impliesValue(part, partIsTrue, testIsTrue)
    |
      part.comparesEq(left, right, k, areEqual, partIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresEq(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock block, boolean areEqual
  ) {
    exists(boolean testIsTrue |
      this.comparesEq(left, right, k, areEqual, testIsTrue) and this.controls(block, testIsTrue)
    )
  }

  override predicate comparesEq(Cpp::Expr e, int k, boolean areEqual, GuardValue value) {
    exists(GuardValue partValue, GuardCondition part |
      this.(Cpp::BinaryLogicalOperation)
          .impliesValue(part, partValue.asBooleanValue(), value.asBooleanValue())
    |
      part.comparesEq(e, k, areEqual, partValue)
    )
  }

  pragma[inline]
  override predicate ensuresEq(Cpp::Expr e, int k, Cpp::BasicBlock block, boolean areEqual) {
    exists(GuardValue value |
      this.comparesEq(e, k, areEqual, value) and this.valueControls(block, value)
    )
  }
}

/**
 * Holds if `ir` controls `block`, meaning that `block` is only
 * entered if the value of this condition is `v`. This helper
 * predicate does not necessarily hold for binary logical operations like
 * `&&` and `||`. See the detailed explanation on predicate `controls`.
 */
private predicate controlsBlock(IRGuardCondition ir, Cpp::BasicBlock controlled, GuardValue v) {
  exists(IRBlock irb |
    ir.valueControls(irb, v) and
    nonExcludedIRAndBasicBlock(irb, controlled) and
    not isUnreachedBlock(irb)
  )
}

/**
 * Holds if `ir` controls the `(pred, succ)` edge, meaning that the edge
 * `(pred, succ)` is only taken if the value of this condition is `v`. This
 * helper predicate does not necessarily hold for binary logical operations
 * like `&&` and `||`.
 * See the detailed explanation on predicate `controlsEdge`.
 */
private predicate controlsEdge(
  IRGuardCondition ir, Cpp::BasicBlock pred, Cpp::BasicBlock succ, GuardValue v
) {
  exists(IRBlock irPred, IRBlock irSucc |
    ir.valueControlsBranchEdge(irPred, irSucc, v) and
    nonExcludedIRAndBasicBlock(irPred, pred) and
    nonExcludedIRAndBasicBlock(irSucc, succ) and
    not isUnreachedBlock(irPred) and
    not isUnreachedBlock(irSucc)
  )
}

private class GuardConditionFromNotExpr extends GuardConditionImpl {
  IRGuardCondition ir;

  GuardConditionFromNotExpr() {
    // Users often expect the `x` in `!x` to also be a guard condition. But
    // from the perspective of the IR the `x` is just the left-hand side of a
    // comparison against 0 so it's not included as a normal
    // `IRGuardCondition`. So to align with user expectations we make that `x`
    // a `GuardCondition`.
    exists(Cpp::NotExpr notExpr | this = notExpr.getOperand() |
      ir.getUnconvertedResultExpression() = notExpr
      or
      ir.(ConditionalBranchInstruction).getCondition().getUnconvertedResultExpression() = notExpr
    )
  }

  override predicate valueControls(Cpp::BasicBlock controlled, GuardValue v) {
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    controlsBlock(ir, controlled, v.getDualValue())
  }

  override predicate valueControlsEdge(Cpp::BasicBlock pred, Cpp::BasicBlock succ, GuardValue v) {
    controlsEdge(ir, pred, succ, v.getDualValue())
  }

  pragma[inline]
  override predicate comparesLt(
    Cpp::Expr left, Cpp::Expr right, int k, boolean isLessThan, boolean testIsTrue
  ) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue.booleanNot())
    )
  }

  pragma[inline]
  override predicate comparesLt(Cpp::Expr e, int k, boolean isLessThan, GuardValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value.getDualValue())
    )
  }

  pragma[inline]
  override predicate ensuresLt(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock block, boolean isLessThan
  ) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue.booleanNot()) and
      this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresLt(Cpp::Expr e, int k, Cpp::BasicBlock block, boolean isLessThan) {
    exists(Instruction i, GuardValue value |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value.getDualValue()) and
      this.valueControls(block, value)
    )
  }

  pragma[inline]
  override predicate comparesEq(
    Cpp::Expr left, Cpp::Expr right, int k, boolean areEqual, boolean testIsTrue
  ) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue.booleanNot())
    )
  }

  pragma[inline]
  override predicate ensuresEq(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock block, boolean areEqual
  ) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue.booleanNot()) and
      this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate comparesEq(Cpp::Expr e, int k, boolean areEqual, GuardValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesEq(i.getAUse(), k, areEqual, value.getDualValue())
    )
  }

  pragma[inline]
  override predicate ensuresEq(Cpp::Expr e, int k, Cpp::BasicBlock block, boolean areEqual) {
    exists(Instruction i, GuardValue value |
      i.getUnconvertedResultExpression() = e and
      ir.comparesEq(i.getAUse(), k, areEqual, value.getDualValue()) and
      this.valueControls(block, value)
    )
  }
}

/**
 * A Boolean condition in the AST that guards one or more basic blocks and has a corresponding IR
 * instruction.
 */
private class GuardConditionFromIR extends GuardConditionImpl {
  IRGuardCondition ir;

  GuardConditionFromIR() {
    ir.(InitializeParameterInstruction).getParameter() = this
    or
    ir.(ConditionalBranchInstruction).getCondition().getUnconvertedResultExpression() = this
    or
    ir.getUnconvertedResultExpression() = this
  }

  override predicate valueControls(Cpp::BasicBlock controlled, GuardValue v) {
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    controlsBlock(ir, controlled, v)
  }

  override predicate valueControlsEdge(Cpp::BasicBlock pred, Cpp::BasicBlock succ, GuardValue v) {
    controlsEdge(ir, pred, succ, v)
  }

  pragma[inline]
  override predicate comparesLt(
    Cpp::Expr left, Cpp::Expr right, int k, boolean isLessThan, boolean testIsTrue
  ) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue)
    )
  }

  pragma[inline]
  override predicate comparesLt(Cpp::Expr e, int k, boolean isLessThan, GuardValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value)
    )
  }

  pragma[inline]
  override predicate ensuresLt(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock block, boolean isLessThan
  ) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue) and
      this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresLt(Cpp::Expr e, int k, Cpp::BasicBlock block, boolean isLessThan) {
    exists(Instruction i, GuardValue value |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value) and
      this.valueControls(block, value)
    )
  }

  pragma[inline]
  override predicate comparesEq(
    Cpp::Expr left, Cpp::Expr right, int k, boolean areEqual, boolean testIsTrue
  ) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresEq(
    Cpp::Expr left, Cpp::Expr right, int k, Cpp::BasicBlock block, boolean areEqual
  ) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue) and
      this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate comparesEq(Cpp::Expr e, int k, boolean areEqual, GuardValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesEq(i.getAUse(), k, areEqual, value)
    )
  }

  pragma[inline]
  override predicate ensuresEq(Cpp::Expr e, int k, Cpp::BasicBlock block, boolean areEqual) {
    exists(Instruction i, GuardValue value |
      i.getUnconvertedResultExpression() = e and
      ir.comparesEq(i.getAUse(), k, areEqual, value) and
      this.valueControls(block, value)
    )
  }
}

private predicate excludeAsControlledInstruction(Instruction instr) {
  // Exclude the temporaries generated by a ternary expression.
  exists(TranslatedConditionalExpr tce |
    instr = tce.getInstruction(ConditionValueFalseStoreTag())
    or
    instr = tce.getInstruction(ConditionValueTrueStoreTag())
    or
    instr = tce.getInstruction(ConditionValueTrueTempAddressTag())
    or
    instr = tce.getInstruction(ConditionValueFalseTempAddressTag())
  )
  or
  // Exclude unreached instructions, as their AST is the whole function and not a block.
  instr instanceof UnreachedInstruction
}

/**
 * Holds if `irb` is the `IRBlock` corresponding to the AST basic block
 * `controlled`, and `irb` does not contain any instruction(s) that should make
 * the `irb` be ignored.
 */
pragma[nomagic]
private predicate nonExcludedIRAndBasicBlock(IRBlock irb, Cpp::BasicBlock controlled) {
  exists(Instruction instr |
    instr = irb.getAnInstruction() and
    instr.getAst() = controlled.getANode() and
    not excludeAsControlledInstruction(instr)
  )
}

/**
 * A guard. This may be any expression whose value determines subsequent
 * control flow. It may also be a switch case, which as a guard is considered
 * to evaluate to either true or false depending on whether the case matches.
 */
final class IRGuardCondition extends Guards_v1::Guard {
  /*
   * An `IRGuardCondition` supports reasoning about four different kinds of
   * relations:
   * 1. A unary equality relation of the form `e == k`
   * 2. A binary equality relation of the form `e1 == e2 + k`
   * 3. A unary inequality relation of the form `e < k`
   * 4. A binary inequality relation of the form `e1 < e2 + k`
   *
   * where `k` is a constant.
   *
   * Furthermore, the unary relations (i.e., case 1 and case 3) are also
   * inferred from `switch` statement guards: equality relations are inferred
   * from the unique `case` statement, if any, and inequality relations are
   * inferred from the [case range](https://gcc.gnu.org/onlinedocs/gcc/Case-Ranges.html)
   * gcc extension.
   *
   * The implementation of all four follows the same structure: Each relation
   * has a user-facing predicate that. For example,
   * `GuardCondition::comparesEq` calls `compares_eq`. This predicate has
   * several cases that recursively decompose the relation to bring it to a
   * canonical form (i.e., a relation of the form `e1 == e2 + k`). The base
   * case for this relation (i.e., `simple_comparison_eq`) handles
   * `CompareEQInstruction`s and `CompareNEInstruction`, and recursive
   * predicates (e.g., `complex_eq`) rewrites larger expressions such as
   * `e1 + k1 == e2 + k2` into canonical the form `e1 == e2 + (k2 - k1)`.
   */

  /** Holds if (determined by this guard) `left < right + k` evaluates to `isLessThan` if this expression evaluates to `testIsTrue`. */
  pragma[inline]
  predicate comparesLt(Operand left, Operand right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(GuardValue value |
      compares_lt(valueNumber(this), left, right, k, isLessThan, value) and
      value.asBooleanValue() = testIsTrue
    )
  }

  /**
   * Holds if (determined by this guard) `op < k` evaluates to `isLessThan` if
   * this expression evaluates to `value`.
   */
  pragma[inline]
  predicate comparesLt(Operand op, int k, boolean isLessThan, GuardValue value) {
    unary_compares_lt(valueNumber(this), op, k, isLessThan, value)
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `left >= right + k`.
   */
  pragma[inline]
  predicate ensuresLt(Operand left, Operand right, int k, IRBlock block, boolean isLessThan) {
    exists(GuardValue value |
      compares_lt(valueNumber(this), left, right, k, isLessThan, value) and
      this.valueControls(block, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op < k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `op >= k`.
   */
  pragma[inline]
  predicate ensuresLt(Operand op, int k, IRBlock block, boolean isLessThan) {
    exists(GuardValue value |
      unary_compares_lt(valueNumber(this), op, k, isLessThan, value) and
      this.valueControls(block, value)
    )
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` on the edge from
   * `pred` to `succ`. If `isLessThan = false` then this implies `left >= right + k`.
   */
  pragma[inline]
  predicate ensuresLtEdge(
    Operand left, Operand right, int k, IRBlock pred, IRBlock succ, boolean isLessThan
  ) {
    exists(GuardValue value |
      compares_lt(valueNumber(this), left, right, k, isLessThan, value) and
      this.valueControlsBranchEdge(pred, succ, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op < k` must be `isLessThan` on the edge from
   * `pred` to `succ`. If `isLessThan = false` then this implies `op >= k`.
   */
  pragma[inline]
  predicate ensuresLtEdge(Operand left, int k, IRBlock pred, IRBlock succ, boolean isLessThan) {
    exists(GuardValue value |
      unary_compares_lt(valueNumber(this), left, k, isLessThan, value) and
      this.valueControlsBranchEdge(pred, succ, value)
    )
  }

  /** Holds if (determined by this guard) `left == right + k` evaluates to `areEqual` if this expression evaluates to `testIsTrue`. */
  pragma[inline]
  predicate comparesEq(Operand left, Operand right, int k, boolean areEqual, boolean testIsTrue) {
    exists(GuardValue value |
      compares_eq(valueNumber(this), left, right, k, areEqual, value) and
      value.asBooleanValue() = testIsTrue
    )
  }

  /** Holds if (determined by this guard) `op == k` evaluates to `areEqual` if this expression evaluates to `value`. */
  pragma[inline]
  predicate comparesEq(Operand op, int k, boolean areEqual, GuardValue value) {
    unary_compares_eq(valueNumber(this), op, k, areEqual, value)
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`.
   */
  pragma[inline]
  predicate ensuresEq(Operand left, Operand right, int k, IRBlock block, boolean areEqual) {
    exists(GuardValue value |
      compares_eq(valueNumber(this), left, right, k, areEqual, value) and
      this.valueControls(block, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op == k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `op != k`.
   */
  pragma[inline]
  predicate ensuresEq(Operand op, int k, IRBlock block, boolean areEqual) {
    exists(GuardValue value |
      unary_compares_eq(valueNumber(this), op, k, areEqual, value) and
      this.valueControls(block, value)
    )
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` on the edge from
   * `pred` to `succ`. If `areEqual = false` then this implies `left != right + k`.
   */
  pragma[inline]
  predicate ensuresEqEdge(
    Operand left, Operand right, int k, IRBlock pred, IRBlock succ, boolean areEqual
  ) {
    exists(GuardValue value |
      compares_eq(valueNumber(this), left, right, k, areEqual, value) and
      this.valueControlsBranchEdge(pred, succ, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op == k` must be `areEqual` on the edge from
   * `pred` to `succ`. If `areEqual = false` then this implies `op != k`.
   */
  pragma[inline]
  predicate ensuresEqEdge(Operand op, int k, IRBlock pred, IRBlock succ, boolean areEqual) {
    exists(GuardValue value |
      unary_compares_eq(valueNumber(this), op, k, areEqual, value) and
      this.valueControlsBranchEdge(pred, succ, value)
    )
  }

  /**
   * DEPRECATED: Use `controlsBranchEdge` instead.
   */
  deprecated predicate controlsEdge(IRBlock bb1, IRBlock bb2, boolean branch) {
    this.controlsBranchEdge(bb1, bb2, branch)
  }
}

cached
private module Cached {
  /**
   * A value number such that at least one of the instructions is
   * a `CompareInstruction`.
   */
  private class CompareValueNumber extends ValueNumber {
    CompareInstruction cmp;

    CompareValueNumber() { cmp = this.getAnInstruction() }

    /** Gets a `CompareInstruction` belonging to this value number. */
    CompareInstruction getCompareInstruction() { result = cmp }

    /**
     * Gets the left and right operands of a `CompareInstruction` that
     * belong to this value number.
     */
    predicate hasOperands(Operand left, Operand right) {
      left = cmp.getLeftOperand() and
      right = cmp.getRightOperand()
    }
  }

  private class CompareEQValueNumber extends CompareValueNumber {
    override CompareEQInstruction cmp;
  }

  private class CompareNEValueNumber extends CompareValueNumber {
    override CompareNEInstruction cmp;
  }

  private class CompareLTValueNumber extends CompareValueNumber {
    override CompareLTInstruction cmp;
  }

  private class CompareGTValueNumber extends CompareValueNumber {
    override CompareGTInstruction cmp;
  }

  private class CompareLEValueNumber extends CompareValueNumber {
    override CompareLEInstruction cmp;
  }

  private class CompareGEValueNumber extends CompareValueNumber {
    override CompareGEInstruction cmp;
  }

  /**
   * A value number such that at least one of the instructions provides
   * the integer value controlling a  `SwitchInstruction`.
   */
  private class SwitchConditionValueNumber extends ValueNumber {
    SwitchInstruction switch;

    pragma[nomagic]
    SwitchConditionValueNumber() { this.getAnInstruction() = switch.getExpression() }

    /** Gets an expression that belongs to this value number. */
    Operand getExpressionOperand() { result = switch.getExpressionOperand() }

    Instruction getSuccessor(CaseEdge kind) { result = switch.getSuccessor(kind) }
  }

  private class BuiltinExpectCallValueNumber extends ValueNumber {
    BuiltinExpectCallInstruction instr;

    BuiltinExpectCallValueNumber() { this.getAnInstruction() = instr }

    ValueNumber getCondition() { result.getAnInstruction() = instr.getCondition() }

    Operand getAUse() { result = instr.getAUse() }
  }

  private class LogicalNotValueNumber extends ValueNumber {
    LogicalNotInstruction instr;

    LogicalNotValueNumber() { this.getAnInstruction() = instr }

    ValueNumber getUnary() { result.getAnInstruction() = instr.getUnary() }
  }

  signature predicate sinkSig(Instruction instr);

  private module BooleanInstruction<sinkSig/1 isSink> {
    /**
     * Holds if `i1` flows to `i2` in a single step and `i2` is not an
     * instruction that produces a value of Boolean type.
     */
    private predicate stepToNonBoolean(Instruction i1, Instruction i2) {
      not i2.getResultIRType() instanceof IRBooleanType and
      (
        i2.(CopyInstruction).getSourceValue() = i1
        or
        i2.(ConvertInstruction).getUnary() = i1
        or
        i2.(BuiltinExpectCallInstruction).getArgument(0) = i1
      )
    }

    private predicate rev(Instruction instr) {
      isSink(instr)
      or
      exists(Instruction instr1 |
        rev(instr1) and
        stepToNonBoolean(instr, instr1)
      )
    }

    private predicate hasBooleanType(Instruction instr) {
      instr.getResultIRType() instanceof IRBooleanType
    }

    private predicate fwd(Instruction instr) {
      rev(instr) and
      (
        hasBooleanType(instr)
        or
        exists(Instruction instr0 |
          fwd(instr0) and
          stepToNonBoolean(instr0, instr)
        )
      )
    }

    private predicate prunedStep(Instruction i1, Instruction i2) {
      fwd(i1) and
      fwd(i2) and
      stepToNonBoolean(i1, i2)
    }

    private predicate stepsPlus(Instruction i1, Instruction i2) =
      doublyBoundedFastTC(prunedStep/2, hasBooleanType/1, isSink/1)(i1, i2)

    /**
     * Gets the Boolean-typed instruction that defines `instr` before any
     * integer conversions are applied, if any.
     */
    Instruction get(Instruction instr) {
      isSink(instr) and
      (
        result = instr
        or
        stepsPlus(result, instr)
      ) and
      hasBooleanType(result)
    }
  }

  private predicate isUnaryComparesEqLeft(Instruction instr) {
    unary_compares_eq(_, instr.getAUse(), 0, _, _)
  }

  /**
   * Holds if `left == right + k` is `areEqual` given that test is `testIsTrue`.
   *
   * Beware making mistaken logical implications here relating `areEqual` and `value`.
   */
  cached
  predicate compares_eq(
    ValueNumber test, Operand left, Operand right, int k, boolean areEqual, GuardValue value
  ) {
    /* The simple case where the test *is* the comparison so areEqual = testIsTrue xor eq. */
    exists(GuardValue v | simple_comparison_eq(test, left, right, k, v) |
      areEqual = true and value = v
      or
      areEqual = false and value = v.getDualValue()
    )
    or
    // I think this is handled by forwarding in controlsBlock.
    //or
    //logical_comparison_eq(test, left, right, k, areEqual, testIsTrue)
    /* a == b + k => b == a - k */
    exists(int mk | k = -mk | compares_eq(test, right, left, mk, areEqual, value))
    or
    complex_eq(test, left, right, k, areEqual, value)
    or
    /* (x is true => (left == right + k)) => (!x is false => (left == right + k)) */
    exists(GuardValue dual | value = dual.getDualValue() |
      compares_eq(test.(LogicalNotValueNumber).getUnary(), left, right, k, areEqual, dual)
    )
    or
    compares_eq(test.(BuiltinExpectCallValueNumber).getCondition(), left, right, k, areEqual, value)
    or
    exists(Operand l, GuardValue bv |
      // 1. test = value -> int(l) = 0 is !bv
      unary_compares_eq(test, l, 0, bv.asBooleanValue().booleanNot(), value) and
      // 2. l = bv -> left + right is areEqual
      compares_eq(valueNumber(BooleanInstruction<isUnaryComparesEqLeft/1>::get(l.getDef())), left,
        right, k, areEqual, bv)
      // We want this to hold:
      // `test = value -> left + right is areEqual`
      // Applying 2 we need to show:
      // `test = value -> l = bv`
      // And `l = bv` holds by `int(l) = 0 is !bv`
    )
  }

  /**
   * Holds if `op == k` is `areEqual` given that `test` is equal to `value`.
   */
  cached
  predicate unary_compares_eq(
    ValueNumber test, Operand op, int k, boolean areEqual, GuardValue value
  ) {
    /* The simple case where the test *is* the comparison so areEqual = testIsTrue xor eq. */
    exists(GuardValue v | unary_simple_comparison_eq(test, op, k, v) |
      areEqual = true and value = v
      or
      areEqual = false and value = v.getDualValue()
    )
    or
    unary_complex_eq(test, op, k, areEqual, value)
    or
    /* (x is true => (op == k)) => (!x is false => (op == k)) */
    exists(GuardValue dual |
      value = dual.getDualValue() and
      unary_compares_eq(test.(LogicalNotValueNumber).getUnary(), op, k, areEqual, dual)
    )
    or
    // ((test is `areEqual` => op == const + k2) and const == `k1`) =>
    // test is `areEqual` => op == k1 + k2
    exists(int k1, int k2, Instruction const |
      compares_eq(test, op, const.getAUse(), k2, areEqual, value) and
      int_value(const) = k1 and
      k = k1 + k2
    )
    or
    // See argument for why this is correct in compares_eq
    exists(Operand l, GuardValue bv |
      unary_compares_eq(test, l, 0, bv.asBooleanValue().booleanNot(), value) and
      unary_compares_eq(valueNumber(BooleanInstruction<isUnaryComparesEqLeft/1>::get(l.getDef())),
        op, k, areEqual, bv)
    )
    or
    unary_compares_eq(test.(BuiltinExpectCallValueNumber).getCondition(), op, k, areEqual, value)
    or
    exists(Cpp::BinaryLogicalOperation logical, Cpp::Expr operand, boolean b |
      test.getAnInstruction().getUnconvertedResultExpression() = logical and
      op.getDef().getUnconvertedResultExpression() = operand and
      logical.impliesValue(operand, b, value.asBooleanValue())
    |
      k = 1 and
      areEqual = b
      or
      k = 0 and
      areEqual = b.booleanNot()
    )
  }

  /** Rearrange various simple comparisons into `left == right + k` form. */
  private predicate simple_comparison_eq(
    CompareValueNumber cmp, Operand left, Operand right, int k, GuardValue value
  ) {
    cmp instanceof CompareEQValueNumber and
    cmp.hasOperands(left, right) and
    k = 0 and
    value.asBooleanValue() = true
    or
    cmp instanceof CompareNEValueNumber and
    cmp.hasOperands(left, right) and
    k = 0 and
    value.asBooleanValue() = false
  }

  /**
   * Holds if `op` is an operand that is eventually used in a unary comparison
   * with a constant.
   */
  private predicate mayBranchOn(Instruction instr) {
    exists(ConditionalBranchInstruction branch | branch.getCondition() = instr)
    or
    // If `!x` is a relevant unary comparison then so is `x`.
    exists(LogicalNotInstruction logicalNot |
      mayBranchOn(logicalNot) and
      logicalNot.getUnary() = instr
    )
    or
    // If `y` is a relevant unary comparison and `y = x` then so is `x`.
    exists(CopyInstruction copy |
      mayBranchOn(copy) and
      instr = copy.getSourceValue()
    )
    or
    // If phi(x1, x2) is a relevant unary comparison then so are `x1` and `x2`.
    exists(PhiInstruction phi |
      mayBranchOn(phi) and
      instr = phi.getAnInput()
    )
    or
    // If `__builtin_expect(x)` is a relevant unary comparison then so is `x`.
    exists(BuiltinExpectCallInstruction call |
      mayBranchOn(call) and
      instr = call.getCondition()
    )
  }

  /** Rearrange various simple comparisons into `op == k` form. */
  private predicate unary_simple_comparison_eq(ValueNumber test, Operand op, int k, GuardValue value) {
    exists(SwitchConditionValueNumber condition, CaseEdge edge |
      condition = test and
      op = condition.getExpressionOperand() and
      value.asIntValue() = k and
      edge.getValue().toInt() = k and
      exists(condition.getSuccessor(edge))
    )
    or
    exists(Instruction const | int_value(const) = k |
      value.asBooleanValue() = true and
      test.(CompareEQValueNumber).hasOperands(op, const.getAUse())
      or
      value.asBooleanValue() = false and
      test.(CompareNEValueNumber).hasOperands(op, const.getAUse())
    )
    or
    exists(GuardValue bv |
      bv = value and
      mayBranchOn(op.getDef()) and
      op = test.getAUse()
    |
      k = 0 and
      bv.asBooleanValue() = false
      or
      k = 1 and
      bv.asBooleanValue() = true
    )
  }

  private predicate isBuiltInExpectArg(Instruction instr) {
    instr = any(BuiltinExpectCallInstruction buildinExpect).getArgument(0)
  }

  /** A call to the builtin operation `__builtin_expect`. */
  private class BuiltinExpectCallInstruction extends CallInstruction {
    BuiltinExpectCallInstruction() { this.getStaticCallTarget().hasName("__builtin_expect") }

    /** Gets the condition of this call. */
    Instruction getCondition() {
      result = BooleanInstruction<isBuiltInExpectArg/1>::get(this.getArgument(0))
    }
  }

  private predicate complex_eq(
    ValueNumber cmp, Operand left, Operand right, int k, boolean areEqual, GuardValue value
  ) {
    sub_eq(cmp, left, right, k, areEqual, value)
    or
    add_eq(cmp, left, right, k, areEqual, value)
  }

  private predicate unary_complex_eq(
    ValueNumber test, Operand op, int k, boolean areEqual, GuardValue value
  ) {
    unary_sub_eq(test, op, k, areEqual, value)
    or
    unary_add_eq(test, op, k, areEqual, value)
  }

  /*
   * Simplification of inequality expressions
   * Simplify conditions in the source to the canonical form l < r + k.
   */

  /** Holds if `left < right + k` evaluates to `isLt` given that test is `value`. */
  cached
  predicate compares_lt(
    ValueNumber test, Operand left, Operand right, int k, boolean isLt, GuardValue value
  ) {
    /* In the simple case, the test is the comparison, so isLt = testIsTrue */
    simple_comparison_lt(test, left, right, k) and
    value.asBooleanValue() = isLt
    or
    complex_lt(test, left, right, k, isLt, value)
    or
    /* (not (left < right + k)) => (left >= right + k) */
    exists(boolean isGe | isLt = isGe.booleanNot() | compares_ge(test, left, right, k, isGe, value))
    or
    /* (x is true => (left < right + k)) => (!x is false => (left < right + k)) */
    exists(GuardValue dual | value = dual.getDualValue() |
      compares_lt(test.(LogicalNotValueNumber).getUnary(), left, right, k, isLt, dual)
    )
    or
    compares_lt(test.(BuiltinExpectCallValueNumber).getCondition(), left, right, k, isLt, value)
    or
    // See argument for why this is correct in compares_eq
    exists(Operand l, GuardValue bv |
      unary_compares_eq(test, l, 0, bv.asBooleanValue().booleanNot(), value) and
      compares_lt(valueNumber(BooleanInstruction<isUnaryComparesEqLeft/1>::get(l.getDef())), left,
        right, k, isLt, bv)
    )
  }

  /** Holds if `op < k` evaluates to `isLt` given that `test` evaluates to `value`. */
  cached
  predicate unary_compares_lt(ValueNumber test, Operand op, int k, boolean isLt, GuardValue value) {
    unary_simple_comparison_lt(test, op, k, isLt, value)
    or
    complex_lt(test, op, k, isLt, value)
    or
    /* (x is true => (op < k)) => (!x is false => (op < k)) */
    exists(GuardValue dual | value = dual.getDualValue() |
      unary_compares_lt(test.(LogicalNotValueNumber).getUnary(), op, k, isLt, dual)
    )
    or
    exists(int k1, int k2, Instruction const |
      compares_lt(test, op, const.getAUse(), k2, isLt, value) and
      int_value(const) = k1 and
      k = k1 + k2
    )
    or
    unary_compares_lt(test.(BuiltinExpectCallValueNumber).getCondition(), op, k, isLt, value)
    or
    // See argument for why this is correct in compares_eq
    exists(Operand l, GuardValue bv |
      unary_compares_eq(test, l, 0, bv.asBooleanValue().booleanNot(), value) and
      unary_compares_lt(valueNumber(BooleanInstruction<isUnaryComparesEqLeft/1>::get(l.getDef())),
        op, k, isLt, bv)
    )
  }

  /** `(a < b + k) => (b > a - k) => (b >= a + (1-k))` */
  private predicate compares_ge(
    ValueNumber test, Operand left, Operand right, int k, boolean isGe, GuardValue value
  ) {
    exists(int onemk | k = 1 - onemk | compares_lt(test, right, left, onemk, isGe, value))
  }

  /** Rearrange various simple comparisons into `left < right + k` form. */
  private predicate simple_comparison_lt(CompareValueNumber cmp, Operand left, Operand right, int k) {
    cmp.hasOperands(left, right) and
    cmp instanceof CompareLTValueNumber and
    k = 0
    or
    cmp.hasOperands(left, right) and
    cmp instanceof CompareLEValueNumber and
    k = 1
    or
    cmp.hasOperands(right, left) and
    cmp instanceof CompareGTValueNumber and
    k = 0
    or
    cmp.hasOperands(right, left) and
    cmp instanceof CompareGEValueNumber and
    k = 1
  }

  /** Rearrange various simple comparisons into `op < k` form. */
  private predicate unary_simple_comparison_lt(
    SwitchConditionValueNumber test, Operand op, int k, boolean isLt, GuardValue value
  ) {
    exists(string minValue, string maxValue |
      test.getExpressionOperand() = op and
      exists(test.getSuccessor(EdgeKind::caseEdge(minValue, maxValue))) and
      minValue < maxValue
    |
      // op <= k => op < k - 1
      isLt = true and
      maxValue.toInt() = k - 1 and
      value.isIntRange(k - 1, true)
      or
      isLt = false and
      minValue.toInt() = k and
      value.isIntRange(k, false)
    )
  }

  private predicate complex_lt(
    ValueNumber cmp, Operand left, Operand right, int k, boolean isLt, GuardValue value
  ) {
    sub_lt(cmp, left, right, k, isLt, value)
    or
    add_lt(cmp, left, right, k, isLt, value)
  }

  private predicate complex_lt(ValueNumber test, Operand left, int k, boolean isLt, GuardValue value) {
    sub_lt(test, left, k, isLt, value)
    or
    add_lt(test, left, k, isLt, value)
  }

  // left - x < right + c => left < right + (c+x)
  // left < (right - x) + c => left < right + (c-x)
  private predicate sub_lt(
    ValueNumber cmp, Operand left, Operand right, int k, boolean isLt, GuardValue value
  ) {
    exists(SubInstruction lhs, int c, int x |
      compares_lt(cmp, lhs.getAUse(), right, c, isLt, value) and
      left = lhs.getLeftOperand() and
      x = int_value(lhs.getRight()) and
      k = c + x
    )
    or
    exists(SubInstruction rhs, int c, int x |
      compares_lt(cmp, left, rhs.getAUse(), c, isLt, value) and
      right = rhs.getLeftOperand() and
      x = int_value(rhs.getRight()) and
      k = c - x
    )
    or
    exists(PointerSubInstruction lhs, int c, int x |
      compares_lt(cmp, lhs.getAUse(), right, c, isLt, value) and
      left = lhs.getLeftOperand() and
      x = int_value(lhs.getRight()) and
      k = c + x
    )
    or
    exists(PointerSubInstruction rhs, int c, int x |
      compares_lt(cmp, left, rhs.getAUse(), c, isLt, value) and
      right = rhs.getLeftOperand() and
      x = int_value(rhs.getRight()) and
      k = c - x
    )
  }

  private predicate sub_lt(ValueNumber test, Operand left, int k, boolean isLt, GuardValue value) {
    exists(SubInstruction lhs, int c, int x |
      unary_compares_lt(test, lhs.getAUse(), c, isLt, value) and
      left = lhs.getLeftOperand() and
      x = int_value(lhs.getRight()) and
      k = c + x
    )
    or
    exists(PointerSubInstruction lhs, int c, int x |
      unary_compares_lt(test, lhs.getAUse(), c, isLt, value) and
      left = lhs.getLeftOperand() and
      x = int_value(lhs.getRight()) and
      k = c + x
    )
  }

  // left + x < right + c => left < right + (c-x)
  // left < (right + x) + c => left < right + (c+x)
  private predicate add_lt(
    ValueNumber cmp, Operand left, Operand right, int k, boolean isLt, GuardValue value
  ) {
    exists(AddInstruction lhs, int c, int x |
      compares_lt(cmp, lhs.getAUse(), right, c, isLt, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
    or
    exists(AddInstruction rhs, int c, int x |
      compares_lt(cmp, left, rhs.getAUse(), c, isLt, value) and
      (
        right = rhs.getLeftOperand() and x = int_value(rhs.getRight())
        or
        right = rhs.getRightOperand() and x = int_value(rhs.getLeft())
      ) and
      k = c + x
    )
    or
    exists(PointerAddInstruction lhs, int c, int x |
      compares_lt(cmp, lhs.getAUse(), right, c, isLt, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
    or
    exists(PointerAddInstruction rhs, int c, int x |
      compares_lt(cmp, left, rhs.getAUse(), c, isLt, value) and
      (
        right = rhs.getLeftOperand() and x = int_value(rhs.getRight())
        or
        right = rhs.getRightOperand() and x = int_value(rhs.getLeft())
      ) and
      k = c + x
    )
  }

  private predicate add_lt(ValueNumber test, Operand left, int k, boolean isLt, GuardValue value) {
    exists(AddInstruction lhs, int c, int x |
      unary_compares_lt(test, lhs.getAUse(), c, isLt, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
    or
    exists(PointerAddInstruction lhs, int c, int x |
      unary_compares_lt(test, lhs.getAUse(), c, isLt, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
  }

  // left - x == right + c => left == right + (c+x)
  // left == (right - x) + c => left == right + (c-x)
  private predicate sub_eq(
    ValueNumber cmp, Operand left, Operand right, int k, boolean areEqual, GuardValue value
  ) {
    exists(SubInstruction lhs, int c, int x |
      compares_eq(cmp, lhs.getAUse(), right, c, areEqual, value) and
      left = lhs.getLeftOperand() and
      x = int_value(lhs.getRight()) and
      k = c + x
    )
    or
    exists(SubInstruction rhs, int c, int x |
      compares_eq(cmp, left, rhs.getAUse(), c, areEqual, value) and
      right = rhs.getLeftOperand() and
      x = int_value(rhs.getRight()) and
      k = c - x
    )
    or
    exists(PointerSubInstruction lhs, int c, int x |
      compares_eq(cmp, lhs.getAUse(), right, c, areEqual, value) and
      left = lhs.getLeftOperand() and
      x = int_value(lhs.getRight()) and
      k = c + x
    )
    or
    exists(PointerSubInstruction rhs, int c, int x |
      compares_eq(cmp, left, rhs.getAUse(), c, areEqual, value) and
      right = rhs.getLeftOperand() and
      x = int_value(rhs.getRight()) and
      k = c - x
    )
  }

  // op - x == c => op == (c+x)
  private predicate unary_sub_eq(
    ValueNumber test, Operand op, int k, boolean areEqual, GuardValue value
  ) {
    exists(SubInstruction sub, int c, int x |
      unary_compares_eq(test, sub.getAUse(), c, areEqual, value) and
      op = sub.getLeftOperand() and
      x = int_value(sub.getRight()) and
      k = c + x
    )
    or
    exists(PointerSubInstruction sub, int c, int x |
      unary_compares_eq(test, sub.getAUse(), c, areEqual, value) and
      op = sub.getLeftOperand() and
      x = int_value(sub.getRight()) and
      k = c + x
    )
  }

  // left + x == right + c => left == right + (c-x)
  // left == (right + x) + c => left == right + (c+x)
  private predicate add_eq(
    ValueNumber cmp, Operand left, Operand right, int k, boolean areEqual, GuardValue value
  ) {
    exists(AddInstruction lhs, int c, int x |
      compares_eq(cmp, lhs.getAUse(), right, c, areEqual, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
    or
    exists(AddInstruction rhs, int c, int x |
      compares_eq(cmp, left, rhs.getAUse(), c, areEqual, value) and
      (
        right = rhs.getLeftOperand() and x = int_value(rhs.getRight())
        or
        right = rhs.getRightOperand() and x = int_value(rhs.getLeft())
      ) and
      k = c + x
    )
    or
    exists(PointerAddInstruction lhs, int c, int x |
      compares_eq(cmp, lhs.getAUse(), right, c, areEqual, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
    or
    exists(PointerAddInstruction rhs, int c, int x |
      compares_eq(cmp, left, rhs.getAUse(), c, areEqual, value) and
      (
        right = rhs.getLeftOperand() and x = int_value(rhs.getRight())
        or
        right = rhs.getRightOperand() and x = int_value(rhs.getLeft())
      ) and
      k = c + x
    )
  }

  // left + x == right + c => left == right + (c-x)
  private predicate unary_add_eq(
    ValueNumber test, Operand left, int k, boolean areEqual, GuardValue value
  ) {
    exists(AddInstruction lhs, int c, int x |
      unary_compares_eq(test, lhs.getAUse(), c, areEqual, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
    or
    exists(PointerAddInstruction lhs, int c, int x |
      unary_compares_eq(test, lhs.getAUse(), c, areEqual, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
  }

  private class IntegerOrPointerConstantInstruction extends ConstantInstruction {
    IntegerOrPointerConstantInstruction() {
      this instanceof IntegerConstantInstruction or
      this instanceof PointerConstantInstruction
    }
  }

  /** The int value of integer constant expression. */
  private int int_value(IntegerOrPointerConstantInstruction i) { result = i.getValue().toInt() }
}

private import Cached

/**
 * Holds if `left < right + k` evaluates to `isLt` given that some guard
 * evaluates to `value`.
 *
 * To find the specific guard that performs the comparison
 * use `IRGuards.comparesLt`.
 */
predicate comparesLt(Operand left, Operand right, int k, boolean isLt, GuardValue value) {
  compares_lt(_, left, right, k, isLt, value)
}

/**
 * Holds if `left = right + k` evaluates to `isLt` given that some guard
 * evaluates to `value`.
 *
 * To find the specific guard that performs the comparison
 * use `IRGuards.comparesEq`.
 */
predicate comparesEq(Operand left, Operand right, int k, boolean isLt, GuardValue value) {
  compares_eq(_, left, right, k, isLt, value)
}
