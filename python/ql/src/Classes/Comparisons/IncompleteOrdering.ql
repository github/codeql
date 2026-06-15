/**
 * @name Incomplete ordering
 * @description Class defines ordering comparison methods, but does not define both strict and nonstrict ordering methods, to ensure all four comparison operators behave as expected.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/incomplete-ordering
 */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch
import semmle.python.ApiGraphs

/** Holds if `cls` has the `functools.total_ordering` decorator. */
predicate totalOrdering(Class cls) {
  API::moduleImport("functools")
      .getMember("total_ordering")
      .asSource()
      .flowsTo(DataFlow::exprNode(cls.getADecorator()))
}

predicate definesStrictOrdering(Class cls, Function meth) {
  meth = cls.getMethod("__lt__")
  or
  not exists(cls.getMethod("__lt__")) and
  meth = cls.getMethod("__gt__")
}

predicate definesNonStrictOrdering(Class cls, Function meth) {
  meth = cls.getMethod("__le__")
  or
  not exists(cls.getMethod("__le__")) and
  meth = cls.getMethod("__ge__")
}

predicate missingComparison(Class cls, Function defined, string missing) {
  definesStrictOrdering(cls, defined) and
  not definesNonStrictOrdering(getADirectSuperclass*(cls), _) and
  missing = "__le__ or __ge__"
  or
  definesNonStrictOrdering(cls, defined) and
  not definesStrictOrdering(getADirectSuperclass*(cls), _) and
  missing = "__lt__ or __gt__"
}

from Class cls, Function defined, string missing
where
  not totalOrdering(cls) and
  missingComparison(cls, defined, missing)
select cls, "This class implements $@, but does not implement " + missing + ".", defined,
  defined.getName()
