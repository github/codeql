import python
private import LegacyPointsTo

from Value sup, Value cls
where Expressions::requireSubClass(cls, sup)
select cls, sup
