import ruby

from ConstantAccess a, string kind
where
  a instanceof ConstantReadAccess and kind = "read"
  or
  a instanceof ConstantWriteAccess and kind = "write"
select a, kind, a.getName(), a.getAPrimaryQlClass()
