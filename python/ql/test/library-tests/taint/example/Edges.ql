import python
import semmle.python.dataflow.TaintTracking
import semmle.python.dataflow.Implementation
import DilbertConfig

string shortString(TaintTrackingNode n) {
  if n.getContext().isTop()
  then
    result =
      n.getLocation().getStartLine() + ": " + n.getNode().toString() + n.getPath().extension() +
        " = " + n.getTaintKind()
  else
    result =
      n.getLocation().getStartLine() + ": " + n.getNode().toString() + n.getPath().extension() +
        " = " + n.getTaintKind() + " (" + n.getContext().toString() + ")"
}

bindingset[s, len]
string ljust(string s, int len) {
  result =
    s +
      "                                                                            "
          .prefix(len - s.length())
}

bindingset[s, len]
string format(string s, int len) {
  exists(string label |
    s = "" and label = "[dataflow]"
    or
    s != "" and label = s
  |
    result = ljust(label, len)
  )
}

from TaintTrackingNode p, TaintTrackingNode s, string label
where any(DilbertConfig config).(TaintTrackingImplementation).flowStep(p, s, label)
select format(shortString(p), 50), format(label, 10), shortString(s)
