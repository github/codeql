/**
 * Provides a taint tracking configuration for reasoning about NoSQL injection
 * vulnerabilities.
 */

import javascript

module NosqlInjection {
  /**
   * A data flow source for NoSQL-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for SQL-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for SQL-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about SQL-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "NosqlInjection" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      // additional flow step to track taint through NoSQL query objects
      exists (NoSQL::Query query, DataFlow::SourceNode queryObj |
        queryObj.flowsToExpr(query) and
        queryObj.flowsTo(succ) and
        pred = queryObj.getAPropertyWrite().getRhs()
      )
    }
  }

  /** A source of remote user input, considered as a flow source for NoSQL injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /** An expression interpreted as a NoSQL query, viewed as a sink. */
  class NosqlQuerySink extends Sink, DataFlow::ValueNode {
    override NoSQL::Query astNode;
  }
}

/** DEPRECATED: Use `NosqlInjection::Source` instead. */
deprecated class NosqlInjectionSource = NosqlInjection::Source;

/** DEPRECATED: Use `NosqlInjection::Sink` instead. */
deprecated class NosqlInjectionSink = NosqlInjection::Sink;

/** DEPRECATED: Use `NosqlInjection::Sanitizer` instead. */
deprecated class NosqlInjectionSanitizer = NosqlInjection::Sanitizer;

/** DEPRECATED: Use `NosqlInjection::Configuration` instead. */
deprecated class NosqlInjectionTrackingConfig = NosqlInjection::Configuration;
