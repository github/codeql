import python

from ModuleValue mv, ControlFlowNode ref, string local_external
where
  ref = mv.getAReference() and
  exists(mv.getScope().getFile().getRelativePath()) and
  (
    if exists(ref.getLocation().getFile().getRelativePath())
    then local_external = "local"
    else local_external = "external"
  )
select "Local module", mv, "referenced in " + local_external + " file called",
  ref.getLocation().getFile().getShortName()
