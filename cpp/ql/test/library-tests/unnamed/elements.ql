import cpp

from Element e, string s
where
  not e instanceof Folder and
  if e instanceof VariableAccess then s = "Variable access" else s = "Other"
select e, s
