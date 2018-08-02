/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used to construct
 * regular expressions.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

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

  /**
   * A source of remote user input, considered as a flow source for regular
   * expression injection.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * The first argument to an invocation of `RegExp` (with or without `new`).
   */
  class RegExpObjectCreationSink extends Sink, DataFlow::ValueNode {
    RegExpObjectCreationSink() {
      this = DataFlow::globalVarRef("RegExp").getAnInvocation().getArgument(0)
    }
  }

  /**
   * The argument of a call that coerces the argument to a regular expression.
   */
  class RegExpObjectCoercionSink extends Sink {

    RegExpObjectCoercionSink() {
      exists (MethodCallExpr mce, string methodName |
        mce.getReceiver().analyze().getAType() = TTString() and
        mce.getMethodName() = methodName |
        (methodName = "match" and this.asExpr() = mce.getArgument(0) and mce.getNumArgument() = 1) or
        (methodName = "search" and this.asExpr() = mce.getArgument(0) and mce.getNumArgument() = 1)
      )
    }

  }

  /**
   * A call to a function whose name suggests that it escapes regular
   * expression meta-characters.
   */
  class RegExpSanitizationCall extends Sanitizer, DataFlow::ValueNode {
    RegExpSanitizationCall() {
      exists (string calleeName, string sanitize, string regexp |
        calleeName = astNode.(CallExpr).getCalleeName() and
        sanitize = "(?:escape|saniti[sz]e)" and regexp = "regexp?" |
        calleeName.regexpMatch("(?i)(" + sanitize + regexp + ")" +
                                  "|(" + regexp + sanitize + ")")
      )
    }
  }
}

/** DEPRECATED: Use `RegExpInjection::Source` instead. */
deprecated class RegExpInjectionSource = RegExpInjection::Source;

/** DEPRECATED: Use `RegExpInjection::Sink` instead. */
deprecated class RegExpInjectionSink = RegExpInjection::Sink;

/** DEPRECATED: Use `RegExpInjection::Sanitizer` instead. */
deprecated class RegExpInjectionSanitizer = RegExpInjection::Sanitizer;

/** DEPRECATED: Use `RegExpInjection::Configuration` instead. */
deprecated class RegExpInjectionTaintTrackingConfiguration = RegExpInjection::Configuration;
