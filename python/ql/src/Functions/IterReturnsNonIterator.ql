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

cached
ClassObject return_type(FunctionObject f) {
    exists(ControlFlowNode n, Return ret |
        ret.getScope() = f.getFunction() and
        ret.getValue() = n.getNode() and
        n.refersTo(_, result, _)
    )
}

from ClassObject container, FunctionObject iter, ClassObject iterator
where
    iter = container.lookupAttribute("__iter__") and
    iterator = return_type(iter) and
    not iterator.isIterator()
select iterator,
    "Class " + iterator.getName() +
        " is returned as an iterator (by $@) but does not fully implement the iterator interface.",
    iter, iter.getName()
