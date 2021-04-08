import csharp
import semmle.code.csharp.controlflow.BasicBlocks
import experimental.ir.IR

/**
 * Holds if `block` consists of an `UnreachedInstruction`.
 *
 * We avoiding reporting an unreached block as being controlled by a guard. The unreached block
 * has the AST for the `Function` itself, which tends to confuse mapping between the AST `BasicBlock`
 * and the `IRBlock`.
 */
private predicate isUnreachedBlock(IRBlock block) {
  block.getFirstInstruction() instanceof UnreachedInstruction
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
    exists(GuardCondition gc | this.(BinaryLogicalOperation).getAnOperand() = gc)
    or
    // the IR short-circuits if(!x)
    // don't produce a guard condition for `y = !x` and other non-short-circuited cases
    not exists(Instruction inst | this = inst.getAST()) and
    exists(IRGuardCondition ir | this.(LogicalNotExpr).getOperand() = ir.getAST())
  }

  /**
   * Holds if this condition controls `block`, meaning that `block` is only
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
  predicate controls(BasicBlock controlled, boolean testIsTrue) { none() }

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
}

/**
 * Holds if the truth of the binary logical expression `blo` having value `wholeIsTrue`
 * implies that the truth of the child expression `part` has truth value `partIsTrue`.
 *
 * For example if the binary operation:
 * ```csharp
 *   x && y
 * ```
 * is true, `x` and `y` must also be true, so `impliesValue(x, true, true)` and
 * `impliesValue(y, true, true)` hold.
 */
private predicate impliesValue(
  BinaryLogicalOperation blo, Expr part, boolean partIsTrue, boolean wholeIsTrue
) {
  blo instanceof LogicalAndExpr and
  (
    wholeIsTrue = true and partIsTrue = true and part = blo.getAnOperand()
    or
    wholeIsTrue = true and
    impliesValue(blo.getAnOperand().(BinaryLogicalOperation), part, partIsTrue, true)
  )
  or
  blo instanceof LogicalOrExpr and
  (
    wholeIsTrue = false and partIsTrue = false and part = blo.getAnOperand()
    or
    wholeIsTrue = false and
    impliesValue(blo.getAnOperand().(BinaryLogicalOperation), part, partIsTrue, false)
  )
}

/**
 * A binary logical operator in the AST that guards one or more basic blocks.
 */
private class GuardConditionFromBinaryLogicalOperator extends GuardCondition {
  GuardConditionFromBinaryLogicalOperator() {
    exists(GuardCondition gc | this.(BinaryLogicalOperation).getAnOperand() = gc)
  }

  override predicate controls(BasicBlock controlled, boolean testIsTrue) {
    exists(BinaryLogicalOperation binop, GuardCondition lhs, GuardCondition rhs |
      this = binop and
      lhs = binop.getLeftOperand() and
      rhs = binop.getRightOperand() and
      lhs.controls(controlled, testIsTrue) and
      rhs.controls(controlled, testIsTrue)
    )
  }

  override predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(boolean partIsTrue, GuardCondition part |
      impliesValue(this.(BinaryLogicalOperation), part, partIsTrue, testIsTrue)
    |
      part.comparesLt(left, right, k, isLessThan, partIsTrue)
    )
  }

  override predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(boolean testIsTrue |
      comparesLt(left, right, k, isLessThan, testIsTrue) and this.controls(block, testIsTrue)
    )
  }

  override predicate comparesEq(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(boolean partIsTrue, GuardCondition part |
      impliesValue(this.(BinaryLogicalOperation), part, partIsTrue, testIsTrue)
    |
      part.comparesEq(left, right, k, isLessThan, partIsTrue)
    )
  }

  override predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(boolean testIsTrue |
      comparesEq(left, right, k, isLessThan, testIsTrue) and this.controls(block, testIsTrue)
    )
  }
}

/**
 * A `!` operator in the AST that guards one or more basic blocks, and does not have a corresponding
 * IR instruction.
 */
