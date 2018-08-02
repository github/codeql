/**
 * Provides a taint tracking configuration for reasoning about SQL injection
 * vulnerabilities.
 */

import javascript

module SqlInjection {
  /**
   * A data flow source for SQL-injection vulnerabilities.
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
    Configuration() { this = "SqlInjection" }

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
  }

  /** A source of remote user input, considered as a flow source for SQL injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /** An SQL expression passed to an API call that executes SQL. */
  class SqlInjectionExprSink extends Sink, DataFlow::ValueNode {
    override SQL::SqlString astNode;
  }

  /** An expression that sanitizes a value for the purposes of SQL injection. */
  class SanitizerExpr extends Sanitizer, DataFlow::ValueNode {
    SanitizerExpr() {
      astNode = any(SQL::SqlSanitizer ss).getOutput()
    }
  }
}

/** DEPRECATED: Use `SqlInjection::Source` instead. */
deprecated class SqlInjectionSource = SqlInjection::Source;

/** DEPRECATED: Use `SqlInjection::Sink` instead. */
deprecated class SqlInjectionSink = SqlInjection::Sink;

/** DEPRECATED: Use `SqlInjection::Sanitizer` instead. */
deprecated class SqlInjectionSanitizer = SqlInjection::Sanitizer;

/** DEPRECATED: Use `SqlInjection::Configuration` instead. */
deprecated class SqlInjectionTrackingConfig = SqlInjection::Configuration;
