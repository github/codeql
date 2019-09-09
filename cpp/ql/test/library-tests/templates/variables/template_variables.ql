import cpp

from Variable v, VariableAccess a, int i, string s
where
  v = a.getTarget() and
  if exists(v.getATemplateArgument())
  then s = v.getTemplateArgument(i).toString()
  else (
    s = "<none>" and i = -1
  )
select v, a, i, s
