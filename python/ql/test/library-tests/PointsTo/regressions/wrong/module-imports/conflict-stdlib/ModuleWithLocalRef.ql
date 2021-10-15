import python

from ModuleValue mv, ControlFlowNode ref, string in_stdlib, string local_external, string is_missing
where
  ref = mv.getAReference() and
  exists(ref.getLocation().getFile().getRelativePath()) and
  (
    if mv.getScope().getFile().inStdlib()
    then in_stdlib = "in stdlib"
    else in_stdlib = "not in stdlib"
  ) and
  (
    if exists(mv.getScope().getFile().getRelativePath())
    then local_external = "local"
    else local_external = "external"
  ) and
  (if mv.isAbsent() then is_missing = "missing" else is_missing = "not missing")
select "Module '" + mv.getName() + "' (" + local_external + ", " + in_stdlib + ", " + is_missing +
    ") referenced in local file", ref.getLocation().toString()
