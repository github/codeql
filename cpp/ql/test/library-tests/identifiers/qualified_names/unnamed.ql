// This query lists the declarations that don't have a qualified name
import cpp

from Declaration d
where
  (
    not exists(d.getQualifiedName())
    or
    not d.hasQualifiedName(_, _, _)
  ) and
  exists(d.getFile().getRelativePath())
select d
