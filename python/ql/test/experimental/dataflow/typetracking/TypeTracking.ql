import python
import experimental.dataflow.TypeTracker

Node tracked(TypeTracker t) {
  t.start() and
  result = TCfgNode(any(NameNode n | n.getId() = "tracked"))
  or
  exists(TypeTracker t2 | t = t2.step(tracked(t2), result))
}

from Node n, TypeTracker t
where n = tracked(t)
select n, t
