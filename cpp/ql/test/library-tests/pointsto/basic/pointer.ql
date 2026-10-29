import semmle.code.cpp.pointsto.PointsTo

from Element src, Element dest
where pointer(src, dest)
select src, dest
