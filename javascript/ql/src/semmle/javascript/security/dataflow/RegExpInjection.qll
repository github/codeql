/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used to construct
 * regular expressions.
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
   * A taint-tracking configuration for untrusted user input used to construct regular expressions.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "RegExpInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

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
