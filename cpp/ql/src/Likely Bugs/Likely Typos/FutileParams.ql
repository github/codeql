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

from FunctionCall fc, Function f
  where f = fc.getTarget() and not f.isVarargs()
  /* There must be a mismatch between number of call arguments and number of parameters in some
   * non-implicit declaration of Function f
   */
  and exists ( FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() | not fde.isImplicit() and fde.getNumberOfParameters() != fc.getNumberOfArguments())
  /* There must be no _definition_ of Function f whose number of parameters matches number of call arguments */
  and not exists ( FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() | fde.isDefinition() and fde.getNumberOfParameters() = fc.getNumberOfArguments())
select fc  

  