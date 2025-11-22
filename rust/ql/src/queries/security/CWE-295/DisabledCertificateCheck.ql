/**
 * @name Disabled TLS certificate check
 * @description An application that disables TLS certificate checking is more vulnerable to
 *              man-in-the-middle attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rust/disabled-certificate-check
 * @tags security
 *       external/cwe/cwe-295
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.DisabledCertificateCheckExtensions
import codeql.rust.Concepts

/**
 * A taint configuration for disabled TLS certificate checks.
 */
module DisabledCertificateCheckConfig implements DataFlow::ConfigSig {
  import DisabledCertificateCheckExtensions

  predicate isSource(DataFlow::Node node) {
    // the constant `true`
    node.asExpr().(BooleanLiteralExpr).getTextValue() = "true"
    or
    // a value controlled by a potential attacker
    node instanceof ActiveThreatModelSource
  }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module DisabledCertificateCheckFlow = TaintTracking::Global<DisabledCertificateCheckConfig>;

import DisabledCertificateCheckFlow::PathGraph

from
  DisabledCertificateCheckFlow::PathNode sourceNode, DisabledCertificateCheckFlow::PathNode sinkNode
where DisabledCertificateCheckFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "Disabling TLS certificate validation can expose the application to man-in-the-middle attacks."
