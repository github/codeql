/**
 * @name Missing call to __del__ during object destruction
 * @description An omitted call to a super-class __del__ method may lead to class instances not being cleaned up properly.
 * @kind problem
 * @tags efficiency
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/missing-call-to-delete
 */

import python
import MethodCallOrder

from ClassObject self, FunctionObject missing
where
  missing_call_to_superclass_method(self, _, missing, "__del__") and
  not missing.neverReturns() and
  not self.failedInference() and
  not missing.isBuiltin()
select self,
  "Class " + self.getName() + " may not be cleaned up properly as $@ is not called during deletion.",
  missing, missing.descriptiveString()
