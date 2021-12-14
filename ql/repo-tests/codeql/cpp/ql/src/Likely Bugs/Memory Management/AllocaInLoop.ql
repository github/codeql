/**
 * @name Call to alloca in a loop
 * @description Using alloca in a loop can lead to a stack overflow
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cpp/alloca-in-loop
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-770
 */

import cpp
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import semmle.code.cpp.dataflow.DataFlow

/** Gets a loop that contains `e`. */
Loop getAnEnclosingLoopOfExpr(Expr e) { result = getAnEnclosingLoopOfStmt(e.getEnclosingStmt()) }

/** Gets a loop that contains `s`. */
Loop getAnEnclosingLoopOfStmt(Stmt s) {
  result = s.getParent*() and
  not s = result.(ForStmt).getInitialization()
  or
  result = getAnEnclosingLoopOfExpr(s.getParent*())
}

/** A call to `alloca` in one of its forms. */
class AllocaCall extends FunctionCall {
  AllocaCall() {
    this.getTarget().getName() = "__builtin_alloca"
    or
    (this.getTarget().getName() = "_alloca" or this.getTarget().getName() = "_malloca") and
    this.getTarget().getADeclarationEntry().getFile().getBaseName() = "malloc.h"
  }
}

/**
 * A loop that contains an `alloca` call.
 */
class LoopWithAlloca extends Stmt {
  LoopWithAlloca() { this = getAnEnclosingLoopOfExpr(any(AllocaCall ac)) }

  /** Get an `alloca` call inside this loop. It may be in a nested loop. */
  AllocaCall getAnAllocaCall() { this = getAnEnclosingLoopOfExpr(result) }

  /**
   * Holds if the condition of this loop will only be true if `e` is `truth`.
   * For example, if the loop condition is `a == 0 && b`, then
   * `conditionRequires(a, false)` and `conditionRequires(b, true)`.
   */
  private predicate conditionRequires(Expr e, boolean truth) {
    e = this.(Loop).getCondition() and
    truth = true
    or
    // `e == 0`
    exists(EQExpr eq |
      this.conditionRequires(eq, truth.booleanNot()) and
      eq.getAnOperand().getValue().toInt() = 0 and
      e = eq.getAnOperand() and
      not exists(e.getValue())
    )
    or
    // `e != 0`
    exists(NEExpr eq |
      this.conditionRequires(eq, truth) and
      eq.getAnOperand().getValue().toInt() = 0 and
      e = eq.getAnOperand() and
      not exists(e.getValue())
    )
    or
    // `(bool)e == true`
    exists(EQExpr eq |
      this.conditionRequires(eq, truth) and
      eq.getAnOperand().getValue().toInt() = 1 and
      e = eq.getAnOperand() and
      e.getUnspecifiedType() instanceof BoolType and
      not exists(e.getValue())
    )
    or
    // `(bool)e != true`
    exists(NEExpr eq |
      this.conditionRequires(eq, truth.booleanNot()) and
      eq.getAnOperand().getValue().toInt() = 1 and
      e = eq.getAnOperand() and
      e.getUnspecifiedType() instanceof BoolType and
      not exists(e.getValue())
    )
    or
    exists(NotExpr notExpr |
      this.conditionRequires(notExpr, truth.booleanNot()) and
      e = notExpr.getOperand()
    )
    or
    // If the e of `this` requires `andExpr` to be true, then it
    // requires both of its operand to be true as well.
    exists(LogicalAndExpr andExpr |
      truth = true and
      this.conditionRequires(andExpr, truth) and
      e = andExpr.getAnOperand()
    )
    or
    // Dually, if the e of `this` requires `orExpr` to be false, then
    // it requires both of its operand to be false as well.
    exists(LogicalOrExpr orExpr |
      truth = false and
      this.conditionRequires(orExpr, truth) and
      e = orExpr.getAnOperand()
    )
  }

