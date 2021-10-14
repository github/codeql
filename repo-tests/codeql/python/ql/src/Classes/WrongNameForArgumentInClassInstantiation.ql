/**
 * @name Wrong name for an argument in a class instantiation
 * @description Using a named argument whose name does not correspond to a
 *              parameter of the __init__ method of the class being
 *              instantiated, will result in a TypeError at runtime.
 * @kind problem
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-628
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/call/wrong-named-class-argument
 */

import python
import Expressions.CallArgs

from Call call, ClassValue cls, string name, FunctionValue init
where
  illegally_named_parameter(call, cls, name) and
  init = get_function_or_initializer(cls)
select call, "Keyword argument '" + name + "' is not a supported parameter name of $@.", init,
  init.getQualifiedName()
