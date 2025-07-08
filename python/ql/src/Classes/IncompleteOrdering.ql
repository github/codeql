/**
 * @name Incomplete ordering
 * @description Class defines one or more ordering method but does not define all 4 ordering comparison methods
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

predicate totalOrdering(Class cls) {
  cls.getADecorator() =
    API::moduleImport("functools").getMember("total_ordering").asSource().asExpr()
}

Function getMethod(Class cls, string name) {
  result = cls.getAMethod() and
  result.getName() = name
}

predicate definesStrictOrdering(Class cls, Function meth) {
  meth = getMethod(cls, "__lt__")
  or
  not exists(getMethod(cls, "__lt__")) and
  meth = getMethod(cls, "__gt__")
}

predicate definesNonStrictOrdering(Class cls, Function meth) {
  meth = getMethod(cls, "__le__")
  or
  not exists(getMethod(cls, "__le__")) and
  meth = getMethod(cls, "__ge__")
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
select cls, "This class implements $@, but does not implement an " + missing + " method.", defined,
  defined.getName()
