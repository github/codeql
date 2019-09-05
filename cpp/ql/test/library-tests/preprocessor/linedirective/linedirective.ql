import cpp

from Element e, string comment
where
  (e instanceof Include or e instanceof DeclarationEntry or e instanceof Macro) and
  e.getFile().toString() != "" and
  if exists(e.(Include).getIncludedFile())
  then comment = e.(Include).getIncludedFile().toString()
  else comment = ""
select e, comment
