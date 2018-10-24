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

predicate illDefinedDecrForStmt( ForStmt forstmt, Variable v, Expr initialCondition, Expr terminalCondition ) { 
  v.getAnAssignedValue() = initialCondition
  and
  exists( 
    RelationalOperation rel |
    rel = forstmt.getCondition() |
    terminalCondition = rel.getGreaterOperand()
    and v.getAnAccess() = rel.getLesserOperand()
    and
    DataFlow::localFlowStep(DataFlow::exprNode(initialCondition), DataFlow::exprNode(rel.getLesserOperand()))
    )
  and
  exists( 
    DecrementOperation dec |
    dec = forstmt.getUpdate().(DecrementOperation)
    and dec.getAnOperand() = v.getAnAccess()
  )
  and
  ( 
    ( upperBound(initialCondition) < lowerBound(terminalCondition) )
    or
    ( forstmt.conditionAlwaysFalse() or forstmt.conditionAlwaysTrue() )
  )
}

predicate illDefinedIncrForStmt( ForStmt forstmt, Variable v, Expr initialCondition, Expr terminalCondition ) { 
  v.getAnAssignedValue() = initialCondition 
  and
  exists( 
    RelationalOperation rel |
    rel = forstmt.getCondition() |
    terminalCondition = rel.getLesserOperand()
    and v.getAnAccess() = rel.getGreaterOperand()
    and
    DataFlow::localFlowStep(DataFlow::exprNode(initialCondition), DataFlow::exprNode(rel.getGreaterOperand()))
  )
  and
  exists( IncrementOperation incr |
    incr = forstmt.getUpdate().(IncrementOperation)
    and
    incr.getAnOperand() = v.getAnAccess()
  )
  and
  ( 
    ( upperBound(terminalCondition) < lowerBound(initialCondition))
    or
    ( forstmt.conditionAlwaysFalse() or forstmt.conditionAlwaysTrue())
  )
}
 
predicate illDefinedForStmtWrongDirection( ForStmt forstmt, Variable v, Expr initialCondition, Expr terminalCondition
  , boolean isIncr ) {
  ( illDefinedDecrForStmt( forstmt, v, initialCondition, terminalCondition) and isIncr = false )
  or
  ( illDefinedIncrForStmt( forstmt, v, initialCondition, terminalCondition) and isIncr = true)
}
 
bindingset[b]
private string forLoopdirection(boolean b){
  if( b = true ) then  result = "upward" 
  else result = "downward"
}

bindingset[b]
private string forLoopTerminalConditionRelationship(boolean b){
  if( b = true ) then  result = "lower" 
  else result = "higher"
}

 predicate illDefinedForStmt( ForStmt for, string message ) {
  exists( 
    boolean isIncr, 
    Variable v,
    Expr initialCondition,
    Expr terminalCondition |
    illDefinedForStmtWrongDirection(for, v, initialCondition, terminalCondition, isIncr)
    and
    if( for.conditionAlwaysFalse() ) then 
    (
      message = "Ill-defined for-loop: a loop using variable \"" + v + "\" counts " 
      + forLoopdirection(isIncr) + " from a value ("+ initialCondition +"), but the terminal condition is always false."
    ) 
    else if 
    ( 
      for.conditionAlwaysTrue() ) then (
      message = "Ill-defined for-loop: a loop using variable \"" + v + "\" counts " 
      + forLoopdirection(isIncr) + " from a value ("+ initialCondition +"), but the terminal condition is always true."
    ) 
    else 
    (
      message = "Ill-defined for-loop: a loop using variable \"" + v + "\" counts " 
        + forLoopdirection(isIncr) + " from a value ("+ initialCondition +"), but the terminal condition is "
        + forLoopTerminalConditionRelationship(isIncr) + " (" + terminalCondition + ")."
    )
  )
}
 
from ForStmt forstmt, string message 
 where illDefinedForStmt(forstmt, message)
select forstmt, message
