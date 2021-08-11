/**
 * Import this module into a `.ql` file of `@kind graph` to render a CFG. The
 * graph is restricted to nodes from `RelevantCfgNode`.
 */

private import codeql.Locations
import codeql.ruby.CFG

abstract class RelevantCfgNode extends CfgNode { }

query predicate nodes(RelevantCfgNode n, string attr, string val) {
  attr = "semmle.order" and
  val =
    any(int i |
      n =
        rank[i](RelevantCfgNode p, Location l |
          l = p.getLocation()
        |
          p
          order by
            l.getFile().getBaseName(), l.getFile().getAbsolutePath(), l.getStartLine(),
            l.getStartColumn()
        )
    ).toString()
}

query predicate edges(RelevantCfgNode pred, RelevantCfgNode succ, string attr, string val) {
  exists(SuccessorType t | succ = pred.getASuccessor(t) |
    attr = "semmle.label" and
    if t instanceof SuccessorTypes::NormalSuccessor then val = "" else val = t.toString()
  )
}
