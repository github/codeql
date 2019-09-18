/**
 * @name Iterator does not return self from __iter__ method
 * @description Iterator does not return self from __iter__ method, violating the iterator protocol.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/iter-returns-non-self
 */

import python

Function iter_method(ClassObject t) {
		result = ((FunctionObject)t.lookupAttribute("__iter__")).getFunction()
}

predicate is_self(Name value, Function f) {
	 value.getVariable() = ((Name)f.getArg(0)).getVariable()
}

predicate returns_non_self(Function f) {
		exists(f.getFallthroughNode())
		or
		exists(Return r | r.getScope() = f and not is_self(r.getValue(), f))
		or
		exists(Return r | r.getScope() = f and not exists(r.getValue()))
}

from ClassObject t, Function iter
where t.isIterator() and iter = iter_method(t) and returns_non_self(iter)
select t, "Class " + t.getName() + " is an iterator but its $@ method does not return 'self'.", iter, iter.getName()