/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * untrusted user input used to construct regular expressions, as well
 * as extension points for adding your own.
 */

import javascript

module RegExpInjection {
  /**
   * A data flow source for untrusted user input used to construct regular expressions.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for untrusted user input used to construct regular expressions.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for untrusted user input used to construct regular expressions.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source for regular
   * expression injection.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * The source string of a regular expression.
   */
  class RegularExpressionSourceAsSink extends Sink {
    RegularExpressionSourceAsSink() { isInterpretedAsRegExp(this) }
  }

  /**
   * A call to a function whose name suggests that it escapes regular
   * expression meta-characters.
   */
  class RegExpSanitizationCall extends Sanitizer, DataFlow::ValueNode {
    RegExpSanitizationCall() {
      exists(string calleeName, string sanitize, string regexp |
        calleeName = astNode.(CallExpr).getCalleeName() and
        sanitize = "(?:escape|saniti[sz]e)" and
        regexp = "regexp?"
      |
        calleeName.regexpMatch("(?i)(" + sanitize + regexp + ")" + "|(" + regexp + sanitize + ")")
      )
    }
  }
}
