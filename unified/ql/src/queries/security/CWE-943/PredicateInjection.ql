/**
 * @name Predicate built from user-controlled sources
 * @description Building an NSPredicate from user-controlled sources may lead to attackers
 *              changing the predicate's intended logic.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id swift/predicate-injection
 * @tags security
 *       external/cwe/cwe-943
 */

import swift
import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.dataflow.ExternalFlow

// Copied from swift/ql/lib/codeql/swift/security/PredicateInjectionExtensions.qll.

/** Provides classes and predicates to reason about predicate injection vulnerabilities. */

/** A data flow sink for predicate injection vulnerabilities. */
abstract class PredicateInjectionSink extends DataFlow::Node { }

/** A barrier for predicate injection vulnerabilities. */
abstract class PredicateInjectionBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class PredicateInjectionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to predicate injection vulnerabilities.
   */
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultPredicateInjectionSink extends PredicateInjectionSink {
  DefaultPredicateInjectionSink() { sinkNode(this, "predicate-injection") }
}

private class PredicateInjectionSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NSPredicate;true;init(format:argumentArray:);;;Argument[0];predicate-injection",
        ";NSPredicate;true;init(format:arguments:);;;Argument[0];predicate-injection",
        ";NSPredicate;true;init(format:_:);;;Argument[0];predicate-injection",
        ";NSPredicate;true;init(fromMetadataQueryString:);;;Argument[0];predicate-injection"
      ]
  }
}

/**
 * A barrier for predicate injection vulnerabilities vulnerabilities.
 */
private class PredicateInjectionDefaultBarrier extends PredicateInjectionBarrier {
  PredicateInjectionDefaultBarrier() {
    // any numeric type
    this.asExpr().getType().getUnderlyingType().getABaseType*().getName() =
      ["Numeric", "SignedInteger", "UnsignedInteger"]
  }
}

// Copied from swift/ql/lib/codeql/swift/security/PredicateInjectionQuery.qll.

/**
 * Provides a taint-tracking configuration for reasoning about predicate injection
 * vulnerabilities.
 */

/**
 * A taint-tracking configuration for predicate injection vulnerabilities.
 */
module PredicateInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof PredicateInjectionSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof PredicateInjectionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(PredicateInjectionAdditionalFlowStep s).step(n1, n2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Detect taint flow of predicate injection vulnerabilities.
 */
module PredicateInjectionFlow = TaintTracking::Global<PredicateInjectionConfig>;

import PredicateInjectionFlow::PathGraph

from PredicateInjectionFlow::PathNode source, PredicateInjectionFlow::PathNode sink
where PredicateInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This predicate depends on a $@.", source.getNode(),
  "user-provided value"
