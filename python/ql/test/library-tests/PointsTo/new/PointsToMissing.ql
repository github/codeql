import python
import Util
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal

/* This test should return _no_ results. */
predicate relevant_node(ControlFlowNode n) {
  exists(CallNode c |
    c.getFunction().(NameNode).getId() = "check" and
    n = c.getAnArg()
  )
  or
  exists(Comment c, string filepath, int bl |
    n.getNode().getScope().getLocation().hasLocationInfo(filepath, bl, _, _, _) and
    c.getLocation().hasLocationInfo(filepath, bl, _, _, _) and
    c.getText().matches("%check") and
    not n.(NameNode).isStore()
  )
}

from ControlFlowNode f
where
  relevant_node(f) and
  not PointsTo::pointsTo(f, _, _, _)
select locate(f.getLocation(), "abchlr"), f.toString()
