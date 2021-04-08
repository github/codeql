/**
 * @name Multiple calls to __init__ during object initialization
 * @description A duplicated call to a super-class __init__ method may lead to objects of this class not being properly initialized.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/multiple-calls-to-init
 */

import python
import MethodCallOrder

from ClassObject self, FunctionObject multi
where
  multi != theObjectType().lookupAttribute("__init__") and
  multiple_calls_to_superclass_method(self, multi, "__init__") and
  not multiple_calls_to_superclass_method(self.getABaseType(), multi, "__init__") and
  not exists(FunctionObject better |
    multiple_calls_to_superclass_method(self, better, "__init__") and
    better.overrides(multi)
  ) and
  not self.failedInference()
select self,
  "Class " + self.getName() +
    " may not be initialized properly as $@ may be called multiple times during initialization.",
  multi, multi.descriptiveString()
