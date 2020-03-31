import python

from ClassObject cls
where not cls.isC()
select cls.toString(), cls.getMetaClass().toString()
