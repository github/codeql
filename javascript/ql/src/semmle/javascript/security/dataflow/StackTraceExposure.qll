/**
 * Provides a taint-tracking configuration for reasoning about stack trace
 * exposure problems.
 */

import javascript

module StackTraceExposure {
  /**
   * A data flow source for stack trace exposure vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for stack trace exposure vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "StackTraceExposure" }

    override predicate isSource(DataFlow::Node src) {
      src instanceof Source
    }

    override predicate isSink(DataFlow::Node snk) {
      snk instanceof Sink
    }
  }

  /**
   * A read of the `stack` property of an exception, viewed as a data flow
   * sink for stack trace exposure vulnerabilities.
   */
  class DefaultSource extends Source, DataFlow::ValueNode {
    DefaultSource() {
      // any read of the `stack` property of an exception is a source
      exists (Parameter exc |
        exc = any(TryStmt try).getACatchClause().getAParameter() and
        this = DataFlow::parameterNode(exc).getAPropertyRead("stack")
      )
    }
  }
  
  /**
   * An expression that can become part of an HTTP response body, viewed
   * as a data flow sink for stack trace exposure vulnerabilities.
   */
  class DefaultSink extends Sink, DataFlow::ValueNode {
    override HTTP::ResponseBody astNode;
  }
}

/** DEPRECATED: Use `StackTraceExposure::Source` instead. */
deprecated class StackTraceExposureSource = StackTraceExposure::Source;

/** DEPRECATED: Use `StackTraceExposure::Sink` instead. */
deprecated class StackTraceExposureSink = StackTraceExposure::Sink;

/** DEPRECATED: Use `StackTraceExposure::Configuration` instead. */
deprecated class StackTraceExposureTrackingConfig = StackTraceExposure::Configuration;
