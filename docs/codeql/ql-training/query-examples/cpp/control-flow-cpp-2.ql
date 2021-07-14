import cpp
  
from FunctionCall free, LocalScopeVariable v, VariableAccess u
where freeCall(free, v.getAnAccess())
  and u = v.getAnAccess()
  and u.isRValue()
  and free.getASuccessor+() = u
select free, u