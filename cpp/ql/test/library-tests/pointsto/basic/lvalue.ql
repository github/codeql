import semmle.code.cpp.pointsto.PointsTo

from Element e
where lvalue(e)
select e
