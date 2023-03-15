import swift
import Relevant

from Decl d, string type
where
  relevant(d) and
  (
    not exists(d.(ValueDecl).getInterfaceType()) and type = "-"
    or
    exists(Type t |
      t = d.(ValueDecl).getInterfaceType() and
      type = t.toString() + " [" + t.getPrimaryQlClasses() + "]"
    )
  )
select d, d.getPrimaryQlClasses(), type
