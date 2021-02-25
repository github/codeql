/**
 * @kind graph
 */

import codeql_ruby.CFG

query predicate nodes(CfgNode n, string attr, string val) {
  attr = "semmle.order" and
  val =
    any(int i |
      n =
        rank[i](CfgNode p |
          |
          p
          order by
            p.getLocation().getFile().getBaseName(), p.getLocation().getFile().getAbsolutePath(),
            p.getLocation().getStartLine()
        )
    ).toString()
}

query predicate edges(CfgNode pred, CfgNode succ, string attr, string val) {
  exists(SuccessorType t | succ = pred.getASuccessor(t) |
    attr = "semmle.label" and
    if t instanceof SuccessorTypes::NormalSuccessor then val = "" else val = t.toString()
  )
}
