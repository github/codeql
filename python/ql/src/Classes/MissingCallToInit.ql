/**
 * @name Missing call to __init__ during object initialization
 * @description An omitted call to a super-class __init__ method may lead to objects of this class not being fully initialized.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/missing-call-to-init
 */

import python
import MethodCallOrder

from ClassObject self, FunctionObject initializer, FunctionObject missing
where
  self.lookupAttribute("__init__") = initializer and
  missing_call_to_superclass_method(self, initializer, missing, "__init__") and
  // If a superclass is incorrect, don't flag this class as well.
  not missing_call_to_superclass_method(self.getASuperType(), _, missing, "__init__") and
  not missing.neverReturns() and
  not self.failedInference() and
  not missing.isBuiltin() and
  not self.isAbstract()
select self,
  "Class " + self.getName() + " may not be initialized properly as $@ is not called from its $@.",
  missing, missing.descriptiveString(), initializer, "__init__ method"
