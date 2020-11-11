import python

from ModuleValue project_module, ControlFlowNode ref, string part_of_project
where
  exists(project_module.getScope().getFile().getRelativePath()) and
  ref = project_module.getAReference() and
  (
    exists(ref.getLocation().getFile().getRelativePath()) and
    part_of_project = "is part of this projects code"
    or
    not exists(ref.getLocation().getFile().getRelativePath()) and
    part_of_project = "is NOT part of this projects code"
  )
select "Local module '" + project_module.getName() + "' referenced in module '" +
    ref.getEnclosingModule().getName() + "' which " + part_of_project
