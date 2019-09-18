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

predicate is_a_string_type(ClassObject seqtype) {
    seqtype = theBytesType() and major_version() = 2
    or 
    seqtype = theUnicodeType() 
}

from For loop, ControlFlowNode iter, Object str, Object seq, ControlFlowNode seq_origin, ClassObject strtype, ClassObject seqtype, ControlFlowNode str_origin
where loop.getIter().getAFlowNode() = iter and
iter.refersTo(str, strtype, str_origin) and 
iter.refersTo(seq, seqtype, seq_origin) and 
is_a_string_type(strtype) and 
seqtype.isIterable() and
not is_a_string_type(seqtype)

select loop, "Iteration over $@, of class " + seqtype.getName() + ", may also iterate over $@.", seq_origin, "sequence", str_origin, "string"