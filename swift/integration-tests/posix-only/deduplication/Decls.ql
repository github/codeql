import swift
import Relevant

from Decl d, string type
where
  relevant(d) and
  (
    not d instanceof ValueDecl and type = "-"
    or
    type = d.(ValueDecl).getInterfaceType().toString()
  )
select d, d.getPrimaryQlClasses(), type
