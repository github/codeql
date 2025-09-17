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
import codeql.rust.security.InsecureCookieExtensions

/**
 * A data flow configuration for tracking values representing cookies without the
 * 'secure' attribute set.
 */
module InsecureCookieConfig implements DataFlow::ConfigSig {
  import InsecureCookie

  predicate isSource(DataFlow::Node node) {
    // creation of a cookie or cookie configuration with default, insecure settings
    node instanceof Source
  }

  predicate isSink(DataFlow::Node node) {
    // use of a cookie or cookie configuration
    node instanceof Sink
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Barrier
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module InsecureCookieFlow = TaintTracking::Global<InsecureCookieConfig>;

import InsecureCookieFlow::PathGraph

from InsecureCookieFlow::PathNode sourceNode, InsecureCookieFlow::PathNode sinkNode
where
  InsecureCookieFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "Cookie attribute 'Secure' is not set to true."
