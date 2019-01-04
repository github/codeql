/**
 * @name __init__ method returns a value
 * @description Explicitly returning a value from an __init__ method will raise a TypeError.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/explicit-return-in-init
 */

import python

from Return r
where exists(Function init | init.isInitMethod() and
r.getScope() = init and exists(r.getValue())) and
not r.getValue() instanceof None and
not exists(FunctionObject f | f.getACall() = r.getValue().getAFlowNode() |
    f.neverReturns()
) and
not exists(Attribute meth | meth = ((Call)r.getValue()).getFunc() | meth.getName() = "__init__")
select r, "Explicit return in __init__ method."
