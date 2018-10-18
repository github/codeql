/**
 * @name Ill-defined for loop
 * @description A for-loop iteration expression goes backward with respect of the initialization statement and condition expression.
 * @id cpp/ill-defined-for-loop
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags external/microsoft/6293
 * @msrc.severity important
 */
import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

predicate illDefinedDecrForStmt( ForStmt forstmt, Variable v, Expr initialCondition, Expr terminalCondition ) { 
  v.getAnAssignedValue() = initialCondition 
  and
  exists( 
    RelationalOperation rel, Expr e |
    rel = forstmt.getCondition() |
    e = rel.getGreaterOperand()
    and v.getAnAccess() = rel.getLesserOperand()
    and terminalCondition = e
  )
  and
  (
    exists( 
      PostfixDecrExpr pdec |
      pdec = forstmt.getUpdate().(PostfixDecrExpr)
      and pdec.getAnOperand() = v.getAnAccess()
    ) or 
    exists( 
      PrefixDecrExpr pdec |
      pdec = forstmt.getUpdate().(PrefixDecrExpr)
      and pdec.getAnOperand() = v.getAnAccess()
    )
  )
  and
  upperBound(initialCondition) < lowerBound(terminalCondition)
}

predicate illDefinedIncrForStmt( ForStmt forstmt, Variable v, Expr initialCondition, Expr terminalCondition ) { 
  v.getAnAssignedValue() = initialCondition 
  and
  exists( 
    RelationalOperation rel, Expr e |
    rel = forstmt.getCondition() |
    e = rel.getLesserOperand()
    and v.getAnAccess() = rel.getGreaterOperand()
    and terminalCondition = e
  )
  and
  ( exists( PostfixIncrExpr pincr |
      pincr = forstmt.getUpdate().(PostfixIncrExpr)
      and
      pincr.getAnOperand() = v.getAnAccess()
    ) or 
    exists( PrefixIncrExpr pincr |
      pincr = forstmt.getUpdate().(PrefixIncrExpr)
      and
      pincr.getAnOperand() = v.getAnAccess()
    )
  )
  and
  upperBound(terminalCondition) < lowerBound(initialCondition)
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
    message = "Ill-defined for-loop: a loop using variable \"" + v + "\" counts " 
      + forLoopdirection(isIncr) + " from a value ("+ initialCondition +"), but the terminal condition is "
      + forLoopTerminalConditionRelationship(isIncr) + " (" + terminalCondition + ")."
  )
}
 
from ForStmt forstmt, string message 
 where illDefinedForStmt(forstmt, message)
select forstmt, message
