/**
 * @name Iterable can be either a string or a sequence
 * @description Iteration over either a string or a sequence in the same loop can cause errors that are hard to find.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       non-local
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/iteration-string-and-sequence
 */

import python


from
    For loop, ControlFlowNode iter, Value str, Value seq, ControlFlowNode seq_origin, ControlFlowNode str_origin
where
    loop.getIter().getAFlowNode() = iter and
    iter.pointsTo(str, str_origin) and
    iter.pointsTo(seq, seq_origin) and
    str.getClass() = ClassValue::str() and
    seq.getClass().isIterable() and
    not seq.getClass() = ClassValue::str()
select loop, "Iteration over $@, of class " + seq.getClass().getName() + ", may also iterate over $@.",
    seq_origin, "sequence", str_origin, "string"
