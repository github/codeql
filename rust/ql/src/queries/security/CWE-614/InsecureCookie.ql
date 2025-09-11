/**
 * @name 'Secure' attribute is not set to true
 * @description Omitting the 'Secure' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'Secure' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rust/insecure-cookie
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import InsecureCookieFlow::PathGraph

/**
 * A data flow configuration for tracking values representing cookies without the
 * 'secure' flag set.
 */
module InsecureCookieConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    // creation of a cookie with default settings (insecure)
    exists(CallExprBase ce |
      ce.getStaticTarget().getCanonicalPath() = "<cookie::Cookie>::build" and
      node.asExpr().getExpr() = ce
    )
  }

  predicate isSink(DataFlow::Node node) {
    // qualifier of a call to `.build`.
    exists(MethodCallExpr ce |
      ce.getStaticTarget().getCanonicalPath() = "<cookie::builder::CookieBuilder>::build" and
      node.asExpr().getExpr() = ce.getReceiver()
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module InsecureCookieFlow = TaintTracking::Global<InsecureCookieConfig>;

from InsecureCookieFlow::PathNode sourceNode, InsecureCookieFlow::PathNode sinkNode
where InsecureCookieFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "Cookie attribute 'Secure' is not set to true."
