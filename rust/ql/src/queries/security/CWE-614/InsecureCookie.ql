/**
 * @name 'Secure' attribute is not set to true
 * @description Omitting the 'Secure' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'Secure' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind path-problem
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
 * 'secure' attribute set. This is the primary data flow configuration for this
 * query.
 */
module InsecureCookieConfig implements DataFlow::ConfigSig {
  import InsecureCookie

  predicate isSource(DataFlow::Node node) {
    // creation of a cookie or cookie configuration with default, insecure settings
    node instanceof Source
    or
    // setting the 'secure' attribute to false (or an unknown value)
    cookieSetNode(node, "secure", false)
  }

  predicate isSink(DataFlow::Node node) {
    // use of a cookie or cookie configuration
    node instanceof Sink
  }

  predicate isBarrier(DataFlow::Node node) {
    // setting the 'secure' attribute to true
    cookieSetNode(node, "secure", true)
    or
    node instanceof Barrier
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * A data flow configuration for tracking values representing cookies with the
 * 'partitioned' attribute set. This is a secondary data flow configuration used
 * to filter out unwanted results.
 */
module PartitionedCookieConfig implements DataFlow::ConfigSig {
  import InsecureCookie

  predicate isSource(DataFlow::Node node) {
    // setting the 'partitioned' attribute to true
    cookieSetNode(node, "partitioned", true)
  }

  predicate isSink(DataFlow::Node node) {
    // use of a cookie or cookie configuration
    node instanceof Sink
  }

  predicate isBarrier(DataFlow::Node node) {
    // setting the 'partitioned' attribute to false (or an unknown value)
    cookieSetNode(node, "partitioned", false)
    or
    node instanceof Barrier
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // only used negatively
  }
}

module InsecureCookieFlow = TaintTracking::Global<InsecureCookieConfig>;

module PartitionedCookieFlow = TaintTracking::Global<PartitionedCookieConfig>;

import InsecureCookieFlow::PathGraph

from InsecureCookieFlow::PathNode sourceNode, InsecureCookieFlow::PathNode sinkNode
where
  InsecureCookieFlow::flowPath(sourceNode, sinkNode) and
  not PartitionedCookieFlow::flow(_, sinkNode.getNode())
select sinkNode.getNode(), sourceNode, sinkNode, "Cookie attribute 'Secure' is not set to true."
