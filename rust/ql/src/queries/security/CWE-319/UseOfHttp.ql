/**
 * @name Failure to use HTTPS URLs
 * @description Non-HTTPS connections can be intercepted by third parties.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id rust/non-https-url
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-345
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.UseOfHttpExtensions

/**
 * A taint configuration for HTTP URL strings that flow to URL-using sinks.
 */
module UseOfHttpConfig implements DataFlow::ConfigSig {
  import UseOfHttp

  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module UseOfHttpFlow = TaintTracking::Global<UseOfHttpConfig>;

import UseOfHttpFlow::PathGraph

from UseOfHttpFlow::PathNode sourceNode, UseOfHttpFlow::PathNode sinkNode
where UseOfHttpFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This URL may be constructed with the HTTP protocol, from $@.", sourceNode.getNode(),
  "this HTTP URL"
