/**
 * @name Cross-site scripting
 * @description Writing user input directly to a webpage
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id rust/xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.XssExtensions

/**
 * A taint configuration for tainted data that reaches an XSS sink.
 */
module XssConfig implements DataFlow::ConfigSig {
  import Xss

  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module XssFlow = TaintTracking::Global<XssConfig>;

import XssFlow::PathGraph

from XssFlow::PathNode sourceNode, XssFlow::PathNode sinkNode
where XssFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "Cross-site scripting vulnerability due to a $@.",
  sourceNode.getNode(), "user-provided value"
