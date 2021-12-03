/**
 * @name Multiple calls to `__del__` during object destruction
 * @description A duplicated call to a super-class `__del__` method may lead to class instances not be cleaned up properly.
 * @kind problem
 * @tags efficiency
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/multiple-calls-to-delete
 */

import python
import MethodCallOrder

from ClassObject self, FunctionObject multi
where
  multiple_calls_to_superclass_method(self, multi, "__del__") and
  not multiple_calls_to_superclass_method(self.getABaseType(), multi, "__del__") and
  not exists(FunctionObject better |
    multiple_calls_to_superclass_method(self, better, "__del__") and
    better.overrides(multi)
  ) and
  not self.failedInference()
select self,
  "Class " + self.getName() +
    " may not be cleaned up properly as $@ may be called multiple times during destruction.", multi,
  multi.descriptiveString()
