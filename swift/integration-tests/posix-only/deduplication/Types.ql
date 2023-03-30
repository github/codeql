import swift
import Relevant

from Type t, string decls, string canonical
where
  decls =
    strictconcat(ValueDecl d |
      relevant(d) and
      t = [d.getInterfaceType(), d.getInterfaceType().getCanonicalType()] and
      d.toString().matches(["use_%", "def_%"])
    |
      d.toString(), ", "
    ) and
  if t = t.getCanonicalType() then canonical = "" else canonical = t.getCanonicalType().toString()
select t, t.getPrimaryQlClasses(), decls, canonical
