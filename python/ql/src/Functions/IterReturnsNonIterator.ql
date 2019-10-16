/**
 * @name __iter__ method returns a non-iterator
 * @description The '__iter__' method returns a non-iterator which, if used in a 'for' loop, would raise a 'TypeError'.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/iter-returns-non-iterator
 */

import python

FunctionObject iter_method(ClassObject t) { result = t.lookupAttribute("__iter__") }

cached
ClassObject return_type(FunctionObject f) {
    exists(ControlFlowNode n, Return ret |
        ret.getScope() = f.getFunction() and
        ret.getValue() = n.getNode() and
        n.refersTo(_, result, _)
    )
}

from ClassObject t, FunctionObject iter
where
    exists(ClassObject ret_t |
        iter = iter_method(t) and
        ret_t = return_type(iter) and
        not ret_t.isIterator()
    )
select iter, "The '__iter__' method of iterable class $@ does not return an iterator.", t,
    t.getName()
