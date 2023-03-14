import swift
import Relevant

from Type t, string decls
where
  decls =
    strictconcat(ValueDecl d |
      relevant(d) and t = d.getInterfaceType() and d.toString().matches(["use_%", "def_%"])
    |
      d.toString(), ", "
    )
select t, t.getPrimaryQlClasses(), decls
