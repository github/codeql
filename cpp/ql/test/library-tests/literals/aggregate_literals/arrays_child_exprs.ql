import cpp

// Test that the child expressions of the aggregate literal are in the same
// order as in the source code and still match the element being initialized
// (which, in the case of designated initializers, will not necessarily match
// the order of the array elements).
from ArrayAggregateLiteral aal, int childIndex, int elementIndex
where aal.getElementExpr(elementIndex) = aal.getChild(childIndex)
select aal, aal.getUnspecifiedType(), childIndex, aal.getChild(childIndex), elementIndex
