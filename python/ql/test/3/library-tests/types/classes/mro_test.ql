import python

from ClassObject cls, ClassObject sup
where not cls.isC()
select cls.toString(), sup.toString(), cls.nextInMro(sup).toString()
