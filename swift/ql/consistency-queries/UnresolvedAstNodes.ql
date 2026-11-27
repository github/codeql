import swift

from AstNode n, string cls
where
  cls = n.getAPrimaryQlClass() and
  cls.startsWith("Unresolved") and
  not n.getLocation() instanceof UnknownLocation
select n, cls
