/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * stack trace exposure vulnerabilities, as well as extension points
 * for adding your own.
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
