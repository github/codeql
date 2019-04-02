/**
 * @name Call to function with fewer arguments than declared parameters
 * @description A function call passed fewer arguments than the number of
 *              declared parameters of the function. This may indicate
 *              that the code does not follow the author's intent. It is also a vulnerability,
 *              since the function is like to operate on undefined data.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id cpp/too-few-arguments
 * @tags correctness
 *       maintainability
 *       security
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
  // There is an explicit declaration of the function whose parameter count is larger
  // than the number of call arguments
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not fde.isImplicit() and fde.getNumberOfParameters() > fc.getNumberOfArguments()
  )
select fc, "This call has fewer arguments than required by $@.", f, f.toString()
