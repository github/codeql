import cpp
  
from FunctionCall alloc, FunctionCall free, LocalScopeVariable v
where allocationCall(alloc)
  and alloc = v.getAnAssignedValue()
  and freeCall(free, v.getAnAccess())
  and alloc.getASuccessor+() = free
select alloc, free
