import python

from ClassObject cls, string name, string kind, Object o
where
  not cls.isC() and
  name.matches("\\_\\_%\\_\\_") and
  not o = theObjectType().lookupAttribute(name) and
  (
    o = cls.lookupAttribute(name) and kind = "has"
    or
    o = cls.declaredAttribute(name) and kind = "declares"
  )
select cls.toString(), kind, name, o.toString()
