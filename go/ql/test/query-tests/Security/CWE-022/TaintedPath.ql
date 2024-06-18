/**
 * @kind path-problem
 */

import go
import semmle.go.security.TaintedPath
import codeql.dataflow.test.ProvenancePathGraph
import semmle.go.dataflow.ExternalFlow
import ShowProvenance<interpretModelForTest/2, TaintedPath::Flow::PathNode, TaintedPath::Flow::PathGraph>

from TaintedPath::Flow::PathNode source, TaintedPath::Flow::PathNode sink
where TaintedPath::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on a $@.", source.getNode(),
  "user-provided value"