  /**
   * Holds if the condition of this loop will only be true if `e` relates to
   * `value` as `dir`. We don't keep track of whether the equality is strict
   * since this predicate is only used to heuristically determine whether
   * there's a reasonably tight upper bound on the number of loop iterations.
   *
   * For example, if the loop condition is `a < 2 && b`, then
   * `conditionRequiresInequality(a, 2, Lesser())`.
   */
  private predicate conditionRequiresInequality(Expr e, int value, RelationDirection dir) {
    exists(RelationalOperation rel, Expr constant, boolean branch |
      this.conditionRequires(rel, branch) and
      relOpWithSwapAndNegate(rel, e.getFullyConverted(), constant, dir, _, branch) and
      value = constant.getValue().toInt() and
      not exists(e.getValue())
    )
    or
    // Because we're not worried about off-by-one, it's not important whether
    // the `CrementOperation` is a {pre,post}-{inc,dec}rement.
    exists(CrementOperation inc |
      this.conditionRequiresInequality(inc, value, dir) and
      e = inc.getOperand()
    )
  }

  /**
   * Gets a variable that's restricted by `conditionRequires` or
   * `conditionRequiresInequality`.
   */
  private Variable getAControllingVariable() {
    this.conditionRequires(result.getAnAccess(), _)
    or
    this.conditionRequiresInequality(result.getAnAccess(), _, _)
  }

  /**
   * Gets a `VariableAccess` that changes `var` inside the loop body, where
   * `var` is a controlling variable of this loop.
   */
  private VariableAccess getAControllingVariableUpdate(Variable var) {
    var = result.getTarget() and
    var = this.getAControllingVariable() and
    this = getAnEnclosingLoopOfExpr(result) and
    result.isUsedAsLValue()
  }

  /**
   * Holds if there is a control-flow path from the condition of this loop to
   * `node` that doesn't update `var`, where `var` is a controlling variable of
   * this loop. The path has to stay within the loop. The path will start at
   * the successor of the loop condition. If the path reaches all the way back
   * to the loop condition, then it's possible to go around the loop without
   * updating `var`.
   */
  private predicate conditionReachesWithoutUpdate(Variable var, ControlFlowNode node) {
    // Don't leave the loop. It might cause us to leave the scope of `var`
    (node instanceof Stmt implies this = getAnEnclosingLoopOfStmt(node)) and
    (
      node = this.(Loop).getCondition().getASuccessor() and
      var = this.getAControllingVariable()
      or
      this.conditionReachesWithoutUpdate(var, node.getAPredecessor()) and
      not node = this.getAControllingVariableUpdate(var)
    )
  }

  /**
   * Holds if all paths around the loop will update `var`, where `var` is a
   * controlling variable of this loop.
   */
  private predicate hasMandatoryUpdate(Variable var) {
    not this.conditionReachesWithoutUpdate(var, this.(Loop).getCondition())
  }

  /**
   * Gets a definition that may be the most recent definition of the
   * controlling variable `var` before this loop.
   */
  private DataFlow::Node getAPrecedingDef(Variable var) {
    exists(VariableAccess va |
      va = var.getAnAccess() and
      this.conditionRequiresInequality(va, _, _) and
      DataFlow::localFlow(result, DataFlow::exprNode(va)) and
      // A source is outside the loop if it's not inside the loop
      not exists(Expr e |
        e = result.asExpr()
        or
        e = result.asDefiningArgument()
      |
        this = getAnEnclosingLoopOfExpr(e)
      )
    )
  }

  /**
   * Gets a number that may be the most recent value assigned to the
   * controlling variable `var` before this loop.
   */
  private int getAControllingVarInitialValue(Variable var, DataFlow::Node source) {
    source = this.getAPrecedingDef(var) and
    result = source.asExpr().getValue().toInt()
  }

