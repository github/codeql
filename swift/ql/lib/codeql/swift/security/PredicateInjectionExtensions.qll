/** Provides classes and predicates to reason about predicate injection vulnerabilities. */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow

/** A data flow sink for predicate injection vulnerabilities. */
abstract class PredicateInjectionSink extends DataFlow::Node { }

/** A sanitizer for predicate injection vulnerabilities. */
abstract class PredicateInjectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to paths related to
 * predicate injection vulnerabilities.
 */
class PredicateInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
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
