/**
 * @id test-plot-cfg
 * @kind graph
 */

import java

class RelevantNode extends ControlFlowNode {
  RelevantNode() { this.getLocation().getFile().isSourceFile() }
}

query predicate nodes(RelevantNode n, string attr, string val) {
  attr = "semmle.order" and
  val =
    any(int i |
      n =
        rank[i](RelevantNode p, Location l |
          l = p.getLocation()
        |
          p
          order by
            l.getFile().getBaseName(), l.getFile().getAbsolutePath(), l.getStartLine(),
            l.getStartColumn(), l.getEndLine(), l.getEndColumn(), p.toString()
        )
    ).toString()
}

query predicate edges(RelevantNode pred, RelevantNode succ, string attr, string val) {
  attr = "semmle.label" and
  succ = pred.getASuccessor() and
  val = ""
  or
  attr = "semmle.order" and
  val =
    any(int i |
      succ =
        rank[i](RelevantNode s, Location l |
          s = pred.getASuccessor() and
          l = s.getLocation()
        |
          s
          order by
            l.getFile().getBaseName(), l.getFile().getAbsolutePath(), l.getStartLine(),
            l.getStartColumn(), l.getEndLine(), l.getEndColumn()
        )
    ).toString()
}
