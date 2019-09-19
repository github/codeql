import cpp

from Variable v, string d, string c
where
  if v instanceof MemberVariable
  then (
    d = "MemberVariable" and c = v.(MemberVariable).getDeclaringType().getName()
  ) else (
    d = "Variable" and c = "<none>"
  )
select v, v.getType(), d, c
