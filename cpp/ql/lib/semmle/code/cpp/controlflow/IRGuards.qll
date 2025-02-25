/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 */

import cpp
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

private newtype TAbstractValue =
  TBooleanValue(boolean b) { b = true or b = false } or
  TMatchValue(CaseEdge c)

/**
 * An abstract value. This is either a boolean value, or a `switch` case.
 */
abstract class AbstractValue extends TAbstractValue {
  /** Gets an abstract value that represents the dual of this value, if any. */
  abstract AbstractValue getDualValue();

  /** Gets a textual representation of this abstract value. */
  abstract string toString();
}

/** A Boolean value. */
class BooleanValue extends AbstractValue, TBooleanValue {
  /** Gets the underlying Boolean value. */
  boolean getValue() { this = TBooleanValue(result) }

  override BooleanValue getDualValue() { result.getValue() = this.getValue().booleanNot() }

  override string toString() { result = this.getValue().toString() }
}

/** A value that represents a match against a specific `switch` case. */
class MatchValue extends AbstractValue, TMatchValue {
  /** Gets the case. */
  CaseEdge getCase() { this = TMatchValue(result) }

  override MatchValue getDualValue() {
    // A `MatchValue` has no dual.
    none()
  }

  override string toString() { result = this.getCase().toString() }
}

/**
 * A Boolean condition in the AST that guards one or more basic blocks. This includes
 * operands of logical operators but not switch statements.
 */
abstract private class GuardConditionImpl extends Expr {
  /**
   * Holds if this condition controls `controlled`, meaning that `controlled` is only
   * entered if the value of this condition is `v`.
   *
   * For details on what "controls" mean, see the QLDoc for `controls`.
   */
  abstract predicate valueControls(BasicBlock controlled, AbstractValue v);

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
  final predicate controls(BasicBlock controlled, boolean testIsTrue) {
    this.valueControls(controlled, any(BooleanValue bv | bv.getValue() = testIsTrue))
  }

  /**
   * Holds if (determined by this guard) `left < right + k` evaluates to `isLessThan` if this
   * expression evaluates to `testIsTrue`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue);

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `left >= right + k`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan);

  /**
   * Holds if (determined by this guard) `e < k` evaluates to `isLessThan` if
   * this expression evaluates to `value`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate comparesLt(Expr e, int k, boolean isLessThan, AbstractValue value);

  /**
   * Holds if (determined by this guard) `e < k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `e >= k`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate ensuresLt(Expr e, int k, BasicBlock block, boolean isLessThan);

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
  abstract predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue);

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean areEqual);

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
  abstract predicate comparesEq(Expr e, int k, boolean areEqual, AbstractValue value);

  /**
   * Holds if (determined by this guard) `e == k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `e != k`. Note that there's a 4-argument
   * ("unary") and a 5-argument ("binary") version of this predicate (see `comparesEq`).
   */
  pragma[inline]
  abstract predicate ensuresEq(Expr e, int k, BasicBlock block, boolean areEqual);
}

final class GuardCondition = GuardConditionImpl;

/**
 * A binary logical operator in the AST that guards one or more basic blocks.
 */
private class GuardConditionFromBinaryLogicalOperator extends GuardConditionImpl {
  GuardConditionFromBinaryLogicalOperator() {
    this.(BinaryLogicalOperation).getAnOperand() instanceof GuardCondition
  }

  override predicate valueControls(BasicBlock controlled, AbstractValue v) {
    exists(BinaryLogicalOperation binop, GuardCondition lhs, GuardCondition rhs |
      this = binop and
      lhs = binop.getLeftOperand() and
      rhs = binop.getRightOperand() and
      lhs.valueControls(controlled, v) and
      rhs.valueControls(controlled, v)
    )
  }

