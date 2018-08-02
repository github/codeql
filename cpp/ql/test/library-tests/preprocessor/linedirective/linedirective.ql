import cpp

from Element e, string comment
where (e instanceof Include or e instanceof DeclarationEntry or e instanceof Macro)
and (e.getFile().toString() != "")
and if exists(((Include)e).getIncludedFile()) then comment = ((Include)e).getIncludedFile().toString() else comment = ""
select e, comment
