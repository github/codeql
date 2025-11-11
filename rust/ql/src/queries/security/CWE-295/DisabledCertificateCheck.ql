/**
 * @name Disabled TLS certificate check
 * @description If an application disables TLS certificate checking, it may be vulnerable to
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
import codeql.rust.security.DisabledCertificateCheckExtensions

/**
 * A taint configuration for disabling TLS certificate checks.
 */
module LogInjectionConfig implements DataFlow::ConfigSig {
  import DisabledCertificateCheckExtensions

  predicate isSource(DataFlow::Node node) {
    node.asExpr().getExpr().(BooleanLiteralExpr).getTextValue() = "true"
  }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module DisabledCertificateCheckExtensionFlow = DataFlow::Global<LogInjectionConfig>;

import DisabledCertificateCheckExtensionFlow::PathGraph

from
  DisabledCertificateCheckExtensionFlow::PathNode sourceNode,
  DisabledCertificateCheckExtensionFlow::PathNode sinkNode
where DisabledCertificateCheckExtensionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "Disabling TLS certificate validation can expose the application to man-in-the-middle attacks."