private class GuardConditionFromShortCircuitNot extends GuardCondition, LogicalNotExpr {
  GuardConditionFromShortCircuitNot() {
    not exists(Instruction inst | this = inst.getAST()) and
    exists(IRGuardCondition ir | getOperand() = ir.getAST())
  }

  override predicate controls(BasicBlock controlled, boolean testIsTrue) {
    getOperand().(GuardCondition).controls(controlled, testIsTrue.booleanNot())
  }

  override predicate comparesLt(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    getOperand().(GuardCondition).comparesLt(left, right, k, areEqual, testIsTrue.booleanNot())
  }

  override predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean testIsTrue) {
    getOperand().(GuardCondition).ensuresLt(left, right, k, block, testIsTrue.booleanNot())
  }

  override predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    getOperand().(GuardCondition).comparesEq(left, right, k, areEqual, testIsTrue.booleanNot())
  }

  override predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean testIsTrue) {
    getOperand().(GuardCondition).ensuresEq(left, right, k, block, testIsTrue.booleanNot())
  }
}

/**
 * A Boolean condition in the AST that guards one or more basic blocks and has a corresponding IR
 * instruction.
 */
private class GuardConditionFromIR extends GuardCondition {
  IRGuardCondition ir;

  GuardConditionFromIR() { this = ir.getUnconvertedResultExpression() }

  override predicate controls(BasicBlock controlled, boolean testIsTrue) {
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    this.controlsBlock1(controlled, testIsTrue)
  }

