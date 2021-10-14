/**
 * @name `__init__` method returns a value
 * @description Explicitly returning a value from an `__init__` method will raise a TypeError.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/explicit-return-in-init
 */

import python

from Return r, Expr rv
where
  exists(Function init | init.isInitMethod() and r.getScope() = init) and
  r.getValue() = rv and
  not rv.pointsTo(Value::none_()) and
  not exists(FunctionValue f | f.getACall() = rv.getAFlowNode() | f.neverReturns()) and
  // to avoid double reporting, don't trigger if returning result from other __init__ function
  not exists(Attribute meth | meth = rv.(Call).getFunc() | meth.getName() = "__init__")
select r, "Explicit return in __init__ method."
