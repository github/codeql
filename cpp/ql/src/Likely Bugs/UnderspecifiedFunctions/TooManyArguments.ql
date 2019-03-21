/**
 * @name Call to function with extraneous parameters
 * @description A function call to a function passed more arguments than there are
 *              declared parameters of the function.  This may indicate
 *              that the code does not follow the author's intent.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/too-many-arguments
 * @tags correctness
 *       maintainability
 */

import cpp

from FunctionCall fc, Function f
where
  f = fc.getTarget() and
  not f.isVarargs() and
  // There must be a zero-parameter declaration (explicit or implicit)
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    fde.getNumberOfParameters() = 0
  ) and
  // There must not exist a declaration with the number of parameters
  // at least as large as the number of call arguments
  not exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    fde.getNumberOfParameters() >= fc.getNumberOfArguments()
  )
select fc, "This call has more arguments than required by $@.", f, f.toString()
