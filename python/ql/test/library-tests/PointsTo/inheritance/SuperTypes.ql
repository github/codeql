import python

from ClassObject cls, ClassObject sup
where
  not cls.isBuiltin() and
  sup = cls.getASuperType()
select cls.toString(), sup.toString()
