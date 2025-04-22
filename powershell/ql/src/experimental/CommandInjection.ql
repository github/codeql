/**
 * @name Command Injection
 * @description Variable expression executed as command
 * @kind problem
 * @id powershell/microsoft/public/tainted-command
 * @problem.severity warning
 * @precision low
 * @tags security
 */

import powershell

predicate containsScope(VarAccess outer, VarAccess inner) {
  outer.getVariable().getName() = inner.getVariable().getName() and
  outer != inner
}

predicate constantTernaryExpression(ConditionalExpr ternary) {
  onlyConstantExpressions(ternary.getIfTrue()) and onlyConstantExpressions(ternary.getIfFalse())
}

predicate constantBinaryExpression(BinaryExpr binary) {
  onlyConstantExpressions(binary.getLeft()) and onlyConstantExpressions(binary.getRight())
}

predicate onlyConstantExpressions(Expr expr) {
  expr instanceof StringConstExpr or
  constantBinaryExpression(expr) or
  constantTernaryExpression(expr)
}

VarAccess getNonConstantVariableAssignment(VarAccess varexpr) {
  exists(AssignStmt assignment |
    not onlyConstantExpressions(assignment.getRightHandSide()) and
    result = assignment.getLeftHandSide()
  ) and
  containsScope(result, varexpr)
}

VarAccess getParameterWithVariableScope(VarAccess varexpr) {
  exists(Parameter parameter |
    result = parameter.getAnAccess() and
    containsScope(result, varexpr)
  )
}

Expr getAllSubExpressions(Expr expr) {
  result = expr or
  result = getAllSubExpressions(expr.(ArrayLiteral).getAnExpr()) or
  result =
    getAllSubExpressions(expr.(ArrayExpr)
          .getStmtBlock()
          .getAStmt()
          .(ExprStmt)
          .getExpr()
          .(Pipeline)
          .getAComponent())
}

Expr dangerousCommandElement(CallExpr command) {
  (
    command instanceof CallOperator or
    command.getName() = "Invoke-Expression"
  ) and
  result = getAllSubExpressions(command.getAnArgument())
}

from Expr commandarg, VarAccess unknownDeclaration
where
  exists(CallExpr command |
    (
      unknownDeclaration = getNonConstantVariableAssignment(commandarg) or
      unknownDeclaration = getParameterWithVariableScope(commandarg)
    ) and
    commandarg = dangerousCommandElement(command)
  )
select commandarg.(VarAccess).getLocation(), "Unsafe flow to command argument from $@.",
  unknownDeclaration, unknownDeclaration.getVariable().getName()
