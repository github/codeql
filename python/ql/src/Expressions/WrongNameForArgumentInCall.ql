/**
 * @name Wrong name for an argument in a call
 * @description Using a named argument whose name does not correspond to a
 *              parameter of the called function or method, will result in a
 *              TypeError at runtime.
 * @kind problem
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-628
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/call/wrong-named-argument
 */

import python
import Expressions.CallArgs

from Call call, FunctionObject func, string name
where
  illegally_named_parameter_objectapi(call, func, name) and
  not func.isAbstract() and
  not exists(FunctionObject overridden |
    func.overrides(overridden) and overridden.getFunction().getAnArg().(Name).getId() = name
  )
select call, "Keyword argument '" + name + "' is not a supported parameter name of $@.", func,
  func.descriptiveString()
