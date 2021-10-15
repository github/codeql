import cpp

from MacroAccess mi, string type, string parent
where
  (if mi instanceof MacroInvocation then type = "MacroInvocation" else type = "MacroAccess") and
  if exists(mi.getParentInvocation())
  then parent = mi.getParentInvocation().toString()
  else parent = "none"
select mi, type, parent
