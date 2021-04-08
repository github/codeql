import python

from ClassObject cls, string name, BuiltinPropertyObject p
where
  cls.declaredAttribute(name) = p and
  (cls = theObjectType() or cls = theListType() or cls = theTypeType())
select cls.toString(), name, p.toString(), p.getGetter().toString(), p.getSetter().toString(),
  p.getDeleter().toString()
