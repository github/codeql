import semmle.code.cpp.pointsto.PointsTo

from Element src, Element dest
where flow(src, dest)
select src, dest
