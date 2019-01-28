/**
 * @name Non-empty call to function declared without parameters
 * @description A call to a function declared without parameters has arguments, which may indicate
 *              that the code does not follow the author's intent.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/futile-params
 * @tags correctness
 *       maintainability
 */

import cpp

from Function f, FunctionCall fc
where fc.getTarget() = f
  and f.getNumberOfParameters() = 0
  and not f.isVarargs()
  and fc.getNumberOfArguments() != 0
  and not f instanceof BuiltInFunction
  and exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() | not fde.isImplicit())
select fc, "This call has arguments, but $@ is not declared with any parameters.", f, f.toString()