  override predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(boolean partIsTrue, GuardCondition part |
      this.(BinaryLogicalOperation).impliesValue(part, partIsTrue, testIsTrue)
    |
      part.comparesLt(left, right, k, isLessThan, partIsTrue)
    )
  }

  override predicate comparesLt(Expr e, int k, boolean isLessThan, AbstractValue value) {
    exists(BooleanValue partValue, GuardCondition part |
      this.(BinaryLogicalOperation)
          .impliesValue(part, partValue.getValue(), value.(BooleanValue).getValue())
    |
      part.comparesLt(e, k, isLessThan, partValue)
    )
  }

  pragma[inline]
  override predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(boolean testIsTrue |
      this.comparesLt(left, right, k, isLessThan, testIsTrue) and this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresLt(Expr e, int k, BasicBlock block, boolean isLessThan) {
    exists(AbstractValue value |
      this.comparesLt(e, k, isLessThan, value) and this.valueControls(block, value)
    )
  }

  override predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    exists(boolean partIsTrue, GuardCondition part |
      this.(BinaryLogicalOperation).impliesValue(part, partIsTrue, testIsTrue)
    |
      part.comparesEq(left, right, k, areEqual, partIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean areEqual) {
    exists(boolean testIsTrue |
      this.comparesEq(left, right, k, areEqual, testIsTrue) and this.controls(block, testIsTrue)
    )
  }

  override predicate comparesEq(Expr e, int k, boolean areEqual, AbstractValue value) {
    exists(BooleanValue partValue, GuardCondition part |
      this.(BinaryLogicalOperation)
          .impliesValue(part, partValue.getValue(), value.(BooleanValue).getValue())
    |
      part.comparesEq(e, k, areEqual, partValue)
    )
  }

  pragma[inline]
  override predicate ensuresEq(Expr e, int k, BasicBlock block, boolean areEqual) {
    exists(AbstractValue value |
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
private predicate controlsBlock(IRGuardCondition ir, BasicBlock controlled, AbstractValue v) {
  exists(IRBlock irb |
    ir.valueControls(irb, v) and
    nonExcludedIRAndBasicBlock(irb, controlled) and
    not isUnreachedBlock(irb)
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
    exists(NotExpr notExpr |
      this = notExpr.getOperand() and
      ir.getUnconvertedResultExpression() = notExpr
    )
  }

  override predicate valueControls(BasicBlock controlled, AbstractValue v) {
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    controlsBlock(ir, controlled, v.getDualValue())
  }

  pragma[inline]
  override predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue.booleanNot())
    )
  }

  pragma[inline]
  override predicate comparesLt(Expr e, int k, boolean isLessThan, AbstractValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value.getDualValue())
    )
  }

  pragma[inline]
  override predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue.booleanNot()) and
      this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresLt(Expr e, int k, BasicBlock block, boolean isLessThan) {
    exists(Instruction i, AbstractValue value |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value.getDualValue()) and
      this.valueControls(block, value)
    )
  }

  pragma[inline]
  override predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue.booleanNot())
    )
  }

  pragma[inline]
  override predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean areEqual) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue.booleanNot()) and
      this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate comparesEq(Expr e, int k, boolean areEqual, AbstractValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesEq(i.getAUse(), k, areEqual, value.getDualValue())
    )
  }

  pragma[inline]
  override predicate ensuresEq(Expr e, int k, BasicBlock block, boolean areEqual) {
    exists(Instruction i, AbstractValue value |
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

  GuardConditionFromIR() { this = ir.getUnconvertedResultExpression() }

  override predicate valueControls(BasicBlock controlled, AbstractValue v) {
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    controlsBlock(ir, controlled, v)
  }

  pragma[inline]
  override predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue)
    )
  }

  pragma[inline]
  override predicate comparesLt(Expr e, int k, boolean isLessThan, AbstractValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value)
    )
  }

  pragma[inline]
  override predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue) and
      this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresLt(Expr e, int k, BasicBlock block, boolean isLessThan) {
    exists(Instruction i, AbstractValue value |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value) and
      this.valueControls(block, value)
    )
  }

  pragma[inline]
  override predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue)
    )
  }

  pragma[inline]
  override predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean areEqual) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue) and
      this.controls(block, testIsTrue)
    )
  }

  pragma[inline]
  override predicate comparesEq(Expr e, int k, boolean areEqual, AbstractValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesEq(i.getAUse(), k, areEqual, value)
    )
  }

  pragma[inline]
  override predicate ensuresEq(Expr e, int k, BasicBlock block, boolean areEqual) {
    exists(Instruction i, AbstractValue value |
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
private predicate nonExcludedIRAndBasicBlock(IRBlock irb, BasicBlock controlled) {
  exists(Instruction instr |
    instr = irb.getAnInstruction() and
    instr.getAst().(ControlFlowNode).getBasicBlock() = controlled and
    not excludeAsControlledInstruction(instr)
  )
}

/**
 * A Boolean condition in the IR that guards one or more basic blocks.
 *
 * Note that `&&` and `||` don't have an explicit representation in the IR,
 * and therefore will not appear as IRGuardConditions.
 */
class IRGuardCondition extends Instruction {
  Instruction branch;

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

  IRGuardCondition() { branch = getBranchForCondition(this) }

  /**
   * Holds if this condition controls `controlled`, meaning that `controlled` is only
   * entered if the value of this condition is `v`.
   *
   * For details on what "controls" mean, see the QLDoc for `controls`.
   */
  predicate valueControls(IRBlock controlled, AbstractValue v) {
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    this.controlsBlock(controlled, v)
    or
    exists(IRGuardCondition ne |
      this = ne.(LogicalNotInstruction).getUnary() and
      ne.valueControls(controlled, v.getDualValue())
    )
  }

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
  predicate controls(IRBlock controlled, boolean testIsTrue) {
    this.valueControls(controlled, any(BooleanValue bv | bv.getValue() = testIsTrue))
  }

  /**
   * Holds if the control-flow edge `(pred, succ)` may be taken only if
   * the value of this condition is `v`.
   */
  predicate valueControlsEdge(IRBlock pred, IRBlock succ, AbstractValue v) {
    pred.getASuccessor() = succ and
    this.valueControls(pred, v)
    or
    succ = this.getBranchSuccessor(v) and
    (
      branch.(ConditionalBranchInstruction).getCondition() = this and
      branch.getBlock() = pred
      or
      branch.(SwitchInstruction).getExpression() = this and
      branch.getBlock() = pred
    )
  }

  /**
   * Holds if the control-flow edge `(pred, succ)` may be taken only if
   * the value of this condition is `testIsTrue`.
   */
  final predicate controlsEdge(IRBlock pred, IRBlock succ, boolean testIsTrue) {
    this.valueControlsEdge(pred, succ, any(BooleanValue bv | bv.getValue() = testIsTrue))
  }

  /**
   * Gets the block to which `branch` jumps directly when the value of this condition is `v`.
   *
   * This predicate is intended to help with situations in which an inference can only be made
   * based on an edge between a block with multiple successors and a block with multiple
   * predecessors. For example, in the following situation, an inference can be made about the
   * value of `x` at the end of the `if` statement, but there is no block which is controlled by
   * the `if` statement when `x >= y`.
   * ```
   * if (x < y) {
   *   x = y;
   * }
   * return x;
   * ```
   */
  private IRBlock getBranchSuccessor(AbstractValue v) {
    branch.(ConditionalBranchInstruction).getCondition() = this and
    exists(BooleanValue bv | bv = v |
      bv.getValue() = true and
      result.getFirstInstruction() = branch.(ConditionalBranchInstruction).getTrueSuccessor()
      or
      bv.getValue() = false and
      result.getFirstInstruction() = branch.(ConditionalBranchInstruction).getFalseSuccessor()
    )
    or
    exists(SwitchInstruction switch, CaseEdge kind | switch = branch |
      switch.getExpression() = this and
      result.getFirstInstruction() = switch.getSuccessor(kind) and
      kind = v.(MatchValue).getCase()
    )
  }

  /** Holds if (determined by this guard) `left < right + k` evaluates to `isLessThan` if this expression evaluates to `testIsTrue`. */
  pragma[inline]
  predicate comparesLt(Operand left, Operand right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(BooleanValue value |
      compares_lt(valueNumber(this), left, right, k, isLessThan, value) and
      value.getValue() = testIsTrue
    )
  }

  /**
   * Holds if (determined by this guard) `op < k` evaluates to `isLessThan` if
   * this expression evaluates to `value`.
   */
  pragma[inline]
  predicate comparesLt(Operand op, int k, boolean isLessThan, AbstractValue value) {
    compares_lt(valueNumber(this), op, k, isLessThan, value)
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `left >= right + k`.
   */
  pragma[inline]
  predicate ensuresLt(Operand left, Operand right, int k, IRBlock block, boolean isLessThan) {
    exists(AbstractValue value |
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
    exists(AbstractValue value |
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
    exists(AbstractValue value |
      compares_lt(valueNumber(this), left, right, k, isLessThan, value) and
      this.valueControlsEdge(pred, succ, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op < k` must be `isLessThan` on the edge from
   * `pred` to `succ`. If `isLessThan = false` then this implies `op >= k`.
   */
  pragma[inline]
  predicate ensuresLtEdge(Operand left, int k, IRBlock pred, IRBlock succ, boolean isLessThan) {
    exists(AbstractValue value |
      compares_lt(valueNumber(this), left, k, isLessThan, value) and
      this.valueControlsEdge(pred, succ, value)
    )
  }

  /** Holds if (determined by this guard) `left == right + k` evaluates to `areEqual` if this expression evaluates to `testIsTrue`. */
  pragma[inline]
  predicate comparesEq(Operand left, Operand right, int k, boolean areEqual, boolean testIsTrue) {
    exists(BooleanValue value |
      compares_eq(valueNumber(this), left, right, k, areEqual, value) and
      value.getValue() = testIsTrue
    )
  }

  /** Holds if (determined by this guard) `op == k` evaluates to `areEqual` if this expression evaluates to `value`. */
  pragma[inline]
  predicate comparesEq(Operand op, int k, boolean areEqual, AbstractValue value) {
    unary_compares_eq(valueNumber(this), op, k, areEqual, value)
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`.
   */
  pragma[inline]
  predicate ensuresEq(Operand left, Operand right, int k, IRBlock block, boolean areEqual) {
    exists(AbstractValue value |
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
    exists(AbstractValue value |
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
    exists(AbstractValue value |
      compares_eq(valueNumber(this), left, right, k, areEqual, value) and
      this.valueControlsEdge(pred, succ, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op == k` must be `areEqual` on the edge from
   * `pred` to `succ`. If `areEqual = false` then this implies `op != k`.
   */
  pragma[inline]
  predicate ensuresEqEdge(Operand op, int k, IRBlock pred, IRBlock succ, boolean areEqual) {
    exists(AbstractValue value |
      unary_compares_eq(valueNumber(this), op, k, areEqual, value) and
      this.valueControlsEdge(pred, succ, value)
    )
  }

  /**
   * Holds if this condition controls `block`, meaning that `block` is only
   * entered if the value of this condition is `v`. This helper
   * predicate does not necessarily hold for binary logical operations like
   * `&&` and `||`. See the detailed explanation on predicate `controls`.
   */
  private predicate controlsBlock(IRBlock controlled, AbstractValue v) {
    not isUnreachedBlock(controlled) and
    //
    // For this block to control the block `controlled` with `testIsTrue` the
    // following must hold: Execution must have passed through the test; that
    // is, `this` must strictly dominate `controlled`. Execution must have
    // passed through the `testIsTrue` edge leaving `this`.
    //
    // Although "passed through the true edge" implies that
    // `getBranchSuccessor(true)` dominates `controlled`, the reverse is not
    // true, as flow may have passed through another edge to get to
    // `getBranchSuccessor(true)`, so we need to assert that
    // `getBranchSuccessor(true)` dominates `controlled` *and* that all
    // predecessors of `getBranchSuccessor(true)` are either `this` or
    // dominated by `getBranchSuccessor(true)`.
    //
    // For example, in the following snippet:
    //
    //     if (x)
    //       controlled;
    //     false_successor;
    //     uncontrolled;
    //
    // `false_successor` dominates `uncontrolled`, but not all of its
    // predecessors are `this` (`if (x)`) or dominated by itself. Whereas in
    // the following code:
    //
    //     if (x)
    //       while (controlled)
    //         also_controlled;
    //     false_successor;
    //     uncontrolled;
    //
    // the block `while (controlled)` is controlled because all of its
    // predecessors are `this` (`if (x)`) or (in the case of `also_controlled`)
    // dominated by itself.
    //
    // The additional constraint on the predecessors of the test successor implies
    // that `this` strictly dominates `controlled` so that isn't necessary to check
    // directly.
    exists(IRBlock succ |
      succ = this.getBranchSuccessor(v) and
      this.hasDominatingEdgeTo(succ) and
      succ.dominates(controlled)
    )
  }

  /**
   * Holds if `(this, succ)` is an edge that dominates `succ`, that is, all other
   * predecessors of `succ` are dominated by `succ`. This implies that `this` is the
   * immediate dominator of `succ`.
   *
   * This is a necessary and sufficient condition for an edge to dominate anything,
   * and in particular `bb1.hasDominatingEdgeTo(bb2) and bb2.dominates(bb3)` means
   * that the edge `(bb1, bb2)` dominates `bb3`.
   */
  private predicate hasDominatingEdgeTo(IRBlock succ) {
    exists(IRBlock branchBlock | branchBlock = this.getBranchBlock() |
      branchBlock.immediatelyDominates(succ) and
      branchBlock.getASuccessor() = succ and
      forall(IRBlock pred | pred = succ.getAPredecessor() and pred != branchBlock |
        succ.dominates(pred)
        or
        // An unreachable `pred` is vacuously dominated by `succ` since all
        // paths from the entry to `pred` go through `succ`. Such vacuous
        // dominance is not included in the `dominates` predicate since that
        // could cause quadratic blow-up.
        not pred.isReachableFromFunctionEntry()
      )
    )
  }

  pragma[noinline]
  private IRBlock getBranchBlock() { result = branch.getBlock() }
}

private Instruction getBranchForCondition(Instruction guard) {
  result.(ConditionalBranchInstruction).getCondition() = guard
  or
  result.(SwitchInstruction).getExpression() = guard
  or
  exists(LogicalNotInstruction cond |
    result = getBranchForCondition(cond) and cond.getUnary() = guard
  )
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
  }

  private predicate isConvertedBool(Instruction instr) {
    instr.getResultIRType() instanceof IRBooleanType
    or
    isConvertedBool(instr.(ConvertInstruction).getUnary())
    or
    isConvertedBool(instr.(BuiltinExpectCallInstruction).getCondition())
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
    exists(CompareValueNumber cmp, Operand left, Operand right, AbstractValue v |
      test = cmp and
      pragma[only_bind_into](cmp)
          .hasOperands(pragma[only_bind_into](left), pragma[only_bind_into](right)) and
      isConvertedBool(left.getDef()) and
      int_value(right.getDef()) = 0 and
      unary_compares_eq(valueNumberOfOperand(left), op, k, areEqual, v)
    |
      cmp instanceof CompareNEValueNumber and
      v = value
      or
      cmp instanceof CompareEQValueNumber and
      v.getDualValue() = value
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

  /** A call to the builtin operation `__builtin_expect`. */
  private class BuiltinExpectCallInstruction extends CallInstruction {
    BuiltinExpectCallInstruction() { this.getStaticCallTarget().hasName("__builtin_expect") }

    /** Gets the condition of this call. */
    Instruction getCondition() { result = this.getConditionOperand().getDef() }

    Operand getConditionOperand() {
      // The first parameter of `__builtin_expect` has type `long`. So we skip
      // the conversion when inferring guards.
      result = this.getArgument(0).(ConvertInstruction).getUnaryOperand()
    }
  }

  /**
   * Holds if `left == right + k` is `areEqual` if `cmp` evaluates to `value`,
   * and `cmp` is an instruction that compares the value of
   * `__builtin_expect(left == right + k, _)` to `0`.
   */
  private predicate builtin_expect_eq(
    CompareValueNumber cmp, Operand left, Operand right, int k, boolean areEqual,
    AbstractValue value
  ) {
    exists(BuiltinExpectCallValueNumber call, Instruction const, AbstractValue innerValue |
      int_value(const) = 0 and
      cmp.hasOperands(call.getAUse(), const.getAUse()) and
      compares_eq(call.getCondition(), left, right, k, areEqual, innerValue)
    |
      cmp instanceof CompareNEValueNumber and
      value = innerValue
      or
      cmp instanceof CompareEQValueNumber and
      value.getDualValue() = innerValue
    )
  }

  private predicate complex_eq(
    ValueNumber cmp, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
  ) {
    sub_eq(cmp, left, right, k, areEqual, value)
    or
    add_eq(cmp, left, right, k, areEqual, value)
    or
    builtin_expect_eq(cmp, left, right, k, areEqual, value)
  }

  /**
   * Holds if `op == k` is `areEqual` if `cmp` evaluates to `value`, and `cmp` is
   * an instruction that compares the value of `__builtin_expect(op == k, _)` to `0`.
   */
  private predicate unary_builtin_expect_eq(
    CompareValueNumber cmp, Operand op, int k, boolean areEqual, AbstractValue value
  ) {
    exists(BuiltinExpectCallValueNumber call, Instruction const, AbstractValue innerValue |
      int_value(const) = 0 and
      cmp.hasOperands(call.getAUse(), const.getAUse()) and
      unary_compares_eq(call.getCondition(), op, k, areEqual, innerValue)
    |
      cmp instanceof CompareNEValueNumber and
      value = innerValue
      or
      cmp instanceof CompareEQValueNumber and
      value.getDualValue() = innerValue
    )
  }

  private predicate unary_complex_eq(
    ValueNumber test, Operand op, int k, boolean areEqual, AbstractValue value
  ) {
    unary_sub_eq(test, op, k, areEqual, value)
    or
    unary_add_eq(test, op, k, areEqual, value)
    or
    unary_builtin_expect_eq(test, op, k, areEqual, value)
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
