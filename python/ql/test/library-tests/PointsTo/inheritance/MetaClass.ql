import python

from ClassObject cls, ClassObject meta
where
  not cls.isBuiltin() and
  meta = cls.getMetaClass()
select cls.toString(), meta.toString()
