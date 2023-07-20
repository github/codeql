/**
 * @kind path-problem
 */

import csharp
import Flow::PathGraph

private predicate relevantPathNode(Flow::PathNode n) {
  exists(File f | f = n.getNode().getLocation().getFile() |
    f.fromSource()
    or
    f.getBaseName() = "DataFlow.dll"
  )
}

query predicate edges(Flow::PathNode a, Flow::PathNode b) {
  Flow::PathGraph::edges(a, b) and
  relevantPathNode(a) and
  relevantPathNode(b)
}

query predicate nodes(Flow::PathNode n, string key, string val) {
  Flow::PathGraph::nodes(n, key, val) and
  relevantPathNode(n)
}

query predicate subpaths(
  Flow::PathNode arg, Flow::PathNode par, Flow::PathNode ret, Flow::PathNode out
) {
  Flow::PathGraph::subpaths(arg, par, ret, out) and
  relevantPathNode(arg) and
  relevantPathNode(par) and
  relevantPathNode(ret) and
  relevantPathNode(out)
}

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof Literal }

  predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable decl | sink.asExpr() = decl.getInitializer())
  }
}

module Flow = DataFlow::Global<FlowConfig>;

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select source, sink, sink, "$@", sink, sink.toString()
