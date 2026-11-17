/**
 * @name JavaScript Injection
 * @description Evaluating JavaScript code containing a substring from a remote source may lead to remote code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision medium
 * @id unified/swift/unsafe-js-eval
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-749
 */

import unified

/**
 * A taint configuration from taint sources to sinks for this query.
 */
module UnsafeJsEvalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { Models::isSource(node, _) }

  predicate isSink(DataFlow::Node node) { Models::isSink(node, "code-injection") }

  predicate isBarrier(DataFlow::Node node) {
    // TODO: Port the numeric-type barrier from original Swift's UnsafeJsEvalExtensions.qll.
    none()
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // TODO: Port the base-address flow step from original Swift's UnsafeJsEvalExtensions.qll.
    none()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Detect taint flow of taint sources to sinks for this query.
 */
module UnsafeJsEvalFlow = TaintTracking::Global<UnsafeJsEvalConfig>;

import UnsafeJsEvalFlow::PathGraph

from UnsafeJsEvalFlow::PathNode source, UnsafeJsEvalFlow::PathNode sink
where UnsafeJsEvalFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Evaluation of uncontrolled JavaScript from a remote source."
