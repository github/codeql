/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 */

import cpp
import semmle.code.cpp.ir.IR
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
cached
class GuardCondition extends Expr {
  cached
  GuardCondition() {
    exists(IRGuardCondition ir | this = ir.getUnconvertedResultExpression())
    or
    // no binary operators in the IR
    this.(BinaryLogicalOperation).getAnOperand() instanceof GuardCondition
  }

  /**
   * Holds if this condition controls `controlled`, meaning that `controlled` is only
   * entered if the value of this condition is `v`.
   *
   * For details on what "controls" mean, see the QLDoc for `controls`.
   */
  cached
  predicate valueControls(BasicBlock controlled, AbstractValue v) { none() }

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
  cached
  final predicate controls(BasicBlock controlled, boolean testIsTrue) {
    this.valueControls(controlled, any(BooleanValue bv | bv.getValue() = testIsTrue))
  }

  /** Holds if (determined by this guard) `left < right + k` evaluates to `isLessThan` if this expression evaluates to `testIsTrue`. */
  cached
  predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    none()
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   *   If `isLessThan = false` then this implies `left >= right + k`.
   */
  cached
  predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) { none() }

  /**
   * Holds if (determined by this guard) `e < k` evaluates to `isLessThan` if
   * this expression evaluates to `value`.
   */
  cached
  predicate comparesLt(Expr e, int k, boolean isLessThan, AbstractValue value) { none() }

  /**
   * Holds if (determined by this guard) `e < k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `e >= k`.
   */
  cached
  predicate ensuresLt(Expr e, int k, BasicBlock block, boolean isLessThan) { none() }

  /** Holds if (determined by this guard) `left == right + k` evaluates to `areEqual` if this expression evaluates to `testIsTrue`. */
  cached
  predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    none()
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`.
   */
  cached
  predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean areEqual) { none() }

  /** Holds if (determined by this guard) `e == k` evaluates to `areEqual` if this expression evaluates to `value`. */
  cached
  predicate comparesEq(Expr e, int k, boolean areEqual, AbstractValue value) { none() }

  /**
   * Holds if (determined by this guard) `e == k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `e != k`.
   */
  cached
  predicate ensuresEq(Expr e, int k, BasicBlock block, boolean areEqual) { none() }
}

/**
 * A binary logical operator in the AST that guards one or more basic blocks.
 */
private class GuardConditionFromBinaryLogicalOperator extends GuardCondition {
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

  override predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(boolean testIsTrue |
      this.comparesLt(left, right, k, isLessThan, testIsTrue) and this.controls(block, testIsTrue)
    )
  }

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

  override predicate ensuresEq(Expr e, int k, BasicBlock block, boolean areEqual) {
    exists(AbstractValue value |
      this.comparesEq(e, k, areEqual, value) and this.valueControls(block, value)
    )
  }
}

/**
 * A Boolean condition in the AST that guards one or more basic blocks and has a corresponding IR
 * instruction.
 */
private class GuardConditionFromIR extends GuardCondition {
  IRGuardCondition ir;

  GuardConditionFromIR() { this = ir.getUnconvertedResultExpression() }

  override predicate valueControls(BasicBlock controlled, AbstractValue v) {
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    this.controlsBlock(controlled, v)
  }