  /** Holds if (determined by this guard) `left < right + k` evaluates to `isLessThan` if this expression evaluates to `testIsTrue`. */
  override predicate comparesLt(Expr left, Expr right, int k, boolean isLessThan, boolean testIsTrue) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue)
    )
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `left >= right + k`.
   */
  override predicate ensuresLt(Expr left, Expr right, int k, BasicBlock block, boolean isLessThan) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesLt(li.getAUse(), ri.getAUse(), k, isLessThan, testIsTrue) and
      this.controls(block, testIsTrue)
    )
  }

  /** Holds if (determined by this guard) `left == right + k` evaluates to `areEqual` if this expression evaluates to `testIsTrue`. */
  override predicate comparesEq(Expr left, Expr right, int k, boolean areEqual, boolean testIsTrue) {
    exists(Instruction li, Instruction ri |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue)
    )
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`.
   */
  override predicate ensuresEq(Expr left, Expr right, int k, BasicBlock block, boolean areEqual) {
    exists(Instruction li, Instruction ri, boolean testIsTrue |
      li.getUnconvertedResultExpression() = left and
      ri.getUnconvertedResultExpression() = right and
      ir.comparesEq(li.getAUse(), ri.getAUse(), k, areEqual, testIsTrue) and
      this.controls(block, testIsTrue)
    )
  }

  /**
   * Holds if this condition controls `block`, meaning that `block` is only
   * entered if the value of this condition is `testIsTrue`. This helper
   * predicate does not necessarily hold for binary logical operations like
   * `&&` and `||`. See the detailed explanation on predicate `controls`.
   */
  private predicate controlsBlock1(BasicBlock controlled, boolean testIsTrue) {
    exists(IRBlock irb |
      forex(IRGuardCondition inst | inst = ir | inst.controls(irb, testIsTrue)) and
      irb.getAnInstruction().getAST().(ControlFlowElement).getAControlFlowNode().getBasicBlock() =
        controlled and
      not isUnreachedBlock(irb)
    )
  }
}

/**
 * A Boolean condition in the IR that guards one or more basic blocks. This includes
 * operands of logical operators but not switch statements. Note that `&&` and `||`
 * don't have an explicit representation in the IR, and therefore will not appear as
 * IRGuardConditions.
 */
cached
class IRGuardCondition extends Instruction {
  ConditionalBranchInstruction branch;

  cached
  IRGuardCondition() { branch = get_branch_for_condition(this) }

  /**
   * Holds if this condition controls `block`, meaning that `block` is only
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
    // This condition must determine the flow of control; that is, this
    // node must be a top-level condition.
    this.controlsBlock(controlled, testIsTrue)
    or
    exists(IRGuardCondition ne |
      this = ne.(LogicalNotInstruction).getUnary() and
      ne.controls(controlled, testIsTrue.booleanNot())
    )
  }

  cached
  predicate controlsEdge(IRBlock pred, IRBlock succ, boolean testIsTrue) {
    pred.getASuccessor() = succ and
    controls(pred, testIsTrue)
    or
    hasBranchEdge(succ, testIsTrue) and
    branch.getCondition() = this and
    branch.getBlock() = pred
  }

  /**
   * Holds if `branch` jumps directly to `succ` when this condition is `testIsTrue`.
   *
   * This predicate is intended to help with situations in which an inference can only be made
   * based on an edge between a block with multiple successors and a block with multiple
   * predecessors. For example, in the following situation, an inference can be made about the
   * value of `x` at the end of the `if` statement, but there is no block which is controlled by
   * the `if` statement when `x >= y`.
   * ```csharp
   * if (x < y) {
   *   x = y;
   * }
   * return x;
   * ```
   */
  private predicate hasBranchEdge(IRBlock succ, boolean testIsTrue) {
    branch.getCondition() = this and
    (
      testIsTrue = true and
      succ.getFirstInstruction() = branch.getTrueSuccessor()
      or
      testIsTrue = false and
      succ.getFirstInstruction() = branch.getFalseSuccessor()
    )
  }

  /** Holds if (determined by this guard) `left < right + k` evaluates to `isLessThan` if this expression evaluates to `testIsTrue`. */
  cached
  predicate comparesLt(Operand left, Operand right, int k, boolean isLessThan, boolean testIsTrue) {
    compares_lt(this, left, right, k, isLessThan, testIsTrue)
  }

  /**
   * Holds if (determined by this guard) `left < right + k` must be `isLessThan` in `block`.
   * If `isLessThan = false` then this implies `left >= right + k`.
   */
  cached
  predicate ensuresLt(Operand left, Operand right, int k, IRBlock block, boolean isLessThan) {
    exists(boolean testIsTrue |
      compares_lt(this, left, right, k, isLessThan, testIsTrue) and this.controls(block, testIsTrue)
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
    exists(boolean testIsTrue |
      compares_lt(this, left, right, k, isLessThan, testIsTrue) and
      this.controlsEdge(pred, succ, testIsTrue)
    )
  }

  /** Holds if (determined by this guard) `left == right + k` evaluates to `areEqual` if this expression evaluates to `testIsTrue`. */
  cached
  predicate comparesEq(Operand left, Operand right, int k, boolean areEqual, boolean testIsTrue) {
    compares_eq(this, left, right, k, areEqual, testIsTrue)
  }

  /**
   * Holds if (determined by this guard) `left == right + k` must be `areEqual` in `block`.
   * If `areEqual = false` then this implies `left != right + k`.
   */
  cached
  predicate ensuresEq(Operand left, Operand right, int k, IRBlock block, boolean areEqual) {
    exists(boolean testIsTrue |
      compares_eq(this, left, right, k, areEqual, testIsTrue) and this.controls(block, testIsTrue)
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
    exists(boolean testIsTrue |
      compares_eq(this, left, right, k, areEqual, testIsTrue) and
      this.controlsEdge(pred, succ, testIsTrue)
    )
  }

  /**
   * Holds if this condition controls `block`, meaning that `block` is only
   * entered if the value of this condition is `testIsTrue`. This helper
   * predicate does not necessarily hold for binary logical operations like
   * `&&` and `||`. See the detailed explanation on predicate `controls`.
   */
  private predicate controlsBlock(IRBlock controlled, boolean testIsTrue) {
    not isUnreachedBlock(controlled) and
    exists(IRBlock branchBlock | branchBlock.getAnInstruction() = branch |
      exists(IRBlock succ |
        testIsTrue = true and succ.getFirstInstruction() = branch.getTrueSuccessor()
        or
        testIsTrue = false and succ.getFirstInstruction() = branch.getFalseSuccessor()
      |
        branch.getCondition() = this and
        succ.dominates(controlled) and
        forall(IRBlock pred | pred.getASuccessor() = succ |
          pred = branchBlock or succ.dominates(pred) or not pred.isReachableFromFunctionEntry()
        )
      )
    )
  }
}

private ConditionalBranchInstruction get_branch_for_condition(Instruction guard) {
  result.getCondition() = guard
  or
  exists(LogicalNotInstruction cond |
    result = get_branch_for_condition(cond) and cond.getUnary() = guard
  )
}

/**
 * Holds if `left == right + k` is `areEqual` given that test is `testIsTrue`.
 *
 * Beware making mistaken logical implications here relating `areEqual` and `testIsTrue`.
 */
private predicate compares_eq(
  Instruction test, Operand left, Operand right, int k, boolean areEqual, boolean testIsTrue
) {
  /* The simple case where the test *is* the comparison so areEqual = testIsTrue xor eq. */
  exists(boolean eq | simple_comparison_eq(test, left, right, k, eq) |
    areEqual = true and testIsTrue = eq
    or
    areEqual = false and testIsTrue = eq.booleanNot()
  )
  or
  // I think this is handled by forwarding in controlsBlock.
  //or
  //logical_comparison_eq(test, left, right, k, areEqual, testIsTrue)
  /* a == b + k => b == a - k */
  exists(int mk | k = -mk | compares_eq(test, right, left, mk, areEqual, testIsTrue))
  or
  complex_eq(test, left, right, k, areEqual, testIsTrue)
  or
  /* (x is true => (left == right + k)) => (!x is false => (left == right + k)) */
  exists(boolean isFalse | testIsTrue = isFalse.booleanNot() |
    compares_eq(test.(LogicalNotInstruction).getUnary(), left, right, k, areEqual, isFalse)
  )
}

/** Rearrange various simple comparisons into `left == right + k` form. */
private predicate simple_comparison_eq(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean areEqual
) {
  left = cmp.getLeftOperand() and
  cmp instanceof CompareEQInstruction and
  right = cmp.getRightOperand() and
  k = 0 and
  areEqual = true
  or
  left = cmp.getLeftOperand() and
  cmp instanceof CompareNEInstruction and
  right = cmp.getRightOperand() and
  k = 0 and
  areEqual = false
}

private predicate complex_eq(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean areEqual, boolean testIsTrue
) {
  sub_eq(cmp, left, right, k, areEqual, testIsTrue)
  or
  add_eq(cmp, left, right, k, areEqual, testIsTrue)
}

/*
 * Simplification of inequality expressions
 * Simplify conditions in the source to the canonical form l < r + k.
 */

/** Holds if `left < right + k` evaluates to `isLt` given that test is `testIsTrue`. */
private predicate compares_lt(
  Instruction test, Operand left, Operand right, int k, boolean isLt, boolean testIsTrue
) {
  /* In the simple case, the test is the comparison, so isLt = testIsTrue */
  simple_comparison_lt(test, left, right, k) and isLt = true and testIsTrue = true
  or
  simple_comparison_lt(test, left, right, k) and isLt = false and testIsTrue = false
  or
  complex_lt(test, left, right, k, isLt, testIsTrue)
  or
  /* (not (left < right + k)) => (left >= right + k) */
  exists(boolean isGe | isLt = isGe.booleanNot() |
    compares_ge(test, left, right, k, isGe, testIsTrue)
  )
  or
  /* (x is true => (left < right + k)) => (!x is false => (left < right + k)) */
  exists(boolean isFalse | testIsTrue = isFalse.booleanNot() |
    compares_lt(test.(LogicalNotInstruction).getUnary(), left, right, k, isLt, isFalse)
  )
}

/** `(a < b + k) => (b > a - k) => (b >= a + (1-k))` */
private predicate compares_ge(
  Instruction test, Operand left, Operand right, int k, boolean isGe, boolean testIsTrue
) {
  exists(int onemk | k = 1 - onemk | compares_lt(test, right, left, onemk, isGe, testIsTrue))
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

private predicate complex_lt(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean isLt, boolean testIsTrue
) {
  sub_lt(cmp, left, right, k, isLt, testIsTrue)
  or
  add_lt(cmp, left, right, k, isLt, testIsTrue)
}

// left - x < right + c => left < right + (c+x)
// left < (right - x) + c => left < right + (c-x)
private predicate sub_lt(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean isLt, boolean testIsTrue
) {
  exists(SubInstruction lhs, int c, int x |
    compares_lt(cmp, lhs.getAUse(), right, c, isLt, testIsTrue) and
    left = lhs.getLeftOperand() and
    x = int_value(lhs.getRight()) and
    k = c + x
  )
  or
  exists(SubInstruction rhs, int c, int x |
    compares_lt(cmp, left, rhs.getAUse(), c, isLt, testIsTrue) and
    right = rhs.getLeftOperand() and
    x = int_value(rhs.getRight()) and
    k = c - x
  )
}

// left + x < right + c => left < right + (c-x)
// left < (right + x) + c => left < right + (c+x)
private predicate add_lt(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean isLt, boolean testIsTrue
) {
  exists(AddInstruction lhs, int c, int x |
    compares_lt(cmp, lhs.getAUse(), right, c, isLt, testIsTrue) and
    (
      left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
      or
      left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
    ) and
    k = c - x
  )
  or
  exists(AddInstruction rhs, int c, int x |
    compares_lt(cmp, left, rhs.getAUse(), c, isLt, testIsTrue) and
    (
      right = rhs.getLeftOperand() and x = int_value(rhs.getRight())
      or
      right = rhs.getRightOperand() and x = int_value(rhs.getLeft())
    ) and
    k = c + x
  )
}

// left - x == right + c => left == right + (c+x)
// left == (right - x) + c => left == right + (c-x)
private predicate sub_eq(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean areEqual, boolean testIsTrue
) {
  exists(SubInstruction lhs, int c, int x |
    compares_eq(cmp, lhs.getAUse(), right, c, areEqual, testIsTrue) and
    left = lhs.getLeftOperand() and
    x = int_value(lhs.getRight()) and
    k = c + x
  )
  or
  exists(SubInstruction rhs, int c, int x |
    compares_eq(cmp, left, rhs.getAUse(), c, areEqual, testIsTrue) and
    right = rhs.getLeftOperand() and
    x = int_value(rhs.getRight()) and
    k = c - x
  )
}

// left + x == right + c => left == right + (c-x)
// left == (right + x) + c => left == right + (c+x)
private predicate add_eq(
  CompareInstruction cmp, Operand left, Operand right, int k, boolean areEqual, boolean testIsTrue
) {
  exists(AddInstruction lhs, int c, int x |
    compares_eq(cmp, lhs.getAUse(), right, c, areEqual, testIsTrue) and
    (
      left = lhs.getLeftOperand() and x = int_value(lhs.getRight())
      or
      left = lhs.getRightOperand() and x = int_value(lhs.getLeft())
    ) and
    k = c - x
  )
  or
  exists(AddInstruction rhs, int c, int x |
    compares_eq(cmp, left, rhs.getAUse(), c, areEqual, testIsTrue) and
    (
      right = rhs.getLeftOperand() and x = int_value(rhs.getRight())
      or
      right = rhs.getRightOperand() and x = int_value(rhs.getLeft())
    ) and
    k = c + x
  )
}

/** The int value of integer constant expression. */
private int int_value(Instruction i) { result = i.(IntegerConstantInstruction).getValue().toInt() }