  /**
   * Holds if the most recent definition of `var` before this loop may assign a
   * value that is not a compile-time constant.
   */
  private predicate controllingVarHasUnknownInitialValue(Variable var) {
    // A definition without a constant value was reached
    exists(DataFlow::Node source |
      source = this.getAPrecedingDef(var) and
      not exists(this.getAControllingVarInitialValue(var, source))
    )
  }

  /**
   * Gets the least possible value that the controlling variable `var` may have
   * before this loop, if such a value can be deduced.
   */
  private int getMinPrecedingDef(Variable var) {
    not this.controllingVarHasUnknownInitialValue(var) and
    result = min(this.getAControllingVarInitialValue(var, _))
    or
    this.controllingVarHasUnknownInitialValue(var) and
    var.getType().(IntegralType).isUnsigned() and
    result = 0
  }

  /**
   * Gets the greatest possible value that the controlling variable `var` may
   * have before this loop, if such a value can be deduced.
   */
  private int getMaxPrecedingDef(Variable var) {
    not this.controllingVarHasUnknownInitialValue(var) and
    result = max(this.getAControllingVarInitialValue(var, _))
  }

  /**
   * Holds if this loop has a "small" number of iterations. The meaning of
   * "small" should be such that the loop wouldn't be unreasonably large if
   * manually unrolled.
   */
  predicate isTightlyBounded() {
    exists(Variable var | this.hasMandatoryUpdate(var) |
      this.conditionRequires(var.getAnAccess(), false) and
      forall(VariableAccess update | update = this.getAControllingVariableUpdate(var) |
        exists(AssignExpr assign |
          assign.getLValue() = update and
          assign.getRValue().getValue().toInt() != 0
        )
      )
      or
      this.conditionRequires(var.getAnAccess(), true) and
      forall(VariableAccess update | update = this.getAControllingVariableUpdate(var) |
        exists(AssignExpr assign |
          assign.getLValue() = update and
          assign.getRValue().getValue().toInt() = 0
        )
      )
      or
      exists(int bound |
        this.conditionRequiresInequality(var.getAnAccess(), bound, Lesser()) and
        bound - this.getMinPrecedingDef(var) <= 16 and
        forall(VariableAccess update | update = this.getAControllingVariableUpdate(var) |
          // var++;
          // ++var;
          exists(IncrementOperation inc | inc.getOperand() = update)
          or
          // var += positive_number;
          exists(AssignAddExpr aa |
            aa.getLValue() = update and
            aa.getRValue().getValue().toInt() > 0
          )
          or
          // var = var + positive_number;
          // var = positive_number + var;
          exists(AssignExpr assign, AddExpr add |
            assign.getLValue() = update and
            assign.getRValue() = add and
            add.getAnOperand() = var.getAnAccess() and
            add.getAnOperand().getValue().toInt() > 0
          )
        )
      )
      or
      exists(int bound |
        this.conditionRequiresInequality(var.getAnAccess(), bound, Greater()) and
        this.getMaxPrecedingDef(var) - bound <= 16 and
        forall(VariableAccess update | update = this.getAControllingVariableUpdate(var) |
          // var--;
          // --var;
          exists(DecrementOperation inc | inc.getOperand() = update)
          or
          // var -= positive_number;
          exists(AssignSubExpr aa |
            aa.getLValue() = update and
            aa.getRValue().getValue().toInt() > 0
          )
          or
          // var = var - positive_number;
          exists(AssignExpr assign, SubExpr add |
            assign.getLValue() = update and
            assign.getRValue() = add and
            add.getLeftOperand() = var.getAnAccess() and
            add.getRightOperand().getValue().toInt() > 0
          )
        )
      )
    )
  }
}

from LoopWithAlloca l, AllocaCall alloc
where
  not l.(DoStmt).getCondition().getValue() = "0" and
  not l.isTightlyBounded() and
  alloc = l.getAnAllocaCall() and
  alloc.getASuccessor*() = l.(Loop).getStmt()
select alloc, "Stack allocation is inside a $@ loop.", l, l.toString()
