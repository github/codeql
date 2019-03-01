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

    override predicate isSource(DataFlow::Node src) { src instanceof Source }

    override predicate isSanitizer(DataFlow::Node nd) {
      super.isSanitizer(nd)
      or
      // read of a property other than `stack`
      nd.(DataFlow::PropRead).getPropertyName() != "stack"
      or
      // `toString` does not include the stack trace
      nd.(DataFlow::MethodCallNode).getMethodName() = "toString"
      or
      nd = StringConcatenation::getAnOperand(_)
    }

    override predicate isSink(DataFlow::Node snk) { snk instanceof Sink }
  }

  /**
   * A read of the `stack` property of an exception, viewed as a data flow
   * sink for stack trace exposure vulnerabilities.
   */
  class DefaultSource extends Source, DataFlow::Node {
    DefaultSource() {
      // any exception is a source
      this = DataFlow::parameterNode(any(TryStmt try).getACatchClause().getAParameter())
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
