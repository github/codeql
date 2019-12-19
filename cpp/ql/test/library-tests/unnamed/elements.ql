import cpp

from Element e, string s
where
  not e instanceof Folder and
  exists(e.toString()) and // Work around `VariableDeclarationEntry.toString()` not holding
  if e instanceof VariableAccess then s = "Variable access" else s = "Other"
select e, s
