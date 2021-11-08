/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * logging of sensitive information, as well as extension
 * points for adding your own.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

module SensitiveInfoLog {
  /**
   * A data flow source for logging of sensitive information.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this data flow source. */
    abstract string describe();
  }

  /**
   * A data flow sink for logging of sensitive information.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for logging of sensitive information.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sensitive expression, viewed as a data flow source for logging
   * of sensitive information.
   */
  class SensitiveExprSource extends Source, DataFlow::ValueNode {
    override SensitiveExpr astNode;

    SensitiveExprSource() {
      // logging user names or account names isn't usually a problem
      astNode.getClassification() != SensitiveDataClassification::id()
    }

    override string describe() { result = astNode.describe() }
  }

  /**
   * An expression that is logged.
   */
  class LoggingSink extends Sink {
    LoggingSink() { this = any(LoggerCall console).getAMessageComponent() }
  }
}
