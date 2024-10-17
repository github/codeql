/**
 * @name Resolving XML external entity in user-controlled data
 * @description Parsing user-controlled XML documents and allowing expansion of external entity
 * references may lead to disclosure of confidential data or denial of service.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id java/xxe
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-776
 *       external/cwe/cwe-827
 */

base import semmle.code.java.dataflow.FlowSources as BaseFlowSources
base import semmle.code.java.dataflow.TaintTracking as BaseTaintTracking
base import semmle.code.java.security.XxeQuery as BaseXxeQuery
overlay import semmle.code.java.dataflow.FlowSources as OverlayFlowSources
overlay import semmle.code.java.dataflow.TaintTracking as OverlayTaintTracking
overlay import semmle.code.java.security.XxeQuery as OverlayXxeQuery
import semmle.code.java.dataflow.OverlayDataFlow

/**
 * A taint-tracking configuration for unvalidated remote user input that is used in XML external entity expansion.
 */
module XxeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asBase() instanceof BaseFlowSources::ThreatModelFlowSource and
    exists(OverlayXxeQuery::XxeSink sink)
    or
    source.asOverlay() instanceof OverlayFlowSources::ThreatModelFlowSource
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asBase() instanceof BaseXxeQuery::XxeSink and
    exists(OverlayFlowSources::ThreatModelFlowSource source)
    or
    sink.asOverlay() instanceof OverlayXxeQuery::XxeSink
  }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer.asBase() instanceof BaseXxeQuery::XxeSanitizer or
    sanitizer.asOverlay() instanceof OverlayXxeQuery::XxeSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(BaseXxeQuery::XxeAdditionalTaintStep s).step(n1.asBase(), n2.asBase()) or
    any(OverlayXxeQuery::XxeAdditionalTaintStep s).step(n1.asOverlay(), n2.asOverlay())
  }
}

/**
 * Detect taint flow of unvalidated remote user input that is used in XML external entity expansion.
 */
module XxeFlow = TaintTracking::Global<XxeConfig>;

import XxeFlow::PathGraph

from XxeFlow::PathNode source, XxeFlow::PathNode sink
where XxeFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "XML parsing depends on a $@ without guarding against external entity expansion.",
  source.getNode(), "user-provided value"
