import python

from ClassObject cls, ClassObject base, int n
where
  not cls.isBuiltin() and
  base = cls.getBaseType(n)
select cls.toString(), n, base.toString()
