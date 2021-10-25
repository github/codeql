import javascript

from ClassDefinition cls
where cls.isAbstract()
select cls, cls.getName()
