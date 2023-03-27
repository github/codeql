import swift
import Relevant

from Type t, string decls
where
  decls = strictconcat(ValueDecl d | relevant(d) and t = d.getInterfaceType() | d.toString(), ", ")
select t, t.getPrimaryQlClasses(), decls
