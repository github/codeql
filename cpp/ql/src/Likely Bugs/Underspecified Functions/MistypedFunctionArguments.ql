/**
 * @name Call to a function with one or more incompatible arguments
 * @description When the type of a function argument is not compatible
 * with the type of the corresponding parameter, it may lead to
 * unpredictable behavior.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/mistyped-function-arguments
 * @tags correctness
 *       maintainability
 */

import cpp
import MistypedFunctionArguments

from FunctionCall fc, Function f, Parameter p
where mistypedFunctionArguments(fc, f, p)
select fc, "Calling $@: argument $@ of type $@ is incompatible with parameter $@.", f, f.toString(),
  fc.getArgument(p.getIndex()) as arg, arg.toString(),
  arg.getExplicitlyConverted().getUnspecifiedType() as atype, atype.toString(), p, p.getTypedName()
