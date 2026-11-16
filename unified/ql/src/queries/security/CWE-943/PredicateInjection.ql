/**
 * @name Predicate built from user-controlled sources
 * @description Building an NSPredicate from user-controlled sources may lead to attackers
 *              changing the predicate's intended logic.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id unified/swift/predicate-injection
 * @tags security
 *       external/cwe/cwe-943
 */

import unified

/**
 * A taint-tracking configuration for predicate injection vulnerabilities.
 */
module PredicateInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { Models::isSource(node, _) }

  predicate isSink(DataFlow::Node node) { Models::isSink(node, "predicate-injection") }

  predicate isBarrier(DataFlow::Node node) {
    // TODO: Port the numeric-type barrier from original Swift's PredicateInjectionExtensions.qll.
    none()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module PredicateInjectionFlow = TaintTracking::Global<PredicateInjectionConfig>;

import PredicateInjectionFlow::PathGraph

from PredicateInjectionFlow::PathNode source, PredicateInjectionFlow::PathNode sink
where PredicateInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This predicate depends on a $@.", source.getNode(),
  "user-provided value"
