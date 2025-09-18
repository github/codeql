/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 */

import cpp as Cpp
import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.implementation.raw.internal.TranslatedExpr
private import semmle.code.cpp.ir.implementation.raw.internal.InstructionTag

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
  MatchValue() {
    exists(this.asIntValue())
    or
    this.asConstantValue().isRange(_, _)
  }

  /** Gets the case. */
  CaseEdge getCase() {
    result.getValue().toInt() = this.asIntValue()
    or
    exists(string minValue, string maxValue |
      result.getMinValue() = minValue and
      result.getMaxValue() = maxValue and
      this.asConstantValue().isRange(minValue, maxValue)
    )
  }
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
    compares_lt(valueNumber(this), op, k, isLessThan, value)
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
      compares_lt(valueNumber(this), op, k, isLessThan, value) and
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
      compares_lt(valueNumber(this), left, k, isLessThan, value) and
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
    ValueNumber test, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
  ) {
    /* The simple case where the test *is* the comparison so areEqual = testIsTrue xor eq. */
    exists(AbstractValue v | simple_comparison_eq(test, left, right, k, v) |
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
    exists(AbstractValue dual | value = dual.getDualValue() |
      compares_eq(test.(LogicalNotValueNumber).getUnary(), left, right, k, areEqual, dual)
    )
    or
    compares_eq(test.(BuiltinExpectCallValueNumber).getCondition(), left, right, k, areEqual, value)
    or
    exists(Operand l, BooleanValue bv |
      // 1. test = value -> int(l) = 0 is !bv
      unary_compares_eq(test, l, 0, bv.getValue().booleanNot(), value) and
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
    ValueNumber test, Operand op, int k, boolean areEqual, AbstractValue value
  ) {
    /* The simple case where the test *is* the comparison so areEqual = testIsTrue xor eq. */
    exists(AbstractValue v | unary_simple_comparison_eq(test, op, k, v) |
      areEqual = true and value = v
      or
      areEqual = false and value = v.getDualValue()
    )
    or
    unary_complex_eq(test, op, k, areEqual, value)
    or
    /* (x is true => (op == k)) => (!x is false => (op == k)) */
    exists(AbstractValue dual |
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
    exists(Operand l, BooleanValue bv |
      unary_compares_eq(test, l, 0, bv.getValue().booleanNot(), value) and
      unary_compares_eq(valueNumber(BooleanInstruction<isUnaryComparesEqLeft/1>::get(l.getDef())),
        op, k, areEqual, bv)
    )
    or
    unary_compares_eq(test.(BuiltinExpectCallValueNumber).getCondition(), op, k, areEqual, value)
    or
    exists(BinaryLogicalOperation logical, Expr operand, boolean b |
      test.getAnInstruction().getUnconvertedResultExpression() = logical and
      op.getDef().getUnconvertedResultExpression() = operand and
      logical.impliesValue(operand, b, value.(BooleanValue).getValue())
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
    CompareValueNumber cmp, Operand left, Operand right, int k, AbstractValue value
  ) {
    cmp instanceof CompareEQValueNumber and
    cmp.hasOperands(left, right) and
    k = 0 and
    value.(BooleanValue).getValue() = true
    or
    cmp instanceof CompareNEValueNumber and
    cmp.hasOperands(left, right) and
    k = 0 and
    value.(BooleanValue).getValue() = false
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
  private predicate unary_simple_comparison_eq(
    ValueNumber test, Operand op, int k, AbstractValue value
  ) {
    exists(CaseEdge case, SwitchConditionValueNumber condition |
      condition = test and
      op = condition.getExpressionOperand() and
      case = value.(MatchValue).getCase() and
      exists(condition.getSuccessor(case)) and
      case.getValue().toInt() = k
    )
    or
    exists(Instruction const | int_value(const) = k |
      value.(BooleanValue).getValue() = true and
      test.(CompareEQValueNumber).hasOperands(op, const.getAUse())
      or
      value.(BooleanValue).getValue() = false and
      test.(CompareNEValueNumber).hasOperands(op, const.getAUse())
    )
    or
    exists(BooleanValue bv |
      bv = value and
      mayBranchOn(op.getDef()) and
      op = test.getAUse()
    |
      k = 0 and
      bv.getValue() = false
      or
      k = 1 and
      bv.getValue() = true
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
    ValueNumber cmp, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
  ) {
    sub_eq(cmp, left, right, k, areEqual, value)
    or
    add_eq(cmp, left, right, k, areEqual, value)
  }

  private predicate unary_complex_eq(
    ValueNumber test, Operand op, int k, boolean areEqual, AbstractValue value
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
    ValueNumber test, Operand left, Operand right, int k, boolean isLt, AbstractValue value
  ) {
    /* In the simple case, the test is the comparison, so isLt = testIsTrue */
    simple_comparison_lt(test, left, right, k) and
    value.(BooleanValue).getValue() = isLt
    or
    complex_lt(test, left, right, k, isLt, value)
    or
    /* (not (left < right + k)) => (left >= right + k) */
    exists(boolean isGe | isLt = isGe.booleanNot() | compares_ge(test, left, right, k, isGe, value))
    or
    /* (x is true => (left < right + k)) => (!x is false => (left < right + k)) */
    exists(AbstractValue dual | value = dual.getDualValue() |
      compares_lt(test.(LogicalNotValueNumber).getUnary(), left, right, k, isLt, dual)
    )
    or
    compares_lt(test.(BuiltinExpectCallValueNumber).getCondition(), left, right, k, isLt, value)
    or
    // See argument for why this is correct in compares_eq
    exists(Operand l, BooleanValue bv |
      unary_compares_eq(test, l, 0, bv.getValue().booleanNot(), value) and
      compares_lt(valueNumber(BooleanInstruction<isUnaryComparesEqLeft/1>::get(l.getDef())), left,
        right, k, isLt, bv)
    )
  }

  /** Holds if `op < k` evaluates to `isLt` given that `test` evaluates to `value`. */
  cached
  predicate compares_lt(ValueNumber test, Operand op, int k, boolean isLt, AbstractValue value) {
    unary_simple_comparison_lt(test, op, k, isLt, value)
    or
    complex_lt(test, op, k, isLt, value)
    or
    /* (x is true => (op < k)) => (!x is false => (op < k)) */
    exists(AbstractValue dual | value = dual.getDualValue() |
      compares_lt(test.(LogicalNotValueNumber).getUnary(), op, k, isLt, dual)
    )
    or
    exists(int k1, int k2, Instruction const |
      compares_lt(test, op, const.getAUse(), k2, isLt, value) and
      int_value(const) = k1 and
      k = k1 + k2
    )
    or
    compares_lt(test.(BuiltinExpectCallValueNumber).getCondition(), op, k, isLt, value)
    or
    // See argument for why this is correct in compares_eq
    exists(Operand l, BooleanValue bv |
      unary_compares_eq(test, l, 0, bv.getValue().booleanNot(), value) and
      compares_lt(valueNumber(BooleanInstruction<isUnaryComparesEqLeft/1>::get(l.getDef())), op, k,
        isLt, bv)
    )
  }

  /** `(a < b + k) => (b > a - k) => (b >= a + (1-k))` */
  private predicate compares_ge(
    ValueNumber test, Operand left, Operand right, int k, boolean isGe, AbstractValue value
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
    SwitchConditionValueNumber test, Operand op, int k, boolean isLt, AbstractValue value
  ) {
    exists(CaseEdge case |
      test.getExpressionOperand() = op and
      case = value.(MatchValue).getCase() and
      exists(test.getSuccessor(case)) and
      case.getMaxValue() > case.getMinValue()
    |
      // op <= k => op < k - 1
      isLt = true and
      case.getMaxValue().toInt() = k - 1
      or
      isLt = false and
      case.getMinValue().toInt() = k
    )
  }

  private predicate complex_lt(
    ValueNumber cmp, Operand left, Operand right, int k, boolean isLt, AbstractValue value
  ) {
    sub_lt(cmp, left, right, k, isLt, value)
    or
    add_lt(cmp, left, right, k, isLt, value)
  }

  private predicate complex_lt(
    ValueNumber test, Operand left, int k, boolean isLt, AbstractValue value
  ) {
    sub_lt(test, left, k, isLt, value)
    or
    add_lt(test, left, k, isLt, value)
  }

  // left - x < right + c => left < right + (c+x)
  // left < (right - x) + c => left < right + (c-x)
  private predicate sub_lt(
    ValueNumber cmp, Operand left, Operand right, int k, boolean isLt, AbstractValue value
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

  private predicate sub_lt(ValueNumber test, Operand left, int k, boolean isLt, AbstractValue value) {
    exists(SubInstruction lhs, int c, int x |
      compares_lt(test, lhs.getAUse(), c, isLt, value) and
      left = lhs.getLeftOperand() and
      x = int_value(lhs.getRight()) and
      k = c + x
    )
    or
    exists(PointerSubInstruction lhs, int c, int x |
      compares_lt(test, lhs.getAUse(), c, isLt, value) and
      left = lhs.getLeftOperand() and
      x = int_value(lhs.getRight()) and
      k = c + x
    )
  }

  // left + x < right + c => left < right + (c-x)
  // left < (right + x) + c => left < right + (c+x)
  private predicate add_lt(
    ValueNumber cmp, Operand left, Operand right, int k, boolean isLt, AbstractValue value
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

  private predicate add_lt(ValueNumber test, Operand left, int k, boolean isLt, AbstractValue value) {
    exists(AddInstruction lhs, int c, int x |
      compares_lt(test, lhs.getAUse(), c, isLt, value) and
      (
        left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
        or
        left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
      ) and
      k = c - x
    )
    or
    exists(PointerAddInstruction lhs, int c, int x |
      compares_lt(test, lhs.getAUse(), c, isLt, value) and
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
    ValueNumber cmp, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
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
    ValueNumber test, Operand op, int k, boolean areEqual, AbstractValue value
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
    ValueNumber cmp, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
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
    ValueNumber test, Operand left, int k, boolean areEqual, AbstractValue value
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
predicate comparesLt(Operand left, Operand right, int k, boolean isLt, AbstractValue value) {
  compares_lt(_, left, right, k, isLt, value)
}

/**
 * Holds if `left = right + k` evaluates to `isLt` given that some guard
 * evaluates to `value`.
 *
 * To find the specific guard that performs the comparison
 * use `IRGuards.comparesEq`.
 */
predicate comparesEq(Operand left, Operand right, int k, boolean isLt, AbstractValue value) {
  compares_eq(_, left, right, k, isLt, value)
}
