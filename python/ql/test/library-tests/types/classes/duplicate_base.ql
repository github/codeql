import python
private import LegacyPointsTo

from ClassObject cls
where cls.hasDuplicateBases()
select cls.toString()
