/**
 * @name Deprecated slice method
 * @description Defining special methods for slicing has been deprecated since Python 2.0.
 * @kind problem
 * @tags maintainability
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/deprecated-slice-method
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate slice_method_name(string name) {
  name = "__getslice__" or name = "__setslice__" or name = "__delslice__"
}

from Function f, string meth
where
  f.isMethod() and
  slice_method_name(meth) and
  f.getName() = meth and
  not DuckTyping::overridesMethod(f) and
  not DuckTyping::hasUnresolvedBase(getADirectSuperclass*(f.getScope()))
select f, meth + " method has been deprecated since Python 2.0."
