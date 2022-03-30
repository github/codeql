import cpp

from Element e
where
  not e.getLocation() instanceof UnknownLocation and
  not e instanceof Folder
select e, any(boolean b | if e.isInMacroExpansion() then b = true else b = false)
