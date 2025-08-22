import cpp

// Test that the child expressions of the aggregate literal are in the same
// order as in the source code and still match the field being initialized
// (which, in the case of designated initializers, will not necessarily match
// the order in which the fields were declared).
from ClassAggregateLiteral cal, int i, Field f
where cal.getAFieldExpr(f) = cal.getChild(i)
select cal, cal.getUnspecifiedType(), i, cal.getChild(i), f
