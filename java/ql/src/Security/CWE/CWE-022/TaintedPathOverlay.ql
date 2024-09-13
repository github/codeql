/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/path-injection
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */

base import semmle.code.java.security.TaintedPathQuery as BaseTaintedPathQuery
base import semmle.code.java.security.Sanitizers as BaseSanitizers
overlay import semmle.code.java.security.TaintedPathQuery as OverlayTaintedPathQuery
overlay import semmle.code.java.security.Sanitizers as OverlaySanitizers
import semmle.code.java.dataflow.OverlayDataFlow

/**
 * A taint-tracking configuration for tracking flow from remote sources to the creation of a path.
 */
module TaintedPathConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asBase() instanceof BaseTaintedPathQuery::ThreatModelFlowSource and
    exists(OverlayTaintedPathQuery::TaintedPathSink sink)
    or
    source.asOverlay() instanceof OverlayTaintedPathQuery::ThreatModelFlowSource
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asBase() instanceof BaseTaintedPathQuery::TaintedPathSink and
    exists(OverlayTaintedPathQuery::ThreatModelFlowSource source)
    or
    sink.asOverlay() instanceof OverlayTaintedPathQuery::TaintedPathSink
  }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer.asBase() instanceof BaseSanitizers::SimpleTypeSanitizer or
    sanitizer.asBase() instanceof BaseTaintedPathQuery::PathInjectionSanitizer or
    sanitizer.asOverlay() instanceof OverlaySanitizers::SimpleTypeSanitizer or
    sanitizer.asOverlay() instanceof OverlayTaintedPathQuery::PathInjectionSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(BaseTaintedPathQuery::TaintedPathAdditionalTaintStep s).step(n1.asBase(), n2.asBase()) or
    any(OverlayTaintedPathQuery::TaintedPathAdditionalTaintStep s)
        .step(n1.asOverlay(), n2.asOverlay())
  }
}

/** Tracks flow from remote sources to the creation of a path. */
module TaintedPathFlow = TaintTracking::Global<TaintedPathConfig>;

import TaintedPathFlow::PathGraph

from TaintedPathFlow::PathNode source, TaintedPathFlow::PathNode sink
where TaintedPathFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on a $@.", source.getNode(),
  "user-provided value"