  override predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue)
    )
  }

  override predicate comparesLt(Expr e, int k, boolean isLessThan, AbstractValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value)
    )
  }

  override predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue) and
      this.controls(block, testIsTrue)
    )
  }

  override predicate ensuresLt(Expr e, int k, BasicBlock block, boolean isLessThan) {
    exists(Instruction i, AbstractValue value |
      i.getUnconvertedResultExpression() = e and
      ir.comparesLt(i.getAUse(), k, isLessThan, value) and
      this.valueControls(block, value)
    )
  }

  override predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue)
    )
  }

  override predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean areEqual) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue) and
      this.controls(block, testIsTrue)
    )
  }

  override predicate comparesEq(Expr e, int k, boolean areEqual, AbstractValue value) {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      ir.comparesEq(i.getAUse(), k, areEqual, value)
    )
  }

  override predicate ensuresEq(Expr e, int k, BasicBlock block, boolean areEqual) {
    exists(Instruction i, AbstractValue value |
      i.getUnconvertedResultExpression() = e and
      ir.comparesEq(i.getAUse(), k, areEqual, value) and
      this.valueControls(block, value)
    )
  }

  /**
   * Holds if this condition controls `block`, meaning that `block` is only
   * entered if the value of this condition is `v`. This helper
   * predicate does not necessarily hold for binary logical operations like
   * `&&` and `||`. See the detailed explanation on predicate `controls`.
   */
  private predicate controlsBlock(BasicBlock controlled, AbstractValue v) {
    exists(IRBlock irb |
      ir.valueControls(irb, v) and
      nonExcludedIRAndBasicBlock(irb, controlled) and
      not isUnreachedBlock(irb)
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
 * A Boolean condition in the IR that guards one or more basic blocks. This includes
 * operands of logical operators but not switch statements. Note that `&&` and `||`
 * don't have an explicit representation in the IR, and therefore will not appear as
 * IRGuardConditions.
 */
cached
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
   * has a cached user-facing predicate that. For example,
   * `GuardCondition::comparesEq` calls `compares_eq`. This predicate has
   * several cases that recursively decompose the relation to bring it to a
   * canonical form (i.e., a relation of the form `e1 == e2 + k`). The base
   * case for this relation (i.e., `simple_comparison_eq`) handles
   * `CompareEQInstruction`s and `CompareNEInstruction`, and recursive
   * predicates (e.g., `complex_eq`) rewrites larger expressions such as
   * `e1 + k1 == e2 + k2` into canonical the form `e1 == e2 + (k2 - k1)`.
   */

  cached
  IRGuardCondition() { branch = getBranchForCondition(this) }

  /**
   * Holds if this condition controls `controlled`, meaning that `controlled` is only
   * entered if the value of this condition is `v`.
   *
   * For details on what "controls" mean, see the QLDoc for `controls`.
   */
  cached
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
  cached
  predicate controls(IRBlock controlled, boolean testIsTrue) {
    this.valueControls(controlled, any(BooleanValue bv | bv.getValue() = testIsTrue))
  }

  /**
   * Holds if the control-flow edge `(pred, succ)` may be taken only if
   * the value of this condition is `v`.
   */
  cached
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
  cached
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
  cached
  predicate comparesLt(Operand left, Operand right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(BooleanValue value |
      compares_lt(this, left, right, k, isLessThan, value) and
      value.getValue() = testIsTrue
    )
  }

  /**
   * Holds if (determined by this guard) `op < k` evaluates to `isLessThan` if
   * this expression evaluates to `value`.
   */
  cached
  predicate comparesLt(Operand op, int k, boolean isLessThan, AbstractValue value) {
    compares_lt(this, op, k, isLessThan, value)
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `left >= right + k`.
   */
  cached
  predicate ensuresLt(Operand left, Operand right, int k, IRBlock block, boolean isLessThan) {
    exists(AbstractValue value |
      compares_lt(this, left, right, k, isLessThan, value) and this.valueControls(block, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op < k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `op >= k`.
   */
  cached
  predicate ensuresLt(Operand op, int k, IRBlock block, boolean isLessThan) {
    exists(AbstractValue value |
      compares_lt(this, op, k, isLessThan, value) and this.valueControls(block, value)
    )
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` on the edge from
   * `pred` to `succ`. If `isLessThan = false` then this implies `left >= right + k`.
   */
  cached
  predicate ensuresLtEdge(
    Operand left, Operand right, int k, IRBlock pred, IRBlock succ, boolean isLessThan
  ) {
    exists(AbstractValue value |
      compares_lt(this, left, right, k, isLessThan, value) and
      this.valueControlsEdge(pred, succ, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op < k` must be `isLessThan` on the edge from
   * `pred` to `succ`. If `isLessThan = false` then this implies `op >= k`.
   */
  cached
  predicate ensuresLtEdge(Operand left, int k, IRBlock pred, IRBlock succ, boolean isLessThan) {
    exists(AbstractValue value |
      compares_lt(this, left, k, isLessThan, value) and
      this.valueControlsEdge(pred, succ, value)
    )
  }

  /** Holds if (determined by this guard) `left == right + k` evaluates to `areEqual` if this expression evaluates to `testIsTrue`. */
  cached
  predicate comparesEq(Operand left, Operand right, int k, boolean areEqual, boolean testIsTrue) {
    exists(BooleanValue value |
      compares_eq(this, left, right, k, areEqual, value) and
      value.getValue() = testIsTrue
    )
  }

  /** Holds if (determined by this guard) `op == k` evaluates to `areEqual` if this expression evaluates to `value`. */
  cached
  predicate comparesEq(Operand op, int k, boolean areEqual, AbstractValue value) {
    unary_compares_eq(this, op, k, areEqual, false, value)
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`.
   */
  cached
  predicate ensuresEq(Operand left, Operand right, int k, IRBlock block, boolean areEqual) {
    exists(AbstractValue value |
      compares_eq(this, left, right, k, areEqual, value) and this.valueControls(block, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op == k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `op != k`.
   */
  cached
  predicate ensuresEq(Operand op, int k, IRBlock block, boolean areEqual) {
    exists(AbstractValue value |
      unary_compares_eq(this, op, k, areEqual, false, value) and this.valueControls(block, value)
    )
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` on the edge from
   * `pred` to `succ`. If `areEqual = false` then this implies `left != right + k`.
   */
  cached
  predicate ensuresEqEdge(
    Operand left, Operand right, int k, IRBlock pred, IRBlock succ, boolean areEqual
  ) {
    exists(AbstractValue value |
      compares_eq(this, left, right, k, areEqual, value) and
      this.valueControlsEdge(pred, succ, value)
    )
  }

  /**
   * Holds if (determined by this guard) `op == k` must be `areEqual` on the edge from
   * `pred` to `succ`. If `areEqual = false` then this implies `op != k`.
   */
  cached
  predicate ensuresEqEdge(Operand op, int k, IRBlock pred, IRBlock succ, boolean areEqual) {
    exists(AbstractValue value |
      unary_compares_eq(this, op, k, areEqual, false, value) and
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
  exists(LogicalNotInstruction cond |
    result = getBranchForCondition(cond) and cond.getUnary() = guard
  )
  or
  result.(SwitchInstruction).getExpression() = guard
}

/**
 * Holds if `left == right + k` is `areEqual` given that test is `testIsTrue`.
 *
 * Beware making mistaken logical implications here relating `areEqual` and `testIsTrue`.
 */
private predicate compares_eq(
  Instruction test, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
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
    compares_eq(test.(LogicalNotInstruction).getUnary(), left, right, k, areEqual, dual)
  )
  or
  compares_eq(test.(BuiltinExpectCallInstruction).getCondition(), left, right, k, areEqual, value)
}

/**
 * Holds if `op == k` is `areEqual` given that `test` is equal to `value`.
 *
 * Many internal predicates in this file have a `inNonZeroCase` column.
 * Ideally, the `k` column would be a type such as `Option<int>::Option`, to
 * represent whether we have a concrete value `k` such that `op == k`, or whether
 * we only know that `op != 0`.
 * However, cannot instantiate `Option` with an infinite type. Thus the boolean
 * `inNonZeroCase` is used to distinquish the `Some` (where we have a concrete
 * value `k`) and `None` cases (where we only know that `op != 0`).
 *
 * Thus, if `inNonZeroCase = true` then `op != 0` and the value of `k` is
 * meaningless.
 *
 * To see why `inNonZeroCase` is needed consider the following C program:
 * ```c
 * char* p = ...;
 * if(p) {
 *   use(p);
 * }
 * ```
 * in C++ there would be an int-to-bool conversion on `p`. However, since C
 * does not have booleans there is no conversion. We want to be able to
 * conclude that `p` is non-zero in the true branch, so we need to give `k`
 * some value. However, simply setting `k = 1` would make the rest of the
 * analysis think that `k == 1` holds inside the branch. So we distinquish
 * between the above case and
 * ```c
 * if(p == 1) {
 *   use(p)
 * }
 * ```
 * by setting `inNonZeroCase` to `true` in the former case, but not in the
 * latter.
 */
private predicate unary_compares_eq(
  Instruction test, Operand op, int k, boolean areEqual, boolean inNonZeroCase, AbstractValue value
) {
  /* The simple case where the test *is* the comparison so areEqual = testIsTrue xor eq. */
  exists(AbstractValue v |
    unary_simple_comparison_eq(test, k, inNonZeroCase, v) and op.getDef() = test
  |
    areEqual = true and value = v
    or
    areEqual = false and value = v.getDualValue()
  )
  or
  unary_complex_eq(test, op, k, areEqual, inNonZeroCase, value)
  or
  /* (x is true => (op == k)) => (!x is false => (op == k)) */
  exists(AbstractValue dual, boolean inNonZeroCase0 |
    value = dual.getDualValue() and
    unary_compares_eq(test.(LogicalNotInstruction).getUnary(), op, k, inNonZeroCase0, areEqual, dual)
  |
    k = 0 and inNonZeroCase = inNonZeroCase0
    or
    k != 0 and inNonZeroCase = true
  )
  or
  // ((test is `areEqual` => op == const + k2) and const == `k1`) =>
  // test is `areEqual` => op == k1 + k2
  inNonZeroCase = false and
  exists(int k1, int k2, ConstantInstruction const |
    compares_eq(test, op, const.getAUse(), k2, areEqual, value) and
    int_value(const) = k1 and
    k = k1 + k2
  )
  or
  unary_compares_eq(test.(BuiltinExpectCallInstruction).getCondition(), op, k, areEqual,
    inNonZeroCase, value)
}

/** Rearrange various simple comparisons into `left == right + k` form. */
private predicate simple_comparison_eq(
  CompareInstruction cmp, Operand left, Operand right, int k, AbstractValue value
) {
  left = cmp.getLeftOperand() and
  cmp instanceof CompareEQInstruction and
  right = cmp.getRightOperand() and
  k = 0 and
  value.(BooleanValue).getValue() = true
  or
  left = cmp.getLeftOperand() and
  cmp instanceof CompareNEInstruction and
  right = cmp.getRightOperand() and
  k = 0 and
  value.(BooleanValue).getValue() = false
}

/**
 * Rearrange various simple comparisons into `op == k` form.
 */
private predicate unary_simple_comparison_eq(
  Instruction test, int k, boolean inNonZeroCase, AbstractValue value
) {
  exists(SwitchInstruction switch, CaseEdge case |
    test = switch.getExpression() and
    case = value.(MatchValue).getCase() and
    exists(switch.getSuccessor(case)) and
    case.getValue().toInt() = k and
    inNonZeroCase = false
  )
  or
  // Any instruction with an integral type could potentially be part of a
  // check for nullness when used in a guard. So we include all integral
  // typed instructions here. However, since some of these instructions are
  // already included as guards in other cases, we exclude those here.
  // These are instructions that compute a binary equality or inequality
  // relation. For example, the following:
  // ```cpp
  // if(a == b + 42) { ... }
  // ```
  // generates the following IR:
  // ```
  // r1(glval<int>) = VariableAddress[a]     :
  // r2(int)        = Load[a]                : &:r1, m1
  // r3(glval<int>) = VariableAddress[b]     :
  // r4(int)        = Load[b]                : &:r3, m2
  // r5(int)        = Constant[42]           :
  // r6(int)        = Add                    : r4, r5
  // r7(bool)       = CompareEQ              : r2, r6
  // v1(void)       = ConditionalBranch      : r7
  // ```
  // and since `r7` is an integral typed instruction this predicate could
  // include a case for when `r7` evaluates to true (in which case we would
  // infer that `r6` was non-zero, and a case for when `r7` evaluates to false
  // (in which case we would infer that `r6` was zero).
  // However, since `a == b + 42` is already supported when reasoning about
  // binary equalities we exclude those cases here.
  not test.isGLValue() and
  not simple_comparison_eq(test, _, _, _, _) and
  not simple_comparison_lt(test, _, _, _) and
  not test = any(SwitchInstruction switch).getExpression() and
  (
    test.getResultIRType() instanceof IRAddressType or
    test.getResultIRType() instanceof IRIntegerType or
    test.getResultIRType() instanceof IRBooleanType
  ) and
  (
    k = 1 and
    value.(BooleanValue).getValue() = true and
    inNonZeroCase = true
    or
    k = 0 and
    value.(BooleanValue).getValue() = false and
    inNonZeroCase = false
  )
}

/** A call to the builtin operation `__builtin_expect`. */
private class BuiltinExpectCallInstruction extends CallInstruction {
  BuiltinExpectCallInstruction() { this.getStaticCallTarget().hasName("__builtin_expect") }

  /** Gets the condition of this call. */
  Instruction getCondition() {
    // The first parameter of `__builtin_expect` has type `long`. So we skip
    // the conversion when inferring guards.
    result = this.getArgument(0).(ConvertInstruction).getUnary()
  }
}

/**
 * Holds if `left == right + k` is `areEqual` if `cmp` evaluates to `value`,
 * and `cmp` is an instruction that compares the value of
 * `__builtin_expect(left == right + k, _)` to `0`.
 */
private predicate builtin_expect_eq(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
) {
  exists(BuiltinExpectCallInstruction call, Instruction const, AbstractValue innerValue |
    int_value(const) = 0 and
    cmp.hasOperands(call.getAUse(), const.getAUse()) and
    compares_eq(call.getCondition(), left, right, k, areEqual, innerValue)
  |
    cmp instanceof CompareNEInstruction and
    value = innerValue
    or
    cmp instanceof CompareEQInstruction and
    value.getDualValue() = innerValue
  )
}

private predicate complex_eq(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
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
  CompareInstruction cmp, Operand op, int k, boolean areEqual, boolean inNonZeroCase,
  AbstractValue value
) {
  exists(BuiltinExpectCallInstruction call, Instruction const, AbstractValue innerValue |
    int_value(const) = 0 and
    cmp.hasOperands(call.getAUse(), const.getAUse()) and
    unary_compares_eq(call.getCondition(), op, k, areEqual, inNonZeroCase, innerValue)
  |
    cmp instanceof CompareNEInstruction and
    value = innerValue
    or
    cmp instanceof CompareEQInstruction and
    value.getDualValue() = innerValue
  )
}

private predicate unary_complex_eq(
  Instruction test, Operand op, int k, boolean areEqual, boolean inNonZeroCase, AbstractValue value
) {
  unary_sub_eq(test, op, k, areEqual, inNonZeroCase, value)
  or
  unary_add_eq(test, op, k, areEqual, inNonZeroCase, value)
  or
  unary_builtin_expect_eq(test, op, k, areEqual, inNonZeroCase, value)
}

/*
 * Simplification of inequality expressions
 * Simplify conditions in the source to the canonical form l < r + k.
 */

/** Holds if `left < right + k` evaluates to `isLt` given that test is `testIsTrue`. */
private predicate compares_lt(
  Instruction test, Operand left, Operand right, int k, boolean isLt, AbstractValue value
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
    compares_lt(test.(LogicalNotInstruction).getUnary(), left, right, k, isLt, dual)
  )
}

/** Holds if `op < k` evaluates to `isLt` given that `test` evaluates to `value`. */
private predicate compares_lt(Instruction test, Operand op, int k, boolean isLt, AbstractValue value) {
  unary_simple_comparison_lt(test, k, isLt, value) and
  op.getDef() = test
  or
  complex_lt(test, op, k, isLt, value)
  or
  /* (x is true => (op < k)) => (!x is false => (op < k)) */
  exists(AbstractValue dual | value = dual.getDualValue() |
    compares_lt(test.(LogicalNotInstruction).getUnary(), op, k, isLt, dual)
  )
  or
  exists(int k1, int k2, ConstantInstruction const |
    compares_lt(test, op, const.getAUse(), k2, isLt, value) and
    int_value(const) = k1 and
    k = k1 + k2
  )
}

/** `(a < b + k) => (b > a - k) => (b >= a + (1-k))` */
private predicate compares_ge(
  Instruction test, Operand left, Operand right, int k, boolean isGe, AbstractValue value
) {
  exists(int onemk | k = 1 - onemk | compares_lt(test, right, left, onemk, isGe, value))
}

/** Rearrange various simple comparisons into `left < right + k` form. */
private predicate simple_comparison_lt(CompareInstruction cmp, Operand left, Operand right, int k) {
  left = cmp.getLeftOperand() and
  cmp instanceof CompareLTInstruction and
  right = cmp.getRightOperand() and
  k = 0
  or
  left = cmp.getLeftOperand() and
  cmp instanceof CompareLEInstruction and
  right = cmp.getRightOperand() and
  k = 1
  or
  right = cmp.getLeftOperand() and
  cmp instanceof CompareGTInstruction and
  left = cmp.getRightOperand() and
  k = 0
  or
  right = cmp.getLeftOperand() and
  cmp instanceof CompareGEInstruction and
  left = cmp.getRightOperand() and
  k = 1
}

/** Rearrange various simple comparisons into `op < k` form. */
private predicate unary_simple_comparison_lt(
  Instruction test, int k, boolean isLt, AbstractValue value
) {
  exists(SwitchInstruction switch, CaseEdge case |
    test = switch.getExpression() and
    case = value.(MatchValue).getCase() and
    exists(switch.getSuccessor(case)) and
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
  CompareInstruction cmp, Operand left, Operand right, int k, boolean isLt, AbstractValue value
) {
  sub_lt(cmp, left, right, k, isLt, value)
  or
  add_lt(cmp, left, right, k, isLt, value)
}

private predicate complex_lt(
  Instruction test, Operand left, int k, boolean isLt, AbstractValue value
) {
  sub_lt(test, left, k, isLt, value)
  or
  add_lt(test, left, k, isLt, value)
}

// left - x < right + c => left < right + (c+x)
// left < (right - x) + c => left < right + (c-x)
private predicate sub_lt(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean isLt, AbstractValue value
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

private predicate sub_lt(Instruction test, Operand left, int k, boolean isLt, AbstractValue value) {
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
  CompareInstruction cmp, Operand left, Operand right, int k, boolean isLt, AbstractValue value
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

private predicate add_lt(Instruction test, Operand left, int k, boolean isLt, AbstractValue value) {
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
  CompareInstruction cmp, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
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
  Instruction test, Operand op, int k, boolean areEqual, boolean inNonZeroCase, AbstractValue value
) {
  inNonZeroCase = false and
  exists(SubInstruction sub, int c, int x |
    unary_compares_eq(test, sub.getAUse(), c, areEqual, inNonZeroCase, value) and
    op = sub.getLeftOperand() and
    x = int_value(sub.getRight()) and
    k = c + x
  )
  or
  inNonZeroCase = false and
  exists(PointerSubInstruction sub, int c, int x |
    unary_compares_eq(test, sub.getAUse(), c, areEqual, inNonZeroCase, value) and
    op = sub.getLeftOperand() and
    x = int_value(sub.getRight()) and
    k = c + x
  )
}

// left + x == right + c => left == right + (c-x)
// left == (right + x) + c => left == right + (c+x)
private predicate add_eq(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean areEqual, AbstractValue value
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
  Instruction test, Operand left, int k, boolean areEqual, boolean inNonZeroCase,
  AbstractValue value
) {
  inNonZeroCase = false and
  exists(AddInstruction lhs, int c, int x |
    unary_compares_eq(test, lhs.getAUse(), c, areEqual, inNonZeroCase, value) and
    (
      left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
      or
      left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
    ) and
    k = c - x
  )
  or
  inNonZeroCase = false and
  exists(PointerAddInstruction lhs, int c, int x |
    unary_compares_eq(test, lhs.getAUse(), c, areEqual, inNonZeroCase, value) and
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
private int int_value(Instruction i) {
  result = i.(IntegerOrPointerConstantInstruction).getValue().toInt()
}
