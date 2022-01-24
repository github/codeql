/**
 * @kind path-problem
 */

import csharp
import DataFlow

private predicate relevantPathNode(PathNode n) {
  exists(File f | f = n.getNode().getLocation().getFile() |
    f.fromSource()
    or
    f.getBaseName() = "DataFlow.dll"
  )
}

query predicate edges(PathNode a, PathNode b) {
  PathGraph::edges(a, b) and
  relevantPathNode(a) and
  relevantPathNode(b)
}

query predicate nodes(PathNode n, string key, string val) {
  PathGraph::nodes(n, key, val) and
  relevantPathNode(n)
}

query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
  PathGraph::subpaths(arg, par, ret, out) and
  relevantPathNode(arg) and
  relevantPathNode(par) and
  relevantPathNode(ret) and
  relevantPathNode(out)
}

class FlowConfig extends Configuration {
  FlowConfig() { this = "FlowConfig" }

  override predicate isSource(Node source) { source.asExpr() instanceof Literal }

  override predicate isSink(Node sink) {
    exists(LocalVariable decl | sink.asExpr() = decl.getInitializer())
  }
}

from PathNode source, PathNode sink, FlowConfig config
where config.hasFlowPath(source, sink)
select source, sink, sink, "$@", sink, sink.toString()
