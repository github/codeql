// query-type: graph
import cpp
import semmle.code.cpp.pointsto.PointsTo

newtype TElementOrSet =
  MkElement(Element e) or
  MkSet(int i) { pointstosets(i, _) }

class ElementOrSet extends TElementOrSet {
  int asSet() { this = MkSet(result) }

  Element asElement() { this = MkElement(result) }

  string toString() {
    result = any(Element e | this = MkElement(e)).toString() or
    result = any(int set | this = MkSet(set)).toString()
  }
}

predicate isSetFlowEnd(boolean isEdge, int x, int y, string label) {
  (setflow(x, _) or setflow(_, x)) and
  isEdge = false and
  x = y and
  label =
    "set: {" + concat(Element e | pointstosets(x, unresolveElement(e)) | e.toString(), ", ") + "}"
}

predicate isSetFlow(boolean isEdge, int x, int y, string label) {
  isEdge = true and
  setflow(x, y) and
  label = "sf"
}

predicate isPointsToSetSrc(boolean isEdge, int x, int y, string label) {
  pointstosets(x, _) and
  isEdge = false and
  x = y and
  label =
    "set: {" + concat(Element e | pointstosets(x, unresolveElement(e)) | e.toString(), ", ") + "}"
}

predicate isPointsToSetDest(boolean isEdge, Element x, Element y, string label) {
  exists(string loc, string name |
    pointstosets(_, unresolveElement(x)) and
    isEdge = false and
    x = y and
    (
      if exists(x.getLocation().toString())
      then loc = x.getLocation().toString()
      else loc = "<no location>"
    ) and
    (if exists(x.toString()) then name = x.toString() else name = "<no toString>") and
    label = loc + "\n" + name
  )
}

predicate isPointsToSets(boolean isEdge, int x, Element y, string label) {
  isEdge = true and
  pointstosets(x, unresolveElement(y)) and
  label =
    "pt: {" + concat(Element e | pointstosets(x, unresolveElement(e)) | e.toString(), ", ") +
      "} -> " + y.toString()
}

from boolean isEdge, ElementOrSet x, ElementOrSet y, string label
where
  isSetFlowEnd(isEdge, x.asSet(), y.asSet(), label) or
  isSetFlow(isEdge, x.asSet(), y.asSet(), label) or
  isPointsToSetSrc(isEdge, x.asSet(), y.asSet(), label) or
  isPointsToSetDest(isEdge, x.asElement(), y.asElement(), label) or
  isPointsToSets(isEdge, x.asSet(), y.asElement(), label)
select "pointsto", isEdge, x, y, label
