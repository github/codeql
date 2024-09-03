/**
 * @name Command Injection
 * @description Variable expression executed as command
 * @kind problem
 * @id powershell/command-injection
 * @problem.severity warning
 * @precision low
 * @tags security
 */

import powershell

predicate containsScope(VariableExpression outer, VariableExpression inner) {
  outer.getUserPath() = inner.getUserPath() and
  outer != inner
}

predicate constantTernaryExpression(TernaryExpression ternary) {
  onlyConstantExpressions(ternary.getIfTrue()) and onlyConstantExpressions(ternary.getIfFalse())
}

predicate constantBinaryExpression(BinaryExpression binary) {
  onlyConstantExpressions(binary.getLeftHandSide()) and onlyConstantExpressions(binary.getRightHandSide())
}

predicate onlyConstantExpressions(Expression expr){
  expr instanceof StringConstantExpression or constantBinaryExpression(expr) or constantTernaryExpression(expr)
}

VariableExpression getNonConstantVariableAssignment(VariableExpression varexpr) {
  (
    exists(AssignmentStatement assignment |
      not onlyConstantExpressions(assignment.getRightHandSide().(CommandExpression).getExpression()) and
      result = assignment.getLeftHandSide()
    )
  ) and
  containsScope(result, varexpr)
}

VariableExpression getParameterWithVariableScope(VariableExpression varexpr) {
  exists(Parameter parameter |
    result = parameter.getName() and
    containsScope(result, varexpr)
  )
}

Expression getAllSubExpressions(Expression expr)
{
  result = expr or
  result = getAllSubExpressions(expr.(ArrayLiteral).getAnElement()) or
  result = getAllSubExpressions(expr.(ArrayExpression).getStatementBlock().getAStatement().(Pipeline).getAComponent().(CommandExpression).getExpression())
}

Expression dangerousCommandElement(Command command)
{
  (
    command.getKind() = 28 or
    command.getName() = "Invoke-Expression"
  ) and
  result = getAllSubExpressions(command.getAnElement())
}

from Expression commandarg, VariableExpression unknownDeclaration
where
  exists(Command command |
    (
      unknownDeclaration = getNonConstantVariableAssignment(commandarg) or
      unknownDeclaration = getParameterWithVariableScope(commandarg)
    )
    and
    commandarg = dangerousCommandElement(command)
  )
select commandarg.(VariableExpression).getLocation(), "Unsafe flow to command argument from $@.",
  unknownDeclaration, unknownDeclaration.getUserPath()
