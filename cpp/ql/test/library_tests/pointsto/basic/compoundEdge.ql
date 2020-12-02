import semmle.code.cpp.pointsto.PointsTo

from Element parent, Element element, string label, Element other, int kind
where compoundEdge(parent, element, label, other, kind)
select parent.getLocation().getStartLine(), parent, element.getLocation().getStartLine(), element,
  label, other.getLocation().getStartLine(), other, kind
