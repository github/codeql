/**
 * @name Unused parameter
 * @description Parameter is defined but not used
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 *       readability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision medium
 * @id py/unused-parameter
 */

import python
import Definition
private import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate unused_parameter(Function f, LocalVariable v) {
  v.isParameter() and
  v.getScope() = f and
  not name_acceptable_for_unused_variable(v) and
  not exists(NameNode u | u.uses(v)) and
  not exists(Name inner, LocalVariable iv |
    inner.uses(iv) and iv.getId() = v.getId() and inner.getScope().getScope() = v.getScope()
  )
}

predicate is_abstract(Function func) { func.getADecorator().(Name).getId().matches("%abstract%") }

predicate is_overridden(Function f) {
  exists(Class cls | f.getScope() = cls |
    DuckTyping::hasMethod(getADirectSubclass(cls), f.getName())
  )
}

from Function f, LocalVariable v
where
  v.getId() != "self" and
  unused_parameter(f, v) and
  not DuckTyping::overridesMethod(f) and
  not is_overridden(f) and
  not is_abstract(f)
select f, "The parameter '" + v.getId() + "' is never used."
