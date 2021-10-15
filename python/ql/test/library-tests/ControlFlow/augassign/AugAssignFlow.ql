import python

int lineof(ControlFlowNode f) { result = f.getNode().getLocation().getStartLine() }

from ControlFlowNode defn, ControlFlowNode use
where
  defn.getNode() = use.getNode() and
  defn.isStore() and
  use.isLoad()
select defn.toString(), use.toString(), lineof(defn)
