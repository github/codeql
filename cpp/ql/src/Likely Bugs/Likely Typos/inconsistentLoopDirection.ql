/**
 * @name Inconsistent direction of for loop
 * @description A for-loop iteration expression goes backward with respect of the initialization statement and condition expression.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/inconsistent-loop-direction
 * @tags correctness
 *       external/cwe/cwe-835
 *       external/microsoft/6293
 * @msrc.severity important
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.dataflow.DataFlow

/**
 * A `for` statement whose update is a crement operation on a variable.
 */
predicate candidateForStmt(
  ForStmt forStmt, Variable v, CrementOperation update, RelationalOperation rel
) {
  update = forStmt.getUpdate() and
  update.getAnOperand() = v.getAnAccess() and
  rel = forStmt.getCondition()
}

pragma[noinline]
predicate candidateDecrForStmt(
  ForStmt forStmt, Variable v, VariableAccess lesserOperand, Expr terminalCondition
) {
  exists(DecrementOperation update, RelationalOperation rel |
    candidateForStmt(forStmt, v, update, rel) and
    // condition is `v < terminalCondition`
    terminalCondition = rel.getGreaterOperand() and
    lesserOperand = rel.getLesserOperand() and
    v.getAnAccess() = lesserOperand
  )
}

predicate illDefinedDecrForStmt(
  ForStmt forstmt, Variable v, Expr initialCondition, Expr terminalCondition
) {
  exists(VariableAccess lesserOperand |
    // decrementing for loop
    candidateDecrForStmt(forstmt, v, lesserOperand, terminalCondition) and
    // `initialCondition` is a value of `v` in the for loop
    v.getAnAssignedValue() = initialCondition and
    DataFlow::localFlowStep(DataFlow::exprNode(initialCondition), DataFlow::exprNode(lesserOperand)) and
    // `initialCondition` < `terminalCondition`
    (
      upperBound(initialCondition) < lowerBound(terminalCondition) and
      (
        // exclude cases where the loop counter is `unsigned` (where wrapping behaviour can be used deliberately)
        v.getUnspecifiedType().(IntegralType).isSigned() or
        initialCondition.getValue().toInt() = 0
      )
      or
      (forstmt.conditionAlwaysFalse() or forstmt.conditionAlwaysTrue())
    )
  )
}

pragma[noinline]
predicate candidateIncrForStmt(
  ForStmt forStmt, Variable v, VariableAccess greaterOperand, Expr terminalCondition
) {
  exists(IncrementOperation update, RelationalOperation rel |
    candidateForStmt(forStmt, v, update, rel) and
    // condition is `v > terminalCondition`
    terminalCondition = rel.getLesserOperand() and
    greaterOperand = rel.getGreaterOperand() and
    v.getAnAccess() = greaterOperand
  )
}

predicate illDefinedIncrForStmt(
  ForStmt forstmt, Variable v, Expr initialCondition, Expr terminalCondition
) {
  exists(VariableAccess greaterOperand |
    // incrementing for loop
    candidateIncrForStmt(forstmt, v, greaterOperand, terminalCondition) and
    // `initialCondition` is a value of `v` in the for loop
    v.getAnAssignedValue() = initialCondition and
    DataFlow::localFlowStep(DataFlow::exprNode(initialCondition), DataFlow::exprNode(greaterOperand)) and
    // `terminalCondition` < `initialCondition`
    (
      upperBound(terminalCondition) < lowerBound(initialCondition)
      or
      (forstmt.conditionAlwaysFalse() or forstmt.conditionAlwaysTrue())
    )
  )
}

predicate illDefinedForStmtWrongDirection(
  ForStmt forstmt, Variable v, Expr initialCondition, Expr terminalCondition, boolean isIncr
) {
  illDefinedDecrForStmt(forstmt, v, initialCondition, terminalCondition) and isIncr = false
  or
  illDefinedIncrForStmt(forstmt, v, initialCondition, terminalCondition) and isIncr = true
}

bindingset[b]
private string forLoopdirection(boolean b) {
  if b = true then result = "upward" else result = "downward"
}

bindingset[b]
private string forLoopTerminalConditionRelationship(boolean b) {
  if b = true then result = "lower" else result = "higher"
}

predicate illDefinedForStmt(ForStmt for, string message) {
  exists(boolean isIncr, Variable v, Expr initialCondition, Expr terminalCondition |
    illDefinedForStmtWrongDirection(for, v, initialCondition, terminalCondition, isIncr) and
    if for.conditionAlwaysFalse()
    then
      message =
        "Ill-defined for-loop: a loop using variable \"" + v + "\" counts " +
          forLoopdirection(isIncr) + " from a value (" + initialCondition +
          "), but the terminal condition is always false."
    else
      if for.conditionAlwaysTrue()
      then
        message =
          "Ill-defined for-loop: a loop using variable \"" + v + "\" counts " +
            forLoopdirection(isIncr) + " from a value (" + initialCondition +
            "), but the terminal condition is always true."
      else
        message =
          "Ill-defined for-loop: a loop using variable \"" + v + "\" counts " +
            forLoopdirection(isIncr) + " from a value (" + initialCondition +
            "), but the terminal condition is " + forLoopTerminalConditionRelationship(isIncr) +
            " (" + terminalCondition + ")."
  )
}

from ForStmt forstmt, string message
where illDefinedForStmt(forstmt, message)
select forstmt, message
