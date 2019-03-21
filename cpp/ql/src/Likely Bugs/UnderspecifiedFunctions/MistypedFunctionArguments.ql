/**
 * @name Call to a function with one or more incompatible arguments
 * @description A call to a function with at least one argument whose type does
 * not match the type of the corresponding function parameter.  This may indicate
 * that the author is not familiar with the function being called.  Passing mistyped
 * arguments on a stack may lead to unpredictable function behavior.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/mistyped-function-arguments
 * @tags correctness
 *       maintainability
 */

import cpp

from FunctionCall fc, Function f, Parameter p
where
  f = fc.getTarget() and
  p = f.getAParameter() and
  not f.isVarargs() and
  p.getIndex() < fc.getNumberOfArguments() and
  // There must be a zero-parameter declaration
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    fde.getNumberOfParameters() = 0
  ) and
  // Parameter p and its corresponding call argument must have mismatched types
  p.getType() != fc.getArgument(p.getIndex()).getType()
select fc, "Calling $@: $@ is incompatible with $@.", f, f.toString(), fc.getArgument(p.getIndex()),
  fc.getArgument(p.getIndex()).toString(), p, p.getTypedName()
