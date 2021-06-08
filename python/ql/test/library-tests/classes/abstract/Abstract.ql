import python

from ClassObject cls, string abstract
where
  not cls.isBuiltin() and
  if cls.isAbstract() then abstract = "yes" else abstract = "no"
select cls.toString(), abstract
