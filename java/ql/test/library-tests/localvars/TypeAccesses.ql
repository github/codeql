import default

// this query does not find List<String> on line 13, since its parent is a Parameter, which is not an ExprParent
from TypeAccess ta
select ta, ta.getParent(), ta.getIndex()
