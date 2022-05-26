import python

from ClassObject cls, string name
where class_declares_attribute(cls, name)
select cls.getPyClass().toString(), name
